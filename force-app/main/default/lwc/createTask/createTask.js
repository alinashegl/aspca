import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getRecordInfo from '@salesforce/apex/CreateTaskLWCController.getRecordInfo';
import getBehCaseWorker from '@salesforce/apex/CreateTaskLWCController.getBehCaseWorker';
import insertTask from '@salesforce/apex/CreateTaskLWCController.insertTask';

import TASK_RECORDTYPE_FIELD from '@salesforce/schema/Task.RecordTypeId';
import TASK_SUBJECT_FIELD from '@salesforce/schema/Task.Subject';
import TASK_STATUS_FIELD from '@salesforce/schema/Task.Status';
import TASK_ACTIVITY_DATE_FIELD from '@salesforce/schema/Task.ActivityDate';
import TASK_DESCRIPTION_FIELD from '@salesforce/schema/Task.Description';
import TASK_WHO_FIELD from '@salesforce/schema/Task.WhoId';
import TASK_ANIMAL_FIELD from '@salesforce/schema/Task.Animal__c';

import ANIMAL_ID_FIELD from '@salesforce/schema/Animal__c.Id';
import ANIMAL_BEHAVIOR_CASE_WORKER_FIELD from '@salesforce/schema/Animal__c.Behavior_Case_Worker__c';

export default class CreateTask extends NavigationMixin(LightningElement) {
    recordTypeField = TASK_RECORDTYPE_FIELD;
    subjectField = TASK_SUBJECT_FIELD;
    statusField = TASK_STATUS_FIELD;
    activityDateField = TASK_ACTIVITY_DATE_FIELD;
    descriptionField = TASK_DESCRIPTION_FIELD;
    whoIdField = TASK_WHO_FIELD;
    animalField = TASK_ANIMAL_FIELD;

    animalIdField = ANIMAL_ID_FIELD;
    animalBehCaseWorkerField = ANIMAL_BEHAVIOR_CASE_WORKER_FIELD;

    @api recordId;
    info;

    error;
    errorMessage;
    showSpinner = false;
    taskLink = false;

    statusValue;
    subjectValue;
    recordTypeValue;
    dueDateValue;
    commentsValue;

    @wire(getRecordInfo, {recordId : '$recordId'})
    response(result){
        window.console.log("getRecordInfo");
        if(result.data){
            this.info = result.data;
            window.console.log("this.info: ", JSON.stringify(this.info));
            if(this.info.animal){
                this.customLookupValueDogId = this.info.animal.Id;
            }
            this.recordTypeValue = this.info?.defaultRecordType ? this.info.defaultRecordType : null;
            this.dueDateValue = this.info.dueToday;
        }
        this.resetFields();
    }

    handleSave(){
        this.error = null;
        const task = {};
        task[this.whoIdField.fieldApiName] = this.customLookupValueContactId;
        task[this.animalField.fieldApiName] = this.customLookupValueDogId;

        const comboboxAllValid = [
            ...this.template.querySelectorAll('lightning-combobox'),
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            task[inputCmp.name] = inputCmp.value;
            return validSoFar && inputCmp.checkValidity();
        }, true);

        const inputAllValid = [
            ...this.template.querySelectorAll('lightning-input'),
        ].reduce((validSoFar, inputCmp) => {
            task[inputCmp.name] = inputCmp.value;
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);

        window.console.log('task: ', JSON.stringify(task));

        if(comboboxAllValid && inputAllValid){
            this.showSpinner = true;
            insertTask({task : task})
            .then((result) => {
                window.console.log('inserted Task: ', result);
                this.taskLink = result;
                this.resetFields();
            })
            .catch(error => {
                this.error = error;
                this.errorMessage = 'Error inserting task: ';
            })
            .finally(() => {
                this.showSpinner = false;
            });
        }

    }

    handleCancel(){
        this.resetFields();
        this.resetLookupFields();
    }

    handleStatusChange(event){
        this.statusValue = event.target.value;
    }

    handleSubjectChange(event){
        this.subjectValue = event.target.value;
    }

