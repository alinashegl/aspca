import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import FORM_FACTOR from '@salesforce/client/formFactor';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class TreatmentTabHeader extends NavigationMixin(LightningElement) {
    @api
    recordId;
    showModal = false;
    showNewSessionModal = false;
    showNewTreatmentModal = false;
    error;
    @api showTreatmentPlanButton;
    @api showTreatmentSessionButton;
    @api showLast5TreatmentsReport;
    url = 'https://aspca.app.box.com/s/uuxtitu6j2pypol7vdj7qk3fa0tbkk4m';
    handleClick() {
        this.showModal = true;
        this.showNewTreatmentModal = true;
    }
    handleOpenNewWindow(event){
        window.open(this.url, '_blank');
        event.preventDefault();
    }
    handleCancel() {
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
        this.showModal = false;
        this.showNewTreatmentModal = false;
        this.showNewSessionModal = false;
    }
    
    handleSubmit(event){
        event.preventDefault();
        const fields = event.detail.fields;
        fields.Animal__c = this.recordId;
        if(this.customLookupNewId != undefined){
            fields.AssignedTreatmentBundleId__c = this.customLookupNewId;
        }
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

        this.dispatchEvent(
            new ShowToastEvent({
                title: "",
                message: "Treatment plan was created.",
                variant: "success"
            })
        );

    }
    handleError(event){
        console.log(JSON.stringify(event));
        this.error = [event.detail.message, event.detail.detail, JSON.stringify(event.detail.output)];
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

    handleNewSession(){
        this.showModal = true;
        this.showNewSessionModal = true;
    }

    get smallForm() {
        return FORM_FACTOR === 'Small';
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