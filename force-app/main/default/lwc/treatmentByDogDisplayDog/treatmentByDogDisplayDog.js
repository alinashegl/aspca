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
            window.console.log('this.dog: ', JSON.stringify(this.dog));
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

    get currentRemovedProtocols(){
        return this.showActiveRemoved ? 'Hide Current Removed' : 'Show Current Removed';
    }

    get historicalProtocols(){
        return this.showHistorical ? 'Hide Historical' : 'Show Historical';
    }

    get currentProtocolsButton(){
        return this.showActiveNotRemoved ? 'brand' : 'neutral';
    }

    get currentRemovedProtocolsButton(){
        return this.showActiveRemoved ? 'brand' : 'neutral';
    }

    get historicalProtocolsButton(){
        return this.showHistorical ? 'brand' : 'neutral';
    }
}