import { LightningElement, api, wire } from 'lwc';
import getDogInfo from '@salesforce/apex/TreatmentByDogLWCController.getDogInfo';

export default class TreatmentByDogDisplayDog extends LightningElement {
    @api dogId;
    dog;
    showSpinner = true;

    showActiveNotRemoved = true;
    showActiveRemoved = true;
    showHistorical = false;

    @wire(getDogInfo, {recordId: '$dogId'})
    response(result){
        if(result.data){
            this.dog = result.data;
            this.showSpinner = false;
        } else if(result.error){
            this.error = result.error;
            window.console.log('error: ', result.error);
            this.showSpinner = false;
        }
    }

    handleToggleCurrent(){
        this.showActiveNotRemoved = !this.showActiveNotRemoved;
    }

    handleToggleRemoved(){
        this.showActiveRemoved = !this.showActiveRemoved;
    }

    handleToggleHistorical(){
        this.showHistorical = !this.showHistorical;
    }

    get currentProtocols(){
        return this.showActiveNotRemoved ? 'Hide Current' : 'Show Current';
    }

    get currentProtocolsButton(){
        return this.showActiveNotRemoved ? 'brand' : 'neutral';
    }

    get currentProtocolsButtonTitle(){
        return this.showActiveNotRemoved ? 
            'Click to hide all Protocols that are assigned to the current Treatment Plan.  This will also hide the Protocol if it was completed under a previous Treatment Plan' : 
            'Click to show all Protocols that are assigned to the current Treatment Plan.  If \'Show Historical\' is also selected, the deatails shown will also include scores that were completed under a previous Treatment Plan';
    }

    get currentRemovedProtocols(){
        return this.showActiveRemoved ? 'Hide Current Removed' : 'Show Current Removed';
    }

    get currentRemovedProtocolsButton(){
        return this.showActiveRemoved ? 'brand' : 'neutral';
    }

    get currentRemovedProtocolsButtonTitle(){
        return this.showActiveRemoved ? 
            'Click to hide Protocols that have been removed from the current Treatment Plan' : 
            'Click to show Protocols that have been removed from the current Treatment Plan';
    }

    get historicalProtocols(){
        return this.showHistorical ? 'Hide Historical' : 'Show Historical';
    }

    get historicalProtocolsButton(){
        return this.showHistorical ? 'brand' : 'neutral';
    }

    get historicalProtocolsButtonTitle(){
        return this.showHistorical ? 
            'Click to hide all Protocol scores that were not completed under the current Treatment Plan' : 
            'Click to show all Protocols scores that not completed under the current Treatment Plan.';
    }

    get showCurrentProtocols(){
        return this.showActiveNotRemoved || this.showHistorical;
    }
}