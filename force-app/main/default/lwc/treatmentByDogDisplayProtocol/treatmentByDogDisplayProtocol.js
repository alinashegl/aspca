import { LightningElement, api } from 'lwc';

export default class TreatmentByDogDisplayProtocol extends LightningElement {
    @api protocol;
    @api protocolType;
    @api showCurrent = false;
    @api showHistorical = false;

    get currentProtocols(){
        let protocols = [];
        if(this.protocolType == 'current'){
            if(this.showCurrent && this.protocol.activePlanSessionProtocols && this.protocol.activePlanSessionProtocols.length > 0){
                protocols = this.protocol.activePlanSessionProtocols;
            }
        }
        else if(this.protocolType == 'removed'){
            if(this.showCurrent && this.protocol.activePlanRemovedSessionProtocols && this.protocol.activePlanRemovedSessionProtocols.length > 0){
                protocols = this.protocol.activePlanRemovedSessionProtocols;
            }
        }
        return protocols;
    }

    get historicalProtocols(){
        let protocols = [];
        if(this.protocolType == 'current'){
            if(
                this.showCurrent && 
                this.protocol.historicalActiveSessionProtocols && 
                this.protocol.historicalActiveSessionProtocols.length > 0
            ){
                protocols = this.protocol.historicalActiveSessionProtocols;
            }
        }
        else if(this.protocolType == 'removed'){
            if(
                this.showCurrent && 
                this.protocol.historicalRemovedSessionProtocols && 
                this.protocol.historicalRemovedSessionProtocols.length > 0
            ){
                protocols = this.protocol.historicalRemovedSessionProtocols;
            }
        }
        else if(
            this.protocolType == 'historical' &&
            this.protocol.historicalSessionProtocols && 
            this.protocol.historicalSessionProtocols.length > 0

        ){
            protocols = this.protocol.historicalSessionProtocols;
        }
        return protocols;
    }


    get displayProtocol(){
        let display = false;
        if(
            this.protocolType == 'current' && 
            ((this.showCurrent && this.protocol.activePlanSessionProtocols && this.protocol.activePlanSessionProtocols.length > 0) ||
            (this.showHistorical && this.historicalActiveSessionProtocols && this.protocol.historicalActiveSessionProtocols.length > 0))
        ){
            display = true;
        }
        else if(
            this.protocolType == 'removed' &&
            ((this.showCurrent && this.protocol.activePlanRemovedSessionProtocols && this.protocol.activePlanRemovedSessionProtocols.length > 0) ||
            (this.showHistorical && this.historicalRemovedSessionProtocols && this.protocol.historicalRemovedSessionProtocols.length > 0))
        ){
            display = true;
        }
        else if(
            this.protocolType == 'historical' &&
            this.protocol.historicalSessionProtocols && 
            this.protocol.historicalSessionProtocols.length > 0

        ){
            display = true;
        }
        return display;
    }

    get isRemoved(){
        return this.protocolType == 'removed';
    }
}