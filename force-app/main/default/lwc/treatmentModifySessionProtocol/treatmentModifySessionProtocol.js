import { LightningElement, api, wire } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor'
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import hasRemoveFromPlanPermission from '@salesforce/customPermission/Remove_Protocol_From_Plan';
import getProtocolSkippedInfo from '@salesforce/apex/TreatmentSessionLWCController.getProtocolSkippedInfo';

import SESSION_PROTOCOL_OBJECT from "@salesforce/schema/Session_Protocol__c";
import PLAN_PROTOCOL_OBJECT from "@salesforce/schema/Plan_Protocol__c";
export default class TreatmentModifySessionProtocol extends LightningElement {
    @api protocol;
    @api isAssigned;
    @api protocolType;
    @api planId;
    @api sessionId;
    notSkipped = false;
    notRemoved = false;
    addToPlan = false;
    loading = true;
    formFactor = FORM_FACTOR;
    error;

    _refresh;
    @api
    get refresh() {
        return this._refresh;
    }
    set refresh(value) {
        this._refresh = value;
        this.loading = true;
        this.refreshProtocol();
    }

    @api
    refreshProtocol(){
        if(this.isAssignedType){
            getProtocolSkippedInfo({protocolId: this.protocol.Id})
            .then((result) => {
                if(result != null){
                    this.notSkipped = this.isAssignedType ? !result.IsSkipped__c : false;
                    this.notRemoved = !result.IsRemoved__c;
                }
                else {
                    this.notRemoved = !this.protocol.IsRemoved__c;
                }
            })
            .then(() =>{
                this.loading = false;
            })
        } else {
            this.loading = false;
        }
    }

    toggleIsSkipped(){
        this.notSkipped = !this.notSkipped;
        this.handleToggleUpdateEvent();
    }

    toggleIsRemoved(){
        this.notRemoved = !this.notRemoved;
        if(!this.notRemoved){
            this.notSkipped = false;
        }
        this.handleToggleUpdateEvent();
    }

    toggleAddToPlan(){
        this.addToPlan = !this.addToPlan;
        this.handleToggleUpdateEvent();
    }

    handleToggleUpdateEvent(){
        this.updateProtocol();
    }

    updateProtocol(){
        this.loading = true;
        const fields = {};
        fields['Id'] = this.protocol.Id;        
        
        if(this.protocolType == 'protocol'){
            fields['IsRemoved__c'] = !this.notRemoved;
            const recordUpdate = {fields: fields};
            this.handleUpdateRecord(recordUpdate);
        } else if(this.protocolType == 'session') {
            fields['IsSkipped__c'] = !this.notSkipped;
            const recordUpdate = {fields: fields};
            this.handleUpdateRecord(recordUpdate);
        } else {
            if(this.sessionId){
                this.prepSessionProtocol();
            }
            if(this.planId){
                this.prepPlanProtocol();
            }
        }
    }

    handleUpdateRecord(recordUpdate){
        updateRecord(recordUpdate)
        .then(() => {
            window.console.log('updated protocol');
        })
        .catch(error => {
            this.error = error;
        })
        .finally(() => {
            this.loading = false;
        });
    }

    prepSessionProtocol(){
        window.console.log("prepSessionProtocol");
        const fields = {};
        fields['ProtocolId__c'] = this.protocol.Id;
        fields['TreatmentSessionId__c'] = this.sessionId;
        const recordInput = { apiName: SESSION_PROTOCOL_OBJECT.objectApiName, fields };
        this.insertRecord(recordInput);        
    }

    prepPlanProtocol(){
        window.console.log("prepPlanProtocol");
        const fields = {};
        fields['Protocol__c'] = this.protocol.Id;
        fields['Treatment_Plan__c'] = this.planId;
        const recordInput = { apiName: PLAN_PROTOCOL_OBJECT.objectApiName, fields };
        this.insertRecord(recordInput);
    }

    insertRecord(recordInput){
        createRecord(recordInput)
        .then(() => {
            window.console.log('inserted protocol');
        })
        .catch(error => {
            this.error = error;
        })
        .finally(() => {
            let eventDetails = {            
                id: this.protocol.Id,
                isAssigned: this.isAssignedType,
                isSkipped: !this.notSkipped,
                isRemoved: !this.notRemoved,
                addToPlan: this.addToPlan
            };
            const event = new CustomEvent('protocolassignment', {
                detail: eventDetails
            });
            this.dispatchEvent(event);
        });
    }

    get notSkippedValue(){
        return this.notSkipped;
    }

    get notRemovedValue(){
        return this.notRemoved;
    }

    get showLoading(){
        return this.loading;
    }

    get isSessionProtocol(){
        return this.protocolType == 'session';
    }

    get isDisabled(){
        return !this.notRemoved;
    }

    get isAssignedType(){
        return this.isAssigned == 'assigned';
    }

    get protocolName(){
        return this.protocolType == 'session' ? (this.isAssignedType ? this.protocol.Protocol_Name__c : this.protocol.Name) :
            (this.isAssignedType ? this.protocol.Protocol__r.Name : this.protocol.Name);
        
    }

    get disableToggle(){
        return !hasRemoveFromPlanPermission;
    }

    get boxClass(){
        return FORM_FACTOR == 'Small' ? 'box slds-grid' : 'slds-box slds-grid';
    }

    get newProtocolClass(){
        return this.protocol.New_Protocol__c < 60 ? 'newProtocol' : null;
    }
}