import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import FORM_FACTOR from '@salesforce/client/formFactor'
import ANIMAL_NAME_FIELD from '@salesforce/schema/Animal__c.Animal_Name__c';

export default class PlaygroupSessionAnimal extends LightningElement {
    @api animalId;
    @api playgroupAnimalId;
    animalPlaygroupChanges = {};
    animalChanges = {Type_of_Animal__c: 'Dog'};
    // hasChanges = false;
    error;

    // _saveUpdates;
    // @api
    // get saveUpdates() {
    //     return this._saveUpdates;
    // }
    // set saveUpdates(value) {
    //     window.console.log('saveUpdates')
    //     if(value == true && this.animalPlaygroupChanges){
    //         const fields = this.animalPlaygroupChanges;
    //         this.template.querySelector('lightning-record-edit-form').submit(fields);
    //     }
    // }

    @wire(getRecord, {recordId: '$animalId', fields: [ANIMAL_NAME_FIELD]})
    animal;

    handleOnChangeAnimal(event){
        const target = event.target;
        this.animalChanges[target.dataset.id] = target.value;
        this.animalUpdateSuccess = false;
    }

    handleOnChangeAnimalPlaygroup(event){
        const target = event.target;
        this.animalPlaygroupChanges[target.dataset.id] = target.value;
        this.animalPlaygroupUpdateSuccess = false;
    }

    handleSaveDog(event){
        window.console.log('save Dog');
        event.preventDefault();
        const form = this.template.querySelectorAll('lightning-record-edit-form');
        form[0].submit(this.animalChanges);
        form[1].submit(this.animalPlaygroupChanges);
    }

    animalUpdateSuccess = true;
    handleAnimalUpdateSuccess(){
        window.console.log('handleAnimalUpdateSuccess');
        this.animalUpdateSuccess = true;
        this.animalChanges = {Type_of_Animal__c: 'Dog'};
    }

    animalPlaygroupUpdateSuccess = true;
    handleAnimalPlaygroupUpdateSuccess(){
        window.console.log('animalPlaygroupUpdateSuccess');
        this.animalPlaygroupUpdateSuccess = true;
        this.animalPlaygroupChanges = {};
    }

    handleAnimalUpdateError(event){
        const error = event.detail.detail;
        console.log('Animal update error: ', error);
        this.error = error;
    }

    get layoutItemPadding(){
        return FORM_FACTOR == 'small' ? 'around-small' : 'around-medium';
    }

    get updateDogButtonLabel() {
        return 'Update ' + this.animalName;
    }

    get animalName() {
        return getFieldValue(this.animal.data, ANIMAL_NAME_FIELD);
    }

    get disableUpdateDogButton(){
        return this.animalPlaygroupUpdateSuccess && this.animalUpdateSuccess;
    }
    
}