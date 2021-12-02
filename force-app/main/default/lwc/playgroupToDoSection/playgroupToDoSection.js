import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class PlaygroupToDoSection extends NavigationMixin(LightningElement) {
    @api
    playgroupAnimal;
    hasRendered = false;
    isExpanded = false;
    isChanged = false;
    isEdit = false;
    url;

    connectedCallback() {
        this.recordPageRef = {
            type: 'standard__recordPage',
            attributes: {
                recordId: this.playgroupAnimal.Id,
                actionName: 'view',
            }
        };
        this[NavigationMixin.GenerateUrl](this.recordPageRef)
            .then(url => this.url = url);
    }

    get categoryValue() {
        return this.playgroupAnimal.Play_Category__c;
    }

    get categoryClass() {
        return this.categoryValue === 'PG Re-Eval' ? 'categoryHighlight' : '';
    }

    get smallForm() {
        return FORM_FACTOR === 'Small';
    }

    get expanded() {
        return this.isExpanded || FORM_FACTOR === 'Large';
    }

    get changed() {
        return this.isChanged;
    }

    handleReset() {
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
        this.isEdit = false;
    }

    toggleExpand() {
        this.isExpanded = !this.isExpanded;
    }

    handleEdit() {
        this.isEdit = !this.isEdit;
    }

    handleSuccess() {
        this.isEdit = false;
        this.dispatchEvent(new CustomEvent('update'));
    }
}