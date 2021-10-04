import { LightningElement, api, wire } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';

import PROTOCOL_ID_FIELD from '@salesforce/schema/Session_Protocol__c.Id';
import IS_SKIPPED_FIELD from '@salesforce/schema/Session_Protocol__c.IsSkipped__c';
import IS_REMOVED_FIELD from '@salesforce/schema/Session_Protocol__c.IsRemoved__c';
import NEEDS_REVIEW_FIELD from '@salesforce/schema/Session_Protocol__c.Needs_Review__c';
import PROTOCOL_NOTES_FIELD from '@salesforce/schema/Session_Protocol__c.Protocol_Notes__c';
import PREFERRED_MOTIVATORS_FIELD from '@salesforce/schema/Session_Protocol__c.Preferred_Motivators__c';

import getActiveProtocolsAndFields from '@salesforce/apex/TreatmentSessionLWCController.getActiveProtocolAndFields';

import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class TreatmentSessionProtocol extends LightningElement {
    @api recordId;
    @api sessionId;
    @api protocolName;
    @api showPicklist = false;
    @api canRemoveProtocol = false;

    showModal = false;
    wireResponse;

    fieldValues = [];
    protocolInfo;
    error;
    loading = true;
    isSkipped = false;
    isRemoved = false;

    @wire(getActiveProtocolsAndFields, {protocolId: '$recordId'})
    response(result) {
        this.wireResponse = result;
        if (result.data) {
            this.protocolInfo = result.data;
            this.error = undefined;
            this.setFieldValues(result.data);
        } else if (result.error) {
            this.error = result.error;
            this.protocolInfo = undefined;
            this.loading = false;
        }
    }

    setFieldValues(data){
        window.console.log('setFieldValues');
        this.fieldValues = [];
        data.picklistFields.forEach(element => {
            this.fieldValues.push({name: element.apiName, value: element.currentValue});
        });
        this.isSkipped = data.isSkipped;
        this.isRemoved = data.isRemoved;
        this.loading = false;
    }

    handleClick(){
        this.showModal = true;
        window.console.log(this.protocolName, 'has been clicked');
    }

    handleSubmit(){
        this.prepProtocolFields();
        this.showModal = false;
    }

    handleSkip(){
        this.loading = true;
        this.isSkipped = !this.isSkipped;
        if(this.isSkipped == true){
            this.resetProtocol('skip');
        } else {
            const fields = {};
            fields[PROTOCOL_ID_FIELD.fieldApiName] = this.recordId;
            fields[IS_SKIPPED_FIELD.fieldApiName] = this.isSkipped;
            this.updateProtocol(fields);
        }
    }

    handleSkipAndRemove(){
        this.loading = true;
        this.isSkipped = !this.isRemoved;
        this.isRemoved = !this.isRemoved;
        if(this.isRemoved == true){
            this.resetProtocol('remove');
            this.showModal = false;
        } else {
            const fields = {};
            fields[PROTOCOL_ID_FIELD.fieldApiName] = this.recordId;
            fields[IS_SKIPPED_FIELD.fieldApiName] = this.isSkipped;
            fields[IS_REMOVED_FIELD.fieldApiName] = this.isRemoved;
            this.updateProtocol(fields);
        }
        
    }

    handleRadioChange(event) {
        const selectedOption = event.detail.value;
        const fieldName = event.target.dataset.fname;
        window.console.log('selectedOption: ', selectedOption);
        window.console.log('event.detail.dataset = ', event.target.dataset.fname);
        this.updateProtocolInfo(selectedOption, fieldName);
    }

    updateProtocolInfo(selectedOption, fieldName){
        this.fieldValues.find(field => field.name == fieldName).value = selectedOption;
        window.console.log('this.fieldValues: ', this.fieldValues);
    }

    resetProtocol(action){
        const fields = {};
        fields[PROTOCOL_ID_FIELD.fieldApiName] = this.recordId;
        fields[IS_SKIPPED_FIELD.fieldApiName] = this.isSkipped;

        if(action==='remove'){
            fields[IS_REMOVED_FIELD.fieldApiName] = this.isRemoved;
        }

        this.updateProtocol(fields);
    }

    prepProtocolFields(){
        const fields = {};
        fields[PROTOCOL_ID_FIELD.fieldApiName] = this.recordId;
        fields[IS_SKIPPED_FIELD.fieldApiName] = this.isSkipped;
        fields[IS_REMOVED_FIELD.fieldApiName] = this.isRemoved;
        fields[NEEDS_REVIEW_FIELD.fieldApiName] = this.template.querySelector("lightning-input[data-name=needsReview]").checked;
        fields[PROTOCOL_NOTES_FIELD.fieldApiName] = this.template.querySelector("lightning-textarea[data-name=protocolNotes]").value;
        fields[PREFERRED_MOTIVATORS_FIELD.fieldApiName] = this.template.querySelector("lightning-input[data-name=preferredMotivators]").value;
        
        this.fieldValues.forEach(element => {
            fields[element.name] = element.value;
        });

        window.console.log('fields =', JSON.stringify(fields));
        this.updateProtocol(fields);
    }

    updateProtocol(fields){
        window.console.log("fields: ", JSON.stringify(fields));
        const recordUpdate = {fields};
        updateRecord(recordUpdate).then(recordUpdate => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Protocol updated',
                    variant: 'success',
                }),
            );
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Unable to upate protocol',
                    message: error.body.message,
                    variant: 'error',
                }),
            );
        })
        .finally(() => {
            return refreshApex(this.wireResponse);
        });
    }

    closeModal() {
        this.showModal = false;
    }

    get iconName(){
        if(this.isSkipped){
            return 'utility:error';
        }
        else if(this.isComplete){
            return 'utility:success';
        }
        else {
            return 'utility:warning';
        }
    }

    get iconVariant(){
        if(this.isSkipped){
            return 'error';
        }
        else if(this.isComplete){
            return 'success';
        }
        else {
            return 'warning';
        }
    }

    get isComplete(){
        const incompleteField = this.fieldValues.find(field => field.value == null);
        return  incompleteField == null;
    }

    get showSkipButton(){
        return !this.isRemoved;
    }

    get protocolButtonStatus(){
        return !this.protocolInfo;
    }

    get skipButtonLabel(){
        return this.isSkipped? "Cancel Skip" : "Skip";
    }

    get removeButtonLabel(){
        return this.isRemoved? "Cancel Skip and Remove from Plan" : "Skip and Remove from Plan";
    }
}