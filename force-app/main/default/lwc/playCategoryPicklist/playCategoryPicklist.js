import { LightningElement, api, wire } from 'lwc';
import { getRecord, updateRecord, getFieldValue } from 'lightning/uiRecordApi';

import ANIMAL_ID_FIELD from '@salesforce/schema/Behavior_Evaluation__c.Animal__c';
import ANIMAL_PLAY_CATEGORY from '@salesforce/schema/Behavior_Evaluation__c.Animal__r.Play_Category__c';

export default class PlayCategoryPicklist extends LightningElement {
    @api recordId
    error;
    categorySuccessfullyUpdated = false;

    options=[
        {label: 'New/Unknown', value: 'New/Unknown'},
        {label: 'PG Re-Eval', value: 'PG Re-Eval'},
        {label: 'DO NOT PLAY', value: 'DO NOT PLAY'}
    ]

    @wire(getRecord, { recordId: '$recordId', fields: [ANIMAL_ID_FIELD, ANIMAL_PLAY_CATEGORY]})
    eval;

    selectionChangeHandler(event){
        window.console.log('selectionChangeHandler: ', event.target.value);
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
        });
    }

    get animalId() {
        return getFieldValue(this.eval.data, ANIMAL_ID_FIELD);
    }

    get playCategory() {
        return getFieldValue(this.eval.data, ANIMAL_PLAY_CATEGORY);
    }

}