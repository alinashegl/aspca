import { LightningElement, api } from 'lwc';

export default class TreatmentModifySessionProtocolList extends LightningElement {
    @api protocolList = [];
    @api protocolType;
    @api isAssigned;
    @api planId;
    @api sessionId;

    handleProtocolAssignmentEvent(event){
        window.console.log('TreatmentModifySessionProtocolList event: ', JSON.stringify(event.detail));
        const propEvent = new CustomEvent('protocolassignment', {
            detail: event.detail
        });
        this.dispatchEvent(propEvent);
    }

    get isSessionProtocol(){
        return this.protocolType == 'session';
    }

    get category(){
        return this.protocolType == 'session' ? 
            (this.isAssignedType ? this.protocolList[0].ProtocolId__r.Protocol_Categories__c : this.protocolList[0].Protocol_Categories__c) :
        (this.isAssignedType ? this.protocolList[0].Protocol__r.Protocol_Categories__c : this.protocolList[0].Protocol_Categories__c);
    }

    get isAssignedType(){
        return this.isAssigned == 'assigned';
    }
}