import { LightningElement } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import getMRCDogs from '@salesforce/apex/MRCTreatmentPlansReportLWCController.getMRCDogsForPDF';
import getTipOfMonth from '@salesforce/apex/MRCTreatmentPlansReportLWCController.getTipOfMonth';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
import { NavigationMixin } from 'lightning/navigation';

import GENERAL_DATA_ID_FIELD from '@salesforce/schema/Generic_Data__c.Id';
import GENERAL_DATA_TEXT_FIELD from '@salesforce/schema/Generic_Data__c.Text__c';

export default class MrcTreatmentPlansReportMain extends NavigationMixin(LightningElement) {
    animalInfoList;
    tipOfMonth;
    showSpinner = false;
    error;

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
        this.showSpinner = true;
        getTipOfMonth()
        .then((result) => {
            this.tipOfMonth = result;
            window.console.log("tip of month: ", this.tipOfMonth);
        })
        .finally(() => {
            this.showSpinner = false;
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
        this.showSpinner = true;
        window.console.log('TOM: ', event.target.value);
        const fields = {};
        fields[GENERAL_DATA_ID_FIELD.fieldApiName] = this.tipOfMonth.Id;
        fields[GENERAL_DATA_TEXT_FIELD.fieldApiName] = event.target.value;
        
        this.updateTipOfMonth(fields);
    }

    updateTipOfMonth(fields){
        const recordUpdate = {fields};
        updateRecord(recordUpdate).then(recordUpdate => {
            
        })
        .catch(error => {
            this.errorMessage = 'Error updating Animal Helper Dogs:';
            this.error = error;
        })
        .finally(() => {
            this.showSpinner = false;
        });
    }
}