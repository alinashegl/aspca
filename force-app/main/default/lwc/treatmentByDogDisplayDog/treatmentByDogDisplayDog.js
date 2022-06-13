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
}