import { LightningElement, api, wire } from 'lwc';
import hasRemoveFromPlanPermission from '@salesforce/customPermission/Remove_Protocol_From_Plan';
import getProtocolSkippedInfo from '@salesforce/apex/TreatmentSessionLWCController.getProtocolSkippedInfo';

export default class TreatmentModifySessionProtocol extends LightningElement {
    @api protocol;
    @api type;
    notSkipped = false;
    notRemoved = false;
    addToPlan = false;
    loading = true;

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
                this.notSkipped = this.isAssignedType ? !result.IsSkipped__c : false;
                this.notRemoved = !result.IsRemoved__c;
            })
            .then(() =>{
                this.loading = false;
            })
        }
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
            type: this.type,
            isSkipped: !this.notSkipped,
            isRemoved: !this.notRemoved,
            addToPlan: this.addToPlan
        };
        const event = new CustomEvent('protocolassignment', {
            detail: eventDetails
        });
        this.dispatchEvent(event);
    }

    get isDisabled(){
        return !this.notRemoved;
    }

    get isAssignedType(){
        return this.type == 'assigned';
    }

    get protocolName(){
        return this.isAssignedType ? this.protocol.Protocol_Name__c : this.protocol.Name;
    }

    get canRemoveProtocol(){
        return hasRemoveFromPlanPermission;
    }
}