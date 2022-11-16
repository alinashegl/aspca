import { LightningElement, api, wire } from 'lwc';
import { getRecord, updateRecord, getFieldValue } from 'lightning/uiRecordApi';

import ANIMAL_ID_FIELD from '@salesforce/schema/Behavior_Evaluation__c.Animal__c';
import ANIMAL_PLAY_CATEGORY from '@salesforce/schema/Behavior_Evaluation__c.Animal__r.Play_Category__c';

export default class PlayCategoryPicklist extends LightningElement {
    @api recordId
    error;
    categorySuccessfullyUpdated = false;
    showSpinner = false;

    options=[
        {label: 'Unevaluated', value: 'Unevaluated'},
        {label: 'PG Re-Eval', value: 'PG Re-Eval'},
        {label: 'Playgroup Eligible', value: 'Playgroup Eligible'},
        {label: 'Foster Playgroup Eligible', value: 'Foster Playgroup Eligible'},
        {label: 'DO NOT PLAY', value: 'DO NOT PLAY'},
        {label: 'New/Unknown', value: 'New/Unknown'}
    ]

    @wire(getRecord, { recordId: '$recordId', fields: [ANIMAL_ID_FIELD, ANIMAL_PLAY_CATEGORY]})
    eval;

    selectionChangeHandler(event){
        window.console.log('selectionChangeHandler: ', event.target.value);
        this.showSpinner = true;
        this.categorySuccessfullyUpdated = false;
        const fields = {};
        fields['Id'] = this.animalId;
        fields['Play_Category__c'] = event.target.value;
        const recordUpdate = {fields};
        window.console.log('fields: ', JSON.stringify(fields));
        updateRecord(recordUpdate).then(recordUpdate => {
            this.error = undefined;
            this.categorySuccessfullyUpdated = true;
        })
        .catch(error => {
            this.error = error;
        })
        .finally(() =>{
            this.showSpinner = false;
        })
    }

    get animalId() {
        return getFieldValue(this.eval.data, ANIMAL_ID_FIELD);
    }

    get playCategory() {
        return getFieldValue(this.eval.data, ANIMAL_PLAY_CATEGORY) == null ?
            'Unevaluated' :
            getFieldValue(this.eval.data, ANIMAL_PLAY_CATEGORY);
    }
}