import { LightningElement, api, wire } from 'lwc';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import FORM_FACTOR from '@salesforce/client/formFactor'
import getProtocolLists from '@salesforce/apex/TreatmentSessionLWCController.getProtocolLists';

import PROTOCOL_IS_ACTIVE_FIELD from '@salesforce/schema/Protocol__c.IsActive__c';
import PROTOCOL_DESCRIPTION_FIELD from '@salesforce/schema/Protocol__c.Description__c';
import PROTOCOL_NAME_FIELD from '@salesforce/schema/Protocol__c.Name';

import SESSION_PROTOCOL_ADD_TO_PLAN_FIELD from '@salesforce/schema/Session_Protocol__c.Add_to_Plan__c';
import SESSION_PROTOCOL_NEEDS_REVIEW_FIELD from '@salesforce/schema/Session_Protocol__c.Needs_Review__c';
import SESSION_PROTOCOL_PREFERRED_MOTIVATORS_FIELD from '@salesforce/schema/Session_Protocol__c.Preferred_Motivators__c';
import SESSION_PROTOCOL_PROTOCOL_ID_FIELD from '@salesforce/schema/Session_Protocol__c.ProtocolId__c';
import SESSION_PROTOCOL_TREATMENT_SESSION_FIELD from '@salesforce/schema/Session_Protocol__c.TreatmentSessionId__c';
import SESSION_PROTOCOL_IS_SKIPPED_FIELD from '@salesforce/schema/Session_Protocol__c.IsSkipped__c';
import SESSION_PROTOCOL_IS_REMOVED_FIELD from '@salesforce/schema/Session_Protocol__c.IsRemoved__c';


export default class TreatmentModifySession extends LightningElement {
    @api sessionId;
    wireResponse;
    assignedProtocols = [];
    unassignedProtocols = [];

    @wire(getProtocolLists, {sessionId : '$sessionId' } )
    response(result){
        this.wireResponse = result;
        if(result.data){
            this.assignedProtocols = result.data.assignedProtocols;
            this.unassignedProtocols = result.data.unassignedProtocols;
        }
    }


    hanldeAddNewProtocol(){
        // this.template.querySelector("lightning-input[data-name=needsReview]").checked;
    }
}