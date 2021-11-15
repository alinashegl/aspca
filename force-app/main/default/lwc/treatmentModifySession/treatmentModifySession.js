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
import SESSION_PROTOCOL_PREFERRED_MOTIVATORS_FIELD from '@salesforce/schema/Session_Protocol__c.Preferred_Motivators__c';

import PLAN_PROTOCOL_OBJECT from "@salesforce/schema/Plan_Protocol__c";
import PLAN_PROTOCOL_PROTOCOL_ID_FIELD from '@salesforce/schema/Plan_Protocol__c.Protocol__c';
import PLAN_PROTOCOL_TREATMENT_PLAN_FIELD from '@salesforce/schema/Plan_Protocol__c.Treatment_Plan__c';

export default class TreatmentModifySession extends LightningElement {
    @api sessionId = null;
    @api recordId = null;
    wireResponse;

    planProtocolsToUpdate = [];
    unassignedProtocols = [];
    assignedProtocolUpdates = [];
    protocolsToAssign = [];
    addNewProtocol = false;
    isUpdateButtonDisabled = true;
    preferredMotivators;
    updating = false;
    toggleShowUnassignedProtocols = false;
    
    categoriesListOfLists = [];
    unassignedProtocolsCategoriesLists = [];

    _refresh;
    @api
    get refresh() {
        return this._refresh;
    }
    set refresh(value) {
        this._refresh = value;
    }

    @wire(getProtocolLists, {sessionId : '$sessionId', planId : '$recordId'} )
    response(result){
        this.wireResponse = result;
        if(result.data){
            this.categoriesListOfLists = result.data.assignedSessionProtocolsLists ? result.data.assignedSessionProtocolsLists : result.data.assignedPlanProtocolsLists;
            this.unassignedProtocolsCategoriesLists = result.data.unassignedProtocolsLists;
            this.preferredMotivators = result.data.preferredMotivators;
        }
    }

    toggleAddNewProtocol(){
        this.addNewProtocol = !this.addNewProtocol;
    }

    handleProtocolAssignmentEvent(event){
        window.console.log('handleProtocolAssignmentEvent: ', JSON.stringify(event.detail));
        let protocol = event.detail;
        if(protocol.isAssigned && this.protocolType == 'session'){
            let prUpdate = {
                sObjectType: SESSION_PROTOCOL_OBJECT.objectApiName,
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
        else if(protocol.isAssigned && this.protocolType == 'protocol'){
            let index = this.planProtocolsToUpdate.indexOf(protocol.id);
            if(index != -1){
                this.planProtocolsToUpdate.splice(index, 1);
            } else {
                this.planProtocolsToUpdate.push(protocol.id);
            }
            window.console.log('planProtocolsToUpdate: ' + JSON.stringify(this.planProtocolsToUpdate));
            window.console.log('planProtocolsToUpdate.length: ' + this.planProtocolsToUpdate.length);
        }
        else if(!protocol.isAssigned){
            let index = this.protocolsToAssign.indexOf(protocol.id);
            if(index != -1){
                this.protocolsToAssign.splice(index, 1);
            } else {
                this.protocolsToAssign.push(protocol.id);
            }
            window.console.log('protocolsToAssign: ' + JSON.stringify(this.protocolsToAssign));
            window.console.log('protocolsToAssign.length: ' + this.protocolsToAssign.length);
        }
        this.isUpdateButtonDisabled = (this.assignedProtocolUpdates.length > 0 || this.protocolsToAssign.length > 0 || this.planProtocolsToUpdate.length > 0) ? false : true;
    }

    handleProtocolAssignmentUpdates(){
        window.console.log('in handleProtocolAssignmentUpdates');
        this.updating = true;
        updateProtocolAssignments({
            protocolsToUpdate: this.assignedProtocolUpdates, 
            protocolIds: this.protocolsToAssign, 
            planProtocolIds: this.planProtocolsToUpdate,
            sessionId: this.sessionId,
            planId: this.recordId
        })
            .then((response) => {
                if(response == 'success'){
                    window.console.log('response = ', response);
                    this.handleToastEvent("Success", 'Session Protocols have been updated!', "success");
                } else {
                    window.console.log('errors: ', error);
                    this.handleToastEvent("Error updating protocols", response, "error");
                }
                this.assignedProtocolUpdates = [];
                this.protocolsToAssign = [];
                this.planProtocolsToUpdate = [];
                this.isUpdateButtonDisabled = true;
            })
            .catch((error) => {
                window.console.log('errors: ', error);
                this.handleToastEvent("Error updating protocols", error, "error");
            })
            .then(() => {
                refreshApex(this.wireResponse);
                this.refreshProtocolView();
            })
            .finally(() =>{                
                this.updating = false
            })
    }

    refreshProtocolView() {
        window.console.log('refreshProtocolView', this.template.querySelector("c-treatment-modify-session-protocol"));
        if(this.template.querySelector("c-treatment-modify-session-protocol")){
            this.template.querySelector("c-treatment-modify-session-protocol").refreshProtocol();
        }
    }

    handleInsertProtocolResponse(event){
        this.updating = true;
        let protocolId = event.detail.id;
        window.console.log('newProtocolId: ', protocolId);
        let successMessage = 'success';
        let recordInput;
        const fields = {};
        if(this.protocolType == 'session'){
            fields[SESSION_PROTOCOL_PROTOCOL_ID_FIELD.fieldApiName] = protocolId;
            fields[SESSION_PROTOCOL_TREATMENT_SESSION_FIELD.fieldApiName] = this.sessionId;
            fields[SESSION_PROTOCOL_ADD_TO_PLAN_FIELD.fieldApiName] = true;
            fields[SESSION_PROTOCOL_NEEDS_REVIEW_FIELD.fieldApiName] = true;
            fields[SESSION_PROTOCOL_PREFERRED_MOTIVATORS_FIELD.fieldApiName] = this.preferredMotivators;
            recordInput = { apiName: SESSION_PROTOCOL_OBJECT.objectApiName, fields };

            successMessage = 'Session Protocol created successfully!'
        }
        else {
            fields[PLAN_PROTOCOL_PROTOCOL_ID_FIELD.fieldApiName] = protocolId;
            fields[PLAN_PROTOCOL_TREATMENT_PLAN_FIELD.fieldApiName] = this.recordId;
            recordInput = { apiName: PLAN_PROTOCOL_OBJECT.objectApiName, fields };

            successMessage = 'Plan Protocol created successfully!'
        }

        createRecord(recordInput)
            .then((response) => {
                window.console.log('sessionProtocolId = ', response)
                this.handleToastEvent('Success', successMessage, 'success' );
            })
            .catch((error) => {
                this.handleToastEvent("Error creating record", error, "error");
            })
            .then(() =>{
                this.addNewProtocol = false;
                refreshApex(this.wireResponse);
            })
            .finally(() => {
                this.updating = false;
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

    handleToggleView(){
        this.toggleShowUnassignedProtocols = !this.toggleShowUnassignedProtocols;
    }

    get protocolType(){
        return this.sessionId != null ? 'session' : 'protocol';
    }

    get showProtocols(){
        return this.categoriesListOfLists || this.unassignedProtocolsCategoriesLists ? true : false;
    }

    get showLoading(){
        return this.updating;
    }

    get toggleButtonIconName(){
        return this.toggleShowUnassignedProtocols ? 'utility:chevrondown' : 'utility:chevronright';
    }

    get showUnassignedProtocols(){
        return this.unassignedProtocolsCategoriesLists && this.toggleShowUnassignedProtocols;
    }
}