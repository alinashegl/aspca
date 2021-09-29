import { LightningElement, api, wire } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';

import PROTOCOL_ID_FIELD from '@salesforce/schema/Session_Protocol__c.Id';
import FEAR_BEST_FIELD from '@salesforce/schema/Session_Protocol__c.Fear_Best__c';
import FEAR_WORST_FIELD from '@salesforce/schema/Session_Protocol__c.Fear_Worst__c';
import AGGRESIVE_WORST_FIELD from '@salesforce/schema/Session_Protocol__c.Aggressive_Worst__c';
import AROUSAL_BEST_FIELD from '@salesforce/schema/Session_Protocol__c.Arousal_Best__c';
import AROUSAL_WORST_FIELD from '@salesforce/schema/Session_Protocol__c.Arousal_Worst__c';
import SOCIAL_BEST_FIELD from '@salesforce/schema/Session_Protocol__c.Social_Best__c';
import OVERALL_SCORE_FIELD from '@salesforce/schema/Session_Protocol__c.Overall_Score__c';
import IS_SKIPPED_FIELD from '@salesforce/schema/Session_Protocol__c.IsSkipped__c';
import IS_REMOVED_FIELD from '@salesforce/schema/Session_Protocol__c.IsRemoved__c';
import NEEDS_REVIEW_FIELD from '@salesforce/schema/Session_Protocol__c.Needs_Review__c';
import PROTOCOL_NOTES_FIELD from '@salesforce/schema/Session_Protocol__c.Protocol_Notes__c';
import PREFERRED_MOTIVATORS_FIELD from '@salesforce/schema/Session_Protocol__c.Preferred_Motivators__c';

import getActiveProtocolsAndFields from '@salesforce/apex/TreatmentSessionLWCController.getActiveProtocolAndFieldsNew';

