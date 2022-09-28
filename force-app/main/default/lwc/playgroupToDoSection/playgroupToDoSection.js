import { api, LightningElement } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
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
    error;
    showTextSpinner = false;
    showBooleanSpinner = false;

    leashNotes;

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

        this.leashNotes = this.playgroupAnimal.Does_Not_Walk_on_a_Leash_Notes__c;
    }

    handleWalkOnLeashChange(event){
        const value = event.target.checked;
        window.console.log('walk on leash change: ', value);
        this.showBooleanSpinner = true;
        this.updateAnimal('Does_Not_Walk_on_a_Leash__c', value);
    }

    handleLeashNotesChange(event){
        const value = event.target.value;
        window.console.log('leash notes change: ', value);
        if(value == this.leashNotes){
            window.console.log('match');
        } else {
            window.console.log('not match');
            this.leashNotes = value;
            this.showTextSpinner = true;
            this.updateAnimal('Does_Not_Walk_on_a_Leash_Notes__c', value);
            
        }
    }

    updateAnimal(field, value){
        this.showSpinner = true;
        const fields = {};
        fields['Id'] = this.playgroupAnimal.Id;
        fields[field] = value;
        const recordUpdate = {fields: fields};

        updateRecord(recordUpdate)
        .then(() => {
            window.console.log('updated animal');
        })
        .catch(error => {
            this.error = error;
        })
        .finally(() => {
            this.showTextSpinner = false;
            this.showBooleanSpinner = false;
        });
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