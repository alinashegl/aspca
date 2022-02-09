import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class TreatmentTabHeader extends NavigationMixin(LightningElement) {
    @api
    recordId;
    showModal = false;

    get smallForm() {
        return FORM_FACTOR === 'Small';
    }

    handleClick() {
        this.showModal = true;
    }

    handleCancel() {
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
        this.showModal = false;
    }
    
    handleSubmit(event){
        event.preventDefault();
        const fields = event.detail.fields;
        fields.Animal__c = this.recordId;
        if(this.customLookupNewId != undefined){
            fields.AssignedTreatmentBundleId__c = this.customLookupNewId;
        }
        window.console.log('fields: ', JSON.stringify(fields));
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(event) {
        this.showModal = false;
        let treatmentId = event.detail.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: treatmentId,
                actionName: 'view',
            }
        });
    }

    handlePdf() {
        let url = '/apex/Last5TreatmentsReport?animalId=' + this.recordId;
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: url
            }
        });
    }


    /*********** Custom Lookup component code ***********/
    customLookupNewId;
    tempTreatmentBundle
    customLookupClearSelection = true;

    customLookupEvent(event){
        this.customLookupNewId = event.detail.data.recordId;
        this.tempTreatmentBundle = event.detail.data.record;
    }

    //keeping this here because we may want to use it later, it's currenlty not needed
    handleCustomLookupExpandSearch(event){
        // let data = event.detail.data;
        // let dataId = data.elementId;
        // this.template.querySelector('[data-id="' + dataId + '"]').className =
        //     data.expandField ? 'slds-col slds-size_1-of-1' : data.initialColSize;
    }    

    get customLookupFields(){
        return ['Name'];
    }

    get customLookupDisplayFields(){
        return 'Name';
    }
}