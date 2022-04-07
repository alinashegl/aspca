import { LightningElement, api, wire } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import getPlanProtocolInfo from '@salesforce/apex/MRCTreatmentPlansReportLWCController.getPlanProtocolInfo';
import PROTOCOL_NAME_FIELD from '@salesforce/schema/Plan_Protocol__c.Protocol_Name__c';
import PROTOCOL_NOTES_FIELD from '@salesforce/schema/Plan_Protocol__c.Protocol_Notes__c';
import PROTOCOL_REMOVED_FIELD from '@salesforce/schema/Plan_Protocol__c.IsRemoved__c';
import PROTOCOL_NOTES_MODIFIED_FIELD from '@salesforce/schema/Plan_Protocol__c.Notes_Last_Modified_Date__c';


export default class MrcTreatmentPlansProtocol extends LightningElement {
    @api recordId;
    @api protocol;
    protocolNotes;

    protocolNameField = PROTOCOL_NAME_FIELD.fieldApiName;
    protocolNotesField = PROTOCOL_NOTES_FIELD.fieldApiName;
    protocolRemovedField = PROTOCOL_REMOVED_FIELD.fieldApiName;
    protocolNotesModifiedDateField = PROTOCOL_NOTES_MODIFIED_FIELD.fieldApiName;

    showSpinner = false;
    isLoading = true;

    @wire(getPlanProtocolInfo, { recordId: '$recordId' })
    planProtocolInfo;

    handleOnLoad(event){
        var record = event.detail.records;
        var fields = record[this.recordId].fields;
        this.protocolNotes = fields[this.protocolNotesField].value;
        if(fields[this.protocolNotesModifiedDateField] != undefined){
            this.isLoading = false;
        }
    }

    handleInputBlur(event){
        window.console.log('blur');
        //only need to update the notes if they have changed
        if(event.target.value != this.protocolNotes){
            this.isLoading = true;

            const fields = {};
            fields[this.protocolNotesField] = event.target.value;
            fields['Id'] = this.recordId;

            const recordInput = { fields };

            updateRecord(recordInput)
            .then(() => {
                //nothing to do here as the record refreshed automatically
            })
            .catch(error => {
                window.console.log('error: ', error.body.message);
                this.errorMessage = 'Error updating Plan Protocol Notes:';
                this.error = error;
            })
            .finally(() => {
                this.isLoading = false;
            });
        }
    }

    get protocolName(){
        return this.protocol != undefined ? this.protocol[this.protocolNameField] : null;
    }
}