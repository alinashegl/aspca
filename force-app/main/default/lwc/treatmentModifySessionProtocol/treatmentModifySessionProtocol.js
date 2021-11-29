import { LightningElement, api, wire } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor'
import hasRemoveFromPlanPermission from '@salesforce/customPermission/Remove_Protocol_From_Plan';
import getProtocolSkippedInfo from '@salesforce/apex/TreatmentSessionLWCController.getProtocolSkippedInfo';

export default class TreatmentModifySessionProtocol extends LightningElement {
    @api protocol;
    @api isAssigned;
    @api protocolType
    notSkipped = false;
    notRemoved = false;
    addToPlan = false;
    loading = true;
    formFactor = FORM_FACTOR;

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
    }

    get notSkippedValue(){
        return this.notSkipped;
    }

    get notRemovedValue(){
        return this.notRemoved;
    }

    get showLoading(){
        return this.isAssignedType && this.loading;
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
}