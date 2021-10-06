import { LightningElement, api, wire } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import FORM_FACTOR from '@salesforce/client/formFactor'
import getProtocolLists from '@salesforce/apex/TreatmentSessionLWCController.getProtocolLists';
import updateProtocolAssignments from '@salesforce/apex/TreatmentSessionLWCController.updateProtocolAssignments';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

// import PROTOCOL_IS_ACTIVE_FIELD from '@salesforce/schema/Protocol__c.IsActive__c';
// import PROTOCOL_DESCRIPTION_FIELD from '@salesforce/schema/Protocol__c.Description__c';
// import PROTOCOL_NAME_FIELD from '@salesforce/schema/Protocol__c.Name';
import SESSION_PROTOCOL_OBJECT from "@salesforce/schema/Session_Protocol__c";
import SESSION_PROTOCOL_ADD_TO_PLAN_FIELD from '@salesforce/schema/Session_Protocol__c.Add_to_Plan__c';
// import SESSION_PROTOCOL_NEEDS_REVIEW_FIELD from '@salesforce/schema/Session_Protocol__c.Needs_Review__c';
// import SESSION_PROTOCOL_PREFERRED_MOTIVATORS_FIELD from '@salesforce/schema/Session_Protocol__c.Preferred_Motivators__c';
import SESSION_PROTOCOL_PROTOCOL_ID_FIELD from '@salesforce/schema/Session_Protocol__c.ProtocolId__c';
import SESSION_PROTOCOL_TREATMENT_SESSION_FIELD from '@salesforce/schema/Session_Protocol__c.TreatmentSessionId__c';
// import SESSION_PROTOCOL_IS_SKIPPED_FIELD from '@salesforce/schema/Session_Protocol__c.IsSkipped__c';
// import SESSION_PROTOCOL_IS_REMOVED_FIELD from '@salesforce/schema/Session_Protocol__c.IsRemoved__c';


export default class TreatmentModifySession extends LightningElement {
    @api sessionId;
    wireResponse;
    assignedProtocols = [];
    unassignedProtocols = [];

    assignedProtocolUpdates = [];
    protocolsToAssign = [];

    isLoading = true;
    addNewProtocol = false;

    @wire(getProtocolLists, {sessionId : '$sessionId' } )
    response(result){
        this.wireResponse = result;
        if(result.data){
            this.assignedProtocols = result.data.assignedProtocols;
            this.unassignedProtocols = result.data.unassignedProtocols;
            this.isLoading = false;
        } else {
            this.isLoading = false;
        }
        
    }

    toggleAddNewProtocol(){
        this.addNewProtocol = !this.addNewProtocol;
    }

    handleProtocolAssignmentEvent(event){
        window.console.log('handleProtocolAssignmentEvent: ', JSON.stringify(event.detail));
        let protocol = event.detail;
        if(protocol.type == 'assigned'){
            let prUpdate = {
                sObjectType: 'Session_Protocol__c',
                Id : protocol.id,
                IsSkipped__c: protocol.isSkipped,
                IsRemoved__c: protocol.isRemoved
            }
            if(this.assignedProtocolUpdates.find(pr => pr.Id == protocol.id)){
                this.assignedProtocolUpdates.find(pr => pr.Id == protocol.id).IsSkipped__c = prUpdate.IsSkipped__c;
                this.assignedProtocolUpdates.find(pr => pr.Id == protocol.id).IsRemoved__c = prUpdate.IsRemoved__c;
            } else {
                this.assignedProtocolUpdates.push(prUpdate);
            }
            window.console.log('assignedProtocolUpdates: ' + JSON.stringify(this.assignedProtocolUpdates));
        }
        else if(protocol.type == 'unassigned'){
            let index = this.protocolsToAssign.indexOf(protocol.id);
            if(index != -1){
                this.protocolsToAssign.splice(index, 1);
            } else {
                this.protocolsToAssign.push(protocol.id);
            }
            window.console.log('protocolsToAssign: ' + JSON.stringify(this.protocolsToAssign));
        }        
    }

    handleProtocolAssignmentUpdates(){
        window.console.log('in handleProtocolAssignmentUpdates');
        this.isLoading = true;
        updateProtocolAssignments({protocolsToUpdate: this.assignedProtocolUpdates, protocolIds: this.protocolsToAssign, sessionId: this.sessionId})
            .then((response) => {
                if(response == 'success'){
                    window.console.log('response = ', response);
                    this.handleToastEvent("Success", 'Session Protocols have been updated!', "success");
                } else {
                    window.console.log('errors: ', error);
                    this.handleToastEvent("Error updating protocols", response, "error");
                }                
            })
            .catch((error) => {
                window.console.log('errors: ', error);
                this.handleToastEvent("Error updating protocols", error, "error");
            })
            .finally(() =>{
                this.handleRefreshEvent();
                refreshApex(this.wireResponse);
            })
    }

    handleInsertProtocolResponse(event){
        this.isLoading = true;
        let protocolId = event.detail.id;
        window.console.log('newProtocolId: ', protocolId);
        const fields = {};
        fields[SESSION_PROTOCOL_PROTOCOL_ID_FIELD.fieldApiName] = protocolId;
        fields[SESSION_PROTOCOL_TREATMENT_SESSION_FIELD.fieldApiName] = this.sessionId;
        fields[SESSION_PROTOCOL_ADD_TO_PLAN_FIELD.fieldApiName] = true;

        const recordInput = { apiName: SESSION_PROTOCOL_OBJECT.objectApiName, fields };

        createRecord(recordInput)
            .then((response) => {
                window.console.log('sessionProtocolId = ', response)
                this.handleToastEvent('Success', 'Session Protocol created successfully!', 'success' );
                // this.dispatchEvent(
                //     new ShowToastEvent({
                //         title: "Success",
                //         message: "Session Protocol created successfully!",
                //         variant: "success"
                //     })
                // );
            })
            .catch((error) => {
                this.handleToastEvent("Error creating record", error, "error");
                // this.dispatchEvent(
                //     new ShowToastEvent({
                //         title: "Error creating record",
                //         message: reduceErrors(error).join(", "),
                //         variant: "error"
                //     })
                // );
            })
            .finally(() => {
                this.addNewProtocol = false;
                this.isLoading = false;
                this.handleRefreshEvent();
                refreshApex(this.wireResponse);
            });
    }

    handleRefreshEvent(){
        window.console.log('in handleRefreshEvent')

        const event = new CustomEvent('refreshevent', {  });
        this.dispatchEvent(event);
    }

    handleToastEvent(title, message, variant){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }

    get addNewLabel(){
        return this.addNewRecord ? 'Submit' : 'Add New Protocol';
    }
}