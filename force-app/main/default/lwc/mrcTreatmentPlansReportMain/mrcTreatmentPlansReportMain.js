import { LightningElement } from 'lwc';
import getMRCDogs from '@salesforce/apex/MRCTreatmentPlansReportLWCController.getMRCDogs';

export default class MrcTreatmentPlansReportMain extends LightningElement {
    animalList;

    connectedCallback(){
        if(this.animalList == undefined){
            getMRCDogs()
            .then((result) => {
                this.animalList = result;
            });
        }
    }

    get animalListLength(){
        return this.animalList != undefined ? this.animalList.length : 0;
    }
}