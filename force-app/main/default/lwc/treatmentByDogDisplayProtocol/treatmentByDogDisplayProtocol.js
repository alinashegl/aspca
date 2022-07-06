import { LightningElement, api } from 'lwc';

export default class TreatmentByDogDisplayProtocol extends LightningElement {
    @api protocol;
    @api isCurrentProtocol = false;
    @api isRemovedProtocol = false;
    @api showCurrent;
    @api showHistorical;

    connectedCallback(){
        if(this.protocol){
            window.console.log("protocol Name: ", this.protocol.name);
            window.console.log("isCurrentProtocol: ", this.isCurrentProtocol);
            window.console.log("isRemovedProtocol: ", this.isRemovedProtocol);
            window.console.log("showCurrent: ", this.showCurrent);
            window.console.log("showHistorical: ", this.showHistorical);
        }
    }


    get displayProtocol(){
        let display = false;
        if(
            this.isCurrentProtocol && 
            ((this.showCurrent && this.protocol.activePlanSessionProtocols) ||
            (this.showHistorical && this.historicalActiveSessionProtocols))
        ){
            display = true;
        }
        return display;
    }
}