    handleRecordTypeChange(event){
        this.recordTypeValue = event.target.value;
    }

    handleDueDateChange(event){
        this.dueDateValue = event.target.value;
    }

    handleCommentsBlue(event){
        this.commentsValue = event.target.value;
    }

    resetFields(){
        this.statusValue = 'Not Started';
        this.subjectValue = null;
        this.recordTypeValue = this.info?.defaultRecordType ? this.info.defaultRecordType : null;
        this.commentsValue = null;
        if(this.info?.animal){
            this.customLookupValueDogId = this.info.animal.Id;
            if(this.info.animal.Behavior_Case_Worker__c){
                this.customLookupValueContactId = this.info.animal.Behavior_Case_Worker__c;
            }
        }
        this.error = null;
        this.showSpinner = false;
    }

    resetLookupFields(){
        this.template.querySelector('.datefield').value = this.info?.dueToday;

        if(this.info?.animal){
            this.customLookupValueDogId = this.info.animal.Id;
            this.getBehaviorCaseWorker();
        } else {
            this.template.querySelectorAll('c-custom-lookup').forEach(element => {
                element.reset();    
            });
        }

    }

    getBehaviorCaseWorker(){
        if(this.customLookupValueDogId){
            getBehCaseWorker({animalId : this.customLookupValueDogId})
            .then((result) => {
                window.console.log("behaviorCaseWorker result: ", result);
                if(result != null){
                    this.customLookupValueContactId = result;
                }
            })
            .catch(error => {
                this.error = error;
                this.errorMessage = 'Error retrieving Behavior Case Worker for dog: ';
            })
            .finally(() => {
            });
        }
    }

    get statusOptions() {
        return [
            { label: 'Not Started', value: 'Not Started' },
            { label: 'In Progress', value: 'In Progress' },
            { label: 'Completed', value: 'Completed' }
        ];
    }

    get subjectOptions(){
        if(this.info?.subjectOptions){
            let options = [];
            this.info.subjectOptions.forEach(element => {
                options.push({label: element, value: element});
            });
            return options;
        }
    }

    get recordTypeOptions(){
        if(this.info?.recordTypeOptions){
            let options = [];
            this.info.recordTypeOptions.forEach(element => {
                options.push({label: element.Name, value: element.Id});
            });
            return options;
        }
    }

    get disableSaveButton(){
        return !(this.customLookupValueDogId && this.customLookupValueContactId);
    }

    //Contact custom lookup
    customLookupValueContactId;
    customLookupExpandedFieldContact = false;

    get customLookupFieldsContact(){
        return ["Name","Email","Title"];
    }

    get customLookupDisplayFieldsContact(){
        return 'Name, Email, Title';
    }

    get customLookupWhereClauseContact(){
        return ' Contact_Type__c = \'Behavior Case Worker\'';
    }

    get customLookupContacteSize(){
        return this.customLookupExpandedFieldContact ? '12' : '6';
    }

    customLookupEventContact(event){
        this.customLookupValueContactId = event.detail.data.recordId;
    }

    handleCustomLookupExpandSearchContact(event){
        let data = event.detail.data;
        this.customLookupExpandedFieldContact = data.expandField;
    }

    //Dog custom look up
    customLookupValueDogId;
    customLookupExpandedFieldDog = false;

    customLookupEventDog(event){
        this.customLookupValueDogId = event.detail.data.recordId;
        this.getBehaviorCaseWorker();
    }

    handleCustomLookupExpandSearchDog(event){
        let data = event.detail.data;
        this.customLookupExpandedFieldDog = data.expandField;
    }

    get customLookupFieldsDog(){
        return ["Animal_Name_Id__c","Current_Location__c"];
    }

    get customLookupDisplayFieldsDog(){
        return 'Animal_Name_Id__c, Current_Location__c';
    }

    get customLookupWhereClauseDog(){
        return ' Active_Animal__c = true AND Location_Filter__c = true ';
    }
    
    get customLookupDogSize(){
        return this.customLookupExpandedFieldDog ? '12' : '6';
    }

}