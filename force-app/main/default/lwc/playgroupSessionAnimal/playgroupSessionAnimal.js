import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue, updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import FORM_FACTOR from '@salesforce/client/formFactor';
import ANIMAL_NAME_FIELD from '@salesforce/schema/Animal__c.Animal_Name__c';
import ANIMAL_PLAY_RATING_FIELD from '@salesforce/schema/Animal__c.Play_Rating__c';
import CONTACT_ID_FIELD from '@salesforce/schema/Playgroup_Contact__c.Id';
import CONTACT_NOVEL_FIELD from '@salesforce/schema/Playgroup_Contact__c.Novel_Not_Novel__c';
import removeFromPlaygroup from '@salesforce/apex/playgroupSessionLWCController.removeFromPlaygroup';
import getAnimalInfo from '@salesforce/apex/playgroupSessionLWCController.getAnimalInfo';

export default class PlaygroupSessionAnimal extends LightningElement {
    @api animalId;
    @api playgroupAnimalId;
    
    _refresh;
    @api
    get refresh() {
        return this._refresh;
    }
    set refresh(value) {
        this._refresh = value;
        refreshApex(this.wireResponse);
    }

    animalPlaygroupPendingUpdate = false;
    animalPendingUpdate = false;
    animalUpdateInProgress = false;
    playgroupUpdteInProgress = false;

    animalPlaygroupChanges = {};
    animalChanges = {Type_of_Animal__c: 'Dog'};
    showContacts = false;
    confirmDelete = false;
    modalClass = FORM_FACTOR == 'Small' ? 'slds-fade-in-open' : 'slds-modal slds-fade-in-open';
    error;

    wireResponse;
    animalContacts = [];
    animalNameResponse;
    playRatingValue;

    @wire(getAnimalInfo, {playgroupAnimalId: '$playgroupAnimalId'})
    response(result){
        this.wireResponse = result;
        if(result.data){
            let contactList = [];
            this.animalContacts = [];

            contactList = result.data.animalContacts;
            if(result.data.animal != null){
                window.console.log('animal response: ', result.data.animal.Animal_Name__c);
                this.animalNameResponse = result.data.animal.Animal_Name__c;
                this.playRatingValue = result.data.animal.Play_Rating__c;
            }

            if(contactList != null && contactList.length > 0){
                contactList.forEach(contact => {
                    this.animalContacts.push({
                        id: contact.Id,
                        name: contact.Contact__r.Name,
                        checked: contact.Novel_Not_Novel__c == 'Familiar'
                    });
                });
            }
        } 
        else if(result.error){
            this.error = result.error;
        }
    }

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

    handleOnChangeAnimalPlayRating(event){
        const target = event.target;
        this.animalPlaygroupChanges[target.dataset.id] = target.value;
        this.animalPlaygroupPendingUpdate = true;
        this.playRatingValue = target.value;
    }

    handleSaveDog(event){
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

    handleAnimalUpdateSuccess(){
        this.animalPendingUpdate = false;
        this.animalUpdateInProgress = false;
        this.animalChanges = {Type_of_Animal__c: 'Dog'};
    }

    handleAnimalPlaygroupUpdateSuccess(){
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

    handleToggleChange(event){
        const evt = event.target;
        const fields = {};
        fields[CONTACT_ID_FIELD.fieldApiName] = evt.dataset.id;
        fields[CONTACT_NOVEL_FIELD.fieldApiName] = evt.checked ? 'Familiar' : 'Novel';
        const recordUpdate = {fields: fields};

        updateRecord(recordUpdate)
        .then(() => {})
        .catch(error => {
            this.error = error;
        });
    }

    handleToggleShowContacts(){
        this.showContacts = !this.showContacts;
    }

    handleRemoveAnimal(event){
        this.confirmDelete = true;
    }

    handleCloseModal (){
        this.confirmDelete = false;
    }

    handleConfirmRemoveAnimal(){
        this.playgroupUpdteInProgress = true;
        removeFromPlaygroup({animalPlagroupId: this.playgroupAnimalId})
        .then(() => {
            const selectedEvent = new CustomEvent('removedevent', {});
            this.dispatchEvent(selectedEvent);
        })
        .catch((error) => {
            this.error = error;
        })
        .finally(() => {
            this.playgroupUpdteInProgress = false;
        });
    }

    get showSpinner(){
        return this.animalUpdateInProgress || this.playgroupUpdteInProgress;
    }

    get layoutItemPadding(){
        return FORM_FACTOR == 'small' ? 'around-small' : 'around-medium';
    }

    get updateDogButtonLabel() {
        return 'Update ' + this.animalNameResponse;
    }

    get animalName() {
        return this.animalNameResponse;
    }

    get playRating(){
        if(this.playRatingValue == 'Green'){
            return 'play-rating-green';
        }
        else if(this.playRatingValue == 'Yellow'){
            return 'play-rating-yellow';
        }
        else {
            return 'play-rating-red';
        }
    }    

    get disableUpdateDogButton(){
        return !this.animalPlaygroupPendingUpdate && !this.animalPendingUpdate;
    }

    get showContactsButtonLabel(){
        return this.showContacts ? 'Hide Contacts' : 'Show Contacts';
    }

    get isLargeFormFactor(){
        return FORM_FACTOR != 'Small';
    }

    get deleteButtonLabel(){
        return FORM_FACTOR == 'Small' ? 'Remove' : 'Remove Animal';
    }
    
}