import { LightningElement, api, wire } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import getSpsInfo from '@salesforce/apex/TreatmentSessionLWCController.getSpsInfo';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';

export default class TreatmentSessionScoreScale extends LightningElement {
    @api record;
    additionalFields;
    showSpinner = false;
    error;

    selectedValue;
    recordResponse;

    connectedCallback(){
        if(this.record.id != null && this.recordResponse == null){
            this.showSpinner = true;
            getSpsInfo({id: this.record.id, fields : this.record.additionalFields})
            .then((response) => {
                if(response){
                    this.recordResponse = response;
                    this.showSpinner = false;
                }
            });
        }
    }

    handleRadioChange(event) {
        const selectedOption = event.detail.value;
        this.showSpinner = true;

        const fields = {};
        fields['Protocol_Score__c'] = selectedOption;
        fields['Id'] = this.record.id;
        const recordInput = { fields };
        
        updateRecord(recordInput)
        .then(() => {
            window.console.log('success');
        })
        .catch(error => {
            window.console.log('error: ', error.body.message);
            this.errorMessage = 'Error updating Animal Daily Care:';
            this.error = error;
        })
        .finally(() => {
            this.showSpinner = false;
            const event = new CustomEvent("statusrefresh", {  });
            this.dispatchEvent(event);
        });

    }

    handleInputBlur(event){
        this.showSpinner = true;

        const fields = {};
        fields[event.target.dataset.field] = event.target.value;
        fields['Id'] = this.record.id;

        const recordInput = { fields };
        window.console.log('fields: ' , JSON.stringify(fields));

        updateRecord(recordInput)
        .then(() => {
            window.console.log('success');
        })
        .catch(error => {
            window.console.log('error: ', error.body.message);
            this.errorMessage = 'Error updating field:';
            this.error = error;
        })
        .finally(() => {
            this.showSpinner = false;
        });
    }

    get showOptions(){
        return this.record.options && this.recordResponse;
    }
}