import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class TreatmentSessionProtocol extends LightningElement {
    @api recordId;
    @api sessionId;
    @api protocolName;
    @api showPicklist = false;
    @api canRemoveProtocol = false;

    showModal = false;

    fieldValues = [];
    tempFieldValues = [];

    protocolInfo;
    loading = false;

    protocolStatus = 'NotStarted';
    inputval;

    connectedCallback(){
        this.loading = true;
        this.fieldValues = [];
        getActiveProtocolsAndFields({'protocolId': this.recordId})
        .then(result => {
            if (result) {
                this.protocolInfo = result;
                this.protocolInfo.picklistFields.forEach(element => {
                    this.fieldValues.push({name: element.apiName, value: element.currentValue});
                    this.tempFieldValues.push({name: element.apiName, value: element.currentValue});
                });
            }
        })
        .catch(error => {
            window.console.log('connectedCallback: -------error-------------'+error);
            window.console.log('error: ', error);
        })
        .finally(() => {
            this.loading = false;
        });
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
        this.protocolInfo.isSkipped = !this.protocolInfo.isSkipped;
        if(this.protocolInfo.isSkipped == true){
            this.resetProtocol('skip');
        } else {
            this.prepProtocolFields();
        }
    }

    handleSkipAndRemove(){
        this.loading = true;
        this.protocolInfo.isSkipped = true;
        this.protocolInfo.isRemoved = true;
        this.resetProtocol('remove');
        this.showModal = false;
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
        fields[IS_SKIPPED_FIELD.fieldApiName] = this.protocolInfo.isSkipped;

        if(action==='remove'){
            fields[IS_REMOVED_FIELD.fieldApiName] = this.protocolInfo.isRemoved;
        }

        this.updateProtocol(fields);
    }

    prepProtocolFields(){
        const fields = {};
        fields[PROTOCOL_ID_FIELD.fieldApiName] = this.recordId;
        fields[IS_SKIPPED_FIELD.fieldApiName] = this.protocolInfo.isSkipped;
        fields[IS_REMOVED_FIELD.fieldApiName] = this.protocolInfo.isRemoved;
        fields[NEEDS_REVIEW_FIELD.fieldApiName] = this.template.querySelector("lightning-input[data-name=needsReview]").checked;
        fields[FEAR_BEST_FIELD.fieldApiName] = this.fieldValues.find(field => field.name == FEAR_BEST_FIELD.fieldApiName).value;
        fields[FEAR_WORST_FIELD.fieldApiName] = this.fieldValues.find(field => field.name == FEAR_WORST_FIELD.fieldApiName).value;
        fields[AGGRESIVE_WORST_FIELD.fieldApiName] = this.fieldValues.find(field => field.name == AGGRESIVE_WORST_FIELD.fieldApiName).value;
        fields[AROUSAL_BEST_FIELD.fieldApiName] = this.fieldValues.find(field => field.name == AROUSAL_BEST_FIELD.fieldApiName).value;
        fields[AROUSAL_WORST_FIELD.fieldApiName] = this.fieldValues.find(field => field.name == AROUSAL_WORST_FIELD.fieldApiName).value;
        fields[SOCIAL_BEST_FIELD.fieldApiName] = this.fieldValues.find(field => field.name == SOCIAL_BEST_FIELD.fieldApiName).value;
        fields[OVERALL_SCORE_FIELD.fieldApiName] = this.fieldValues.find(field => field.name == OVERALL_SCORE_FIELD.fieldApiName).value;
        fields[PROTOCOL_NOTES_FIELD.fieldApiName] = this.template.querySelector("lightning-textarea[data-name=protocolNotes]").value;
        fields[PREFERRED_MOTIVATORS_FIELD.fieldApiName] = this.template.querySelector("lightning-input[data-name=preferredMotivators]").value;

        this.updateProtocol(fields);
    }

    getFieldValue(fieldName){
        window.console.log('found it: ', this.protocolInfo.picklistFields.name.find(fieldName));

        // let value = '';
        // this.protocolInfo.picklistFields.forEach(element => {
        //     window.console.log('current element: ', element);
        //     if(element.name === fieldName){
        //         window.console.log('match: ', fieldName, ' : ', element.currentValue);
        //         return element.currentValue;
        //     }
        // });
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
            this.connectedCallback();
        });
    }

    closeModal() {
        this.fieldValues = this.tempFieldValues;
        this.showModal = false;
        // this.connectedCallback();
    }

    get iconName(){
        if(this.protocolInfo.isSkipped){
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
        if(this.protocolInfo.isSkipped){
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

    get protocolButtonStatus(){
        return !this.protocolInfo;
    }

    get skipButtonLabel(){
        return this.protocolInfo.isSkipped? "Cancel Skip" : "Skip";
    }

    get removeButtonLabel(){
        return this.protocolInfo.isSkipped? "Cancel Skip and Remove from Plan" : "Skip and Remove from Plan";
    }
}



    // toggleForm = false;
    // @wire(getPicklistValues, {
    //     recordTypeId: '',
    //     fieldApiName: FEAR_BEST_FIELD
    // })
    // fearBestField;

    // @wire(getPicklistValues, {
    //     recordTypeId: '',
    //     fieldApiName: FEAR_WORST_FIELD
    // })
    // fearWorstField;

    // connectedCallback_old(){
    //     this.loading = true;
    //     getActiveProtocolsAndFields({'sessionId': this.sessionId})
    //     .then(result => {
    //         if (result) {
    //             this.activeProtocols = result.protocols;
    //             this.fearBestField = result.fearBestField;
    //             this.fearWorstField = result.fearWorstField;
    //         }

    //         window.console.log('activeProtocols: ', JSON.stringify(this.activeProtocols));
    //         window.console.log('fearBestField: ', this.fearBestField);
    //         window.console.log('fearWorstField: ', this.fearWorstField);
    //     })
    //     .catch(error => {
    //         // this.showLogs('connectedCallback: -------error-------------'+error);
    //         window.console.log('error: ', error);
    //     })
    //     .finally(() => {
    //         this.loading = false;
    //     });
    // }