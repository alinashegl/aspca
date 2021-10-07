import { LightningElement, api, wire } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import getProtocolLists from '@salesforce/apex/TreatmentSessionLWCController.getProtocolLists';
import updateProtocolAssignments from '@salesforce/apex/TreatmentSessionLWCController.updateProtocolAssignments';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

import SESSION_PROTOCOL_OBJECT from "@salesforce/schema/Session_Protocol__c";
import SESSION_PROTOCOL_ADD_TO_PLAN_FIELD from '@salesforce/schema/Session_Protocol__c.Add_to_Plan__c';
import SESSION_PROTOCOL_PROTOCOL_ID_FIELD from '@salesforce/schema/Session_Protocol__c.ProtocolId__c';
import SESSION_PROTOCOL_TREATMENT_SESSION_FIELD from '@salesforce/schema/Session_Protocol__c.TreatmentSessionId__c';
import SESSION_PROTOCOL_NEEDS_REVIEW_FIELD from '@salesforce/schema/Session_Protocol__c.Needs_Review__c';

export default class TreatmentModifySession extends LightningElement {
    @api sessionId;
    wireResponse;
    assignedProtocols = [];
    unassignedProtocols = [];
    assignedProtocolUpdates = [];
    protocolsToAssign = [];
    addNewProtocol = false;
    isUpdateButtonDisabled = true;

    _refresh;
    @api
    get refresh() {
        return this._refresh;
    }
    set refresh(value) {
        this._refresh = value;
    }

    @wire(getProtocolLists, {sessionId : '$sessionId'} )
    response(result){
        this.wireResponse = result;
        if(result.data){
            this.assignedProtocols = result.data.assignedProtocols;
            this.unassignedProtocols = result.data.unassignedProtocols;
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
            window.console.log('assignedProtocolUpdates.length: ' + this.assignedProtocolUpdates.length);
        }
        else if(protocol.type == 'unassigned'){
            let index = this.protocolsToAssign.indexOf(protocol.id);
            if(index != -1){
                this.protocolsToAssign.splice(index, 1);
            } else {
                this.protocolsToAssign.push(protocol.id);
            }
            window.console.log('protocolsToAssign: ' + JSON.stringify(this.protocolsToAssign));
            window.console.log('protocolsToAssign.length: ' + this.protocolsToAssign.length);
        }
        this.isUpdateButtonDisabled = (this.assignedProtocolUpdates.length > 0 || this.protocolsToAssign.length > 0) ? false : true;
    }

    handleProtocolAssignmentUpdates(){
        window.console.log('in handleProtocolAssignmentUpdates');
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
                this.assignedProtocolUpdates = [];
                this.protocolsToAssign = [];
                this.isUpdateButtonDisabled = true;
                refreshApex(this.wireResponse);
                this.refreshProtocolView();
            })
    }

    refreshProtocolView() {
        window.console.log('refreshProtocolView', this.template.querySelector("c-treatment-modify-session-protocol"));
        if(this.template.querySelector("c-treatment-modify-session-protocol")){
            this.template.querySelector("c-treatment-modify-session-protocol").refreshProtocol();
        }
    }

    handleInsertProtocolResponse(event){
        let protocolId = event.detail.id;
        window.console.log('newProtocolId: ', protocolId);
        const fields = {};
        fields[SESSION_PROTOCOL_PROTOCOL_ID_FIELD.fieldApiName] = protocolId;
        fields[SESSION_PROTOCOL_TREATMENT_SESSION_FIELD.fieldApiName] = this.sessionId;
        fields[SESSION_PROTOCOL_ADD_TO_PLAN_FIELD.fieldApiName] = true;
        fields[SESSION_PROTOCOL_NEEDS_REVIEW_FIELD.fieldApiName] = true;

        const recordInput = { apiName: SESSION_PROTOCOL_OBJECT.objectApiName, fields };

        createRecord(recordInput)
            .then((response) => {
                window.console.log('sessionProtocolId = ', response)
                this.handleToastEvent('Success', 'Session Protocol created successfully!', 'success' );
            })
            .catch((error) => {
                this.handleToastEvent("Error creating record", error, "error");
            })
            .finally(() => {
                this.addNewProtocol = false;
                refreshApex(this.wireResponse);
            });
    }

    handleSubmitProtocol(event){
        event.preventDefault();
        const fields = event.detail.fields;
        fields.Name = 'Other ' + fields.Name
        this.template
        .querySelector('lightning-record-edit-form').submit(fields);
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
}