import { LightningElement, wire, api } from 'lwc';

import TREATMENT_SESSION_ID_FIELD from '@salesforce/schema/Session_Protocol__c.TreatmentSessionId__c';
import PROTOCOL_ID_FIELD from '@salesforce/schema/Session_Protocol__c.ProtocolId__c';

export default class TreatmentModifySession extends LightningElement {
    @api sessionId;


    
}