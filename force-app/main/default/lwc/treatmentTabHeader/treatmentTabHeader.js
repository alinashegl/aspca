import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class TreatmentTabHeader extends NavigationMixin(LightningElement) {
    @api
    recordId;

    get smallForm() {
        return FORM_FACTOR === 'Small';
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
}