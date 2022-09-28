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
        refreshApex(this.wireResponse);
        this.refreshProtocolView();
    }

    handleProtocolAssignmentUpdates(){
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
                    this.handleToastEvent("Success", 'Session Protocols have been updated!', "success");
                } else {
                    this.handleToastEvent("Error updating protocols", response, "error");
                }
                this.assignedProtocolUpdates = [];
                this.protocolsToAssign = [];
                this.planProtocolsToUpdate = [];
                this.isUpdateButtonDisabled = true;
            })
            .catch((error) => {
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
        if(this.template.querySelector("c-treatment-modify-session-protocol")){
            this.template.querySelector("c-treatment-modify-session-protocol").refreshProtocol();
        }
    }

    handleInsertProtocolResponse(event){
        this.updating = true;
        let protocolId = event.detail.id;
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
        fields.Name = 'Other ' + fields.Name;
        fields.IsActive__c = true;
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