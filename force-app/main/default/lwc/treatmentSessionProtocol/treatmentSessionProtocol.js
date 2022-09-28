import { LightningElement, api, wire } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getActiveProtocolAndFields from '@salesforce/apex/TreatmentSessionLWCController.getActiveProtocolAndFields';
import getProtocolStatus from '@salesforce/apex/TreatmentSessionLWCController.getProtocolStatus';
import PROTOCOL_ID_FIELD from '@salesforce/schema/Session_Protocol__c.Id';
import IS_SKIPPED_FIELD from '@salesforce/schema/Session_Protocol__c.IsSkipped__c';
import IS_REMOVED_FIELD from '@salesforce/schema/Session_Protocol__c.IsRemoved__c';
import NEEDS_REVIEW_FIELD from '@salesforce/schema/Session_Protocol__c.Needs_Review__c';
import PROTOCOL_NOTES_FIELD from '@salesforce/schema/Session_Protocol__c.Protocol_Notes__c';
//import PREFERRED_MOTIVATORS_FIELD from '@salesforce/schema/Session_Protocol__c.Preferred_Motivators__c';
import PLAN_PROTOCOL_ID_FIELD from '@salesforce/schema/Plan_Protocol__c.Id';
import PLAN_PROTOCOL_NOTES_FIELD from '@salesforce/schema/Plan_Protocol__c.Protocol_Notes__c';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';

export default class TreatmentSessionProtocol extends NavigationMixin(LightningElement) {
    @api recordId;
    @api sessionId;
    @api protocolName;
    @api showPicklist = false;
    @api canRemoveProtocol = false;

    fieldValues = [];
    protocolInfo;

    error;
    loading = true;
    isSkipped = false;
    isRemoved = false;
    protocolStatus = 'Incomplete';
    toggleView = false;

    _refresh;
    @api
    get refresh() {
        return this._refresh;
    }
    set refresh(value) {
        this._refresh = value;
        this.getProtocolInfo();
    }

    useRefreshedData = true;

    getProtocolInfo(){
        this.protocolInfo = null;
        getActiveProtocolAndFields({protocolId: this.recordId})
        .then((result) => {
            if (result) {
                this.protocolInfo = result;
                this.error = undefined;
                this.setFieldValues(result);
            } else if (result.error) {
                this.error = result.error;
                this.protocolInfo = undefined;
            }
        })
        .finally(() => {
            this.loading = false;
        });
    }

    handleRefresh(){
        window.console.log("handleRefreshStatus");
        getProtocolStatus({protocolId: this.recordId})
        .then((result) => {
            if(result) {
                this.protocolStatus = result;
            } else if (result.error) {
                this.error = result.error;
            }
        });
    }

    setFieldValues(data){
        this.isSkipped = data.isSkipped;
        this.isRemoved = data.isRemoved;
        this.protocolStatus = data.statusText;
        this.loading = false;
    }

    handleSubmit(){
        this.prepProtocolFields();
        this.prepPlanProtocolFields();
        this.toggleView = !this.toggleView;
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
            this.toggleView = !this.toggleView;
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
        this.updateProtocolInfo(selectedOption, fieldName);
    }

    updateProtocolInfo(selectedOption, fieldName){
        this.fieldValues.find(field => field.name == fieldName).value = selectedOption;
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
        //fields[PREFERRED_MOTIVATORS_FIELD.fieldApiName] = this.template.querySelector("lightning-input[data-name=preferredMotivators]").value;
        
        this.fieldValues.forEach(element => {
            fields[element.name] = element.value;
        });
        this.updateProtocol(fields);
    }

    prepPlanProtocolFields(){
        const fields ={};
        fields[PLAN_PROTOCOL_ID_FIELD.fieldApiName] = this.protocolInfo.planProtocolId;
        if(this.protocolInfo.isNonMRC){
            fields[PLAN_PROTOCOL_NOTES_FIELD.fieldApiName] = this.template.querySelector("lightning-textarea[data-name=planProtocolNotes]").value;
        }
        this.updatePlanProtocol(fields);
    }

    updateProtocol(fields){
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
            this.getProtocolInfo();
        });
    }

    updatePlanProtocol(fields){
        const recordUpdate = {fields};
        updateRecord(recordUpdate).then(recordUpdate => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Plan Protocol updated',
                    variant: 'success',
                }),
            );
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Unable to update plan protocol',
                    message: error.body.message,
                    variant: 'error',
                }),
            );
        })
        .finally(() => {
            this.getProtocolInfo();
        });
    }

    handleToggleView(){
        this.toggleView = !this.toggleView;
    }

    handleBoxLink(){
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: this.protocolInfo.boxLink
            }
        };
        this[NavigationMixin.Navigate](config);
    }

    handleConfigLink(event){
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: event.target.dataset.link
            }
        };
        this[NavigationMixin.Navigate](config);
    }

    get displayBoxLink(){
        return this.protocolInfo && this.protocolInfo.boxLink;
    }

    get toggleButtonIconName(){
        return this.toggleView ? 'utility:chevrondown' : 'utility:chevronright';
    }

    get protocolStatusIconName(){
        if(this.protocolInfo == undefined){
            return 'utility:spinner'
        }
        else if(this.isSkipped){
            return 'utility:error';
        }
        else if(this.isComplete){
            return 'utility:success';
        }
        else {
            return 'utility:warning';
        }
    }

    get protocolStatusIconVariant(){
        if(this.protocolInfo == undefined){
            return ''
        }
        else if(this.isSkipped){
            return 'error';
        }
        else if(this.isComplete){
            return 'success';
        }
        else {
            return 'warning';
        }
    }

    get protocolStatusIconText(){
        if(this.protocolInfo == undefined){
            return ''
        }
        else if(this.isSkipped){
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
        return this.protocolStatus == 'Complete';
    }

    get showSkipButton(){
        return !this.isRemoved;
    }

    get protocolButtonStatus(){
        return !this.protocolInfo;
    }

    get skipButtonLabel(){
        return this.isSkipped ? "Cancel Skip" : "Skip";
    }

    get removeButtonLabel(){
        return this.isRemoved ? "Cancel Skip and Remove from Plan" : "Skip and Remove from Plan";
    }

    get closeButtonLabel(){
        return this.isSkipped ? 'Close' : 'Close Without Saving';
    }
}