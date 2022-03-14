import { LightningElement, api } from 'lwc';
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
}