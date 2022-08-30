import { LightningElement, api, wire } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from "lightning/navigation";
import getActiveProtocolAndFields from '@salesforce/apex/TreatmentSessionLWCController.getActiveProtocolAndFields';
import getProtocolStatus from '@salesforce/apex/TreatmentSessionLWCController.getProtocolStatus';
import PROTOCOL_ID_FIELD from '@salesforce/schema/Session_Protocol__c.Id';
import IS_SKIPPED_FIELD from '@salesforce/schema/Session_Protocol__c.IsSkipped__c';
import IS_REMOVED_FIELD from '@salesforce/schema/Session_Protocol__c.IsRemoved__c';
import NEEDS_REVIEW_FIELD from '@salesforce/schema/Session_Protocol__c.Needs_Review__c';
import PROTOCOL_NOTES_FIELD from '@salesforce/schema/Session_Protocol__c.Protocol_Notes__c';
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
    updateError;
    errorMessage;

    showUpdatingSpinner = false;
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
                this.errorMessage = 'Error retrieving Protocol Info:';
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
                this.errorMessage = 'Error refreshing Protocol Info:';
            }
        });
    }

    setFieldValues(data){
        this.isSkipped = data.isSkipped;
        this.isRemoved = data.isRemoved;
        this.protocolStatus = data.statusText;
        this.loading = false;
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
            this.updateProtocol(fields, true);
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
            this.updateProtocol(fields, true);
        }
    }

    resetProtocol(action){
        const fields = {};
        fields[PROTOCOL_ID_FIELD.fieldApiName] = this.recordId;
        fields[IS_SKIPPED_FIELD.fieldApiName] = this.isSkipped;

        if(action==='remove'){
            fields[IS_REMOVED_FIELD.fieldApiName] = this.isRemoved;
        }

        this.updateProtocol(fields, true);
    }

    updateProtocol(fields, refresh){
        const recordUpdate = {fields};
        updateRecord(recordUpdate)
        .then(() => {
        })
        .catch(error => {
            this.updateError = error;
            this.errorMessage = 'Error updating Porotocol:';
        })
        .finally(() => {
            this.showUpdatingSpinner = false;
            this.loading = false;
            if(refresh){
                this.getProtocolInfo();
            }
        });
    }

    updatePlanProtocol(fields){
        const recordUpdate = {fields};
        updateRecord(recordUpdate)
        .then(() => {
        })
        .catch(error => {
            this.updateError = error;
            this.errorMessage = 'Error updating Porotocol:';
        })
        .finally(() => {
            this.showUpdatingSpinner = false;
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

    handleManagerReviewChange(event){
        this.showUpdatingSpinner = true;
        const fields = {};
        fields[PROTOCOL_ID_FIELD.fieldApiName] = this.recordId;
        fields[NEEDS_REVIEW_FIELD.fieldApiName] = event.target.checked;

        this.updateProtocol(fields, false);
    }

    handleProtocolNotesUpdate(event){
        let newValue = event.target.value;

        if(newValue != this.protocolInfo.protocolNotes){
            this.protocolInfo.protocolNotes = newValue;
            this.showUpdatingSpinner = true;

            const fields = {};
            fields[PROTOCOL_ID_FIELD.fieldApiName] = this.recordId;
            fields[PROTOCOL_NOTES_FIELD.fieldApiName] = newValue;

            this.updateProtocol(fields, false);
        }
    }

    handlePlanProtocolNotesUpdate(event){
        let newValue = event.target.value;

        if(newValue != this.protocolInfo.protocolNotes){
            this.protocolInfo.planProtocolNotes = newValue;
            this.showUpdatingSpinner = true;

            const fields = {};
            fields[PLAN_PROTOCOL_ID_FIELD.fieldApiName] = this.protocolInfo.planProtocolId;
            fields[PLAN_PROTOCOL_NOTES_FIELD.fieldApiName] = newValue;

            this.updatePlanProtocol(fields);
        }

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
        return 'Close';
    }
}