import { LightningElement } from 'lwc';
import getMRCDogs from '@salesforce/apex/MRCTreatmentPlansReportLWCController.getMRCDogs';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';

export default class MrcTreatmentPlansReportMain extends LightningElement {
    animalList;

    connectedCallback(){
        window.console.log('main - connected');
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