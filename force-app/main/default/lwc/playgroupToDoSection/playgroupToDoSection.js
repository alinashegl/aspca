import { api, LightningElement, wire } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import PLAY_CATEGORY from '@salesforce/schema/Animal__c.Play_Category__c';

const fields = [PLAY_CATEGORY];

export default class PlaygroupToDoSection extends LightningElement {
    @api
    recordId;
    @api
    handlerCode;
    @api
    playgroup = false;
    hasRendered = false;
    isExpanded = false;
    isChanged = false;
    isEdit = false;

    @wire(getRecord, { recordId: '$recordId', fields })
    category;

    get categoryValue() {
        return getFieldValue(this.category.data, PLAY_CATEGORY);
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
    }
}