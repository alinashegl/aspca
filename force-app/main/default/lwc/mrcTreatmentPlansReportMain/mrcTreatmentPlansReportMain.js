import { LightningElement } from 'lwc';
import getMRCDogs from '@salesforce/apex/MRCTreatmentPlansReportLWCController.getMRCDogsForPDF';
import getTipOfMonth from '@salesforce/apex/MRCTreatmentPlansReportLWCController.getTipOfMonth';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
import { NavigationMixin } from 'lightning/navigation';

export default class MrcTreatmentPlansReportMain extends NavigationMixin(LightningElement) {
    animalInfoList;
    tipOfMonth;

    connectedCallback(){
        window.console.log('main - connected');
        if(this.animalInfoList == undefined){
            getMRCDogs()
            .then((result) => {
                this.animalInfoList = result;
                this.getTOM();
            });
        }
    }

    getTOM(){
        getTipOfMonth()
        .then((result) => {
            this.tipOfMonth = result;
            window.console.log("tip of month: ", this.tipOfMonth);
        });
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

    handleTOMBlur(event){
        window.console.log('TOM: ', event.target.value);
    }
}