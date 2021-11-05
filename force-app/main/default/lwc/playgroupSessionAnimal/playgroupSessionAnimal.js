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
        this.animalPendingUpdate = true;
    }

    handleOnChangeAnimalPlaygroup(event){
        const target = event.target;
        this.animalPlaygroupChanges[target.dataset.id] = target.value;
        this.animalPlaygroupPendingUpdate = true;
    }

    animalUpdateInProgress = false;
    playgroupUpdteInProgress = false;
    handleSaveDog(event){
        window.console.log('save Dog');
        event.preventDefault();
        const form = this.template.querySelectorAll('lightning-record-edit-form');
        if(this.animalPendingUpdate){
            this.animalUpdateInProgress = true;
            form[0].submit(this.animalChanges);
        }
        if(this.animalPlaygroupPendingUpdate){
            this.playgroupUpdteInProgress = true;
            form[1].submit(this.animalPlaygroupChanges);
        }
    }

    animalPendingUpdate = false;
    handleAnimalUpdateSuccess(){
        window.console.log('handleAnimalUpdateSuccess');
        this.animalPendingUpdate = false;
        this.animalUpdateInProgress = false;
        this.animalChanges = {Type_of_Animal__c: 'Dog'};
    }

    animalPlaygroupPendingUpdate = false;
    handleAnimalPlaygroupUpdateSuccess(){
        window.console.log('animalPlaygroupUpdateSuccess');
        this.animalPlaygroupPendingUpdate = false;
        this.playgroupUpdteInProgress = false;
        this.animalPlaygroupChanges = {};
    }

    handleAnimalUpdateError(event){
        const error = event.detail.detail;
        console.log('Animal update error: ', error);
        this.animalUpdateInProgress = false;
        this.playgroupUpdteInProgress = false;
        this.error = error;
    }

    get showSpinner(){
        return this.animalUpdateInProgress || this.playgroupUpdteInProgress;
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
        return !this.animalPlaygroupPendingUpdate && !this.animalPendingUpdate;
    }
    
}