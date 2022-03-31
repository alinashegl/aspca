import { LightningElement, api, wire } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import getPlanProtocolInfo from '@salesforce/apex/MRCTreatmentPlansReportLWCController.getPlanProtocolInfo';
import PROTOCOL_NAME_FIELD from '@salesforce/schema/Plan_Protocol__c.Protocol_Name__c';
import PROTOCOL_NOTES_FIELD from '@salesforce/schema/Plan_Protocol__c.Protocol_Notes__c';
import PROTOCOL_REMOVED_FIELD from '@salesforce/schema/Plan_Protocol__c.IsRemoved__c';
import PROTOCOL_NOTES_MODIFIED_FIELD from '@salesforce/schema/Plan_Protocol__c.Notes_Last_Modified_Date__c';


export default class MrcTreatmentPlansProtocol extends LightningElement {
    @api recordId;

    protocolNameField = PROTOCOL_NAME_FIELD.fieldApiName;
    protocolNotesField = PROTOCOL_NOTES_FIELD.fieldApiName;
    protocolRemovedField = PROTOCOL_REMOVED_FIELD.fieldApiName;
    protocolNotesModifiedDateField = PROTOCOL_NOTES_MODIFIED_FIELD.fieldApiName;

    showSpinner = false;

    @wire(getPlanProtocolInfo, { recordId: '$recordId' })
    planProtocolInfo;

    handleInputBlur(event){
        window.console.log('blur');
        this.showSpinner = true;

        const fields = {};
        fields[protocolNotesField] = event.target.value;
        fields['Id'] = this.recordId;

        const recordInput = { fields };

        updateRecord(recordInput)
        .then(() => {
            window.console.log('success');
        })
        .catch(error => {
            window.console.log('error: ', error.body.message);
            this.errorMessage = 'Error updating Plan Protocol Notes:';
            this.error = error;
        })
        .finally(() => {
            this.showSpinner = false;
        });
    }
}