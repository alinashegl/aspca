import { LightningElement } from 'lwc';
import getMRCDogs from '@salesforce/apex/MRCTreatmentPlansReportLWCController.getMRCDogsForPDF';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';

export default class MrcTreatmentPlansReportMain extends LightningElement {
    animalInfoList;

    connectedCallback(){
        window.console.log('main - connected');
        if(this.animalInfoList == undefined){
            getMRCDogs()
            .then((result) => {
                this.animalInfoList = result;
            });
        }
    }

    get animalListLength(){
        return this.animalInfoList != undefined ? this.animalInfoList.length : null;
    }
}