import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class EvaluationTabHeader extends NavigationMixin(LightningElement) {
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
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(event) {
        this.showModal = false;
        let evaluationId = event.detail.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: evaluationId,
                actionName: 'view',
            }
        });
    }
}