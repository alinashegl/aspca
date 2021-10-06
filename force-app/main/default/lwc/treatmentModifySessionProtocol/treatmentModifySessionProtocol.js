import { LightningElement, api } from 'lwc';

export default class TreatmentModifySessionProtocol extends LightningElement {
    @api protocol;
    @api type;
    notSkipped = false;
    notRemoved = false;
    addToPlan = false;

    connectedCallback(){
        if(this.protocol){
            this.notSkipped = this.type == 'assigned' ? !this.protocol.IsSkipped__c : false;
            this.notRemoved = !this.protocol.IsRemoved__c;
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
        window.console.log('in handleToggleUpdateEvent')
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
        return this.type == 'assigned' ? this.protocol.Protocol_Name__c : this.protocol.Name;
    }
}