import { LightningElement } from 'lwc';
import getMRCDogs from '@salesforce/apex/MRCTreatmentPlansReportLWCController.getMRCDogsForPDF';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
import { NavigationMixin } from 'lightning/navigation';

export default class MrcTreatmentPlansReportMain extends NavigationMixin(LightningElement) {
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

    exportAsPdf() {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: '/apex/MRCTreatmentPlanReportPDF'
            }
        }).then(generatedUrl => {
            window.open(generatedUrl);
        });
    }
}