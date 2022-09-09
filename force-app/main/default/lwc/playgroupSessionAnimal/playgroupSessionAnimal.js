import { LightningElement, api, wire } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import FORM_FACTOR from '@salesforce/client/formFactor';

//playgroup contact fields
import CONTACT_ID_FIELD from '@salesforce/schema/Playgroup_Contact__c.Id';
import CONTACT_NOVEL_FIELD from '@salesforce/schema/Playgroup_Contact__c.Novel_Not_Novel__c';

//animal fields
import ANIMAL_GENDER_FIELD from '@salesforce/schema/Animal__c.Gender__c';
import ANIMAL_LOCATION_FIELD from '@salesforce/schema/Animal__c.Current_Recent_Shelter_Location__c';
import ANIMAL_PLAYGROUP_LEVEL_FIELD from '@salesforce/schema/Animal__c.Playgroup_Priority_Level__c';
import ANIMAL_PLAYGROUP_CATEGORY_FIELD from '@salesforce/schema/Animal__c.Play_Category__c';
import ANIMAL_PLAY_STYLE_NOTES_FIELD from '@salesforce/schema/Animal__c.Play_Style_Notes__c';

//animal playgroup fields
import ANIMAL_PLAYGROUP_MANAGEMENT_TOOLS_FIELD from '@salesforce/schema/Animal_Playgroup__c.Common_Playgroup_Notes__c';
import ANIMAL_PLAYGROUP_INDIVIDUAL_NOTES_FIELD from '@salesforce/schema/Animal_Playgroup__c.Playgroup_Individual_Notes__c';
import ANIMAL_PLAYGROUP_PLAY_RATING_FIELD from '@salesforce/schema/Animal_Playgroup__c.Play_Rating__c';

import removeFromPlaygroup from '@salesforce/apex/playgroupSessionLWCController.removeFromPlaygroup';
import getAnimalInfo from '@salesforce/apex/playgroupSessionLWCController.getAnimalInfo';

export default class PlaygroupSessionAnimal extends LightningElement {

    contactIdFieldAPI = CONTACT_ID_FIELD.fieldApiName;
    contactNovelFieldAPI = CONTACT_NOVEL_FIELD.fieldApiName;    
    animalGenderFieldAPI = ANIMAL_GENDER_FIELD.fieldApiName;
    animalLocationFieldAPI = ANIMAL_LOCATION_FIELD.fieldApiName;
    animalPlaygroupLevelFieldAPI = ANIMAL_PLAYGROUP_LEVEL_FIELD.fieldApiName;
    animalPlayCategoryFieldAPI = ANIMAL_PLAYGROUP_CATEGORY_FIELD.fieldApiName;
    animalPlayStyleNotesFieldAPI = ANIMAL_PLAY_STYLE_NOTES_FIELD.fieldApiName;
    animalPlaygroupManagementToolsFieldAPI = ANIMAL_PLAYGROUP_MANAGEMENT_TOOLS_FIELD.fieldApiName;
    animalPlaygroupIndividualNotesFieldAPI = ANIMAL_PLAYGROUP_INDIVIDUAL_NOTES_FIELD.fieldApiName;
    animalPlaygroupPlayRatingFieldAPI = ANIMAL_PLAYGROUP_PLAY_RATING_FIELD.fieldApiName;

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

    playgroupUpdateInProgress = false;
    showContacts = false;
    confirmDelete = false;
    modalClass = FORM_FACTOR == 'Small' ? 'slds-fade-in-open' : 'slds-modal slds-fade-in-open';
    error;
    errorMessage;
    showSpinner = false;

    wireResponse;
    animalContacts = [];
    playRatingValue;
    animalInfo = {};

    @wire(getAnimalInfo, {playgroupAnimalId: '$playgroupAnimalId'})
    response(result){
        this.wireResponse = result;
        if(result.data){
            let contactList = [];
            this.animalContacts = [];

            contactList = result.data.animalContacts;
            if(result.data != null){
                window.console.log('animal response: ', result.data.animalName);
                this.playRatingValue = result.data.playRating;
                this.animalInfo = result.data;
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
        this.showSpinner = true;

        const fields = {};
        fields[event.target.dataset.field] = event.target.value;
        fields['Id'] = this.animalId;

        this.handleUpdateRecord(fields);
    }

    handleOnChangeAnimalPlaygroup(event){
        this.showSpinner = true;

        const fields = {};
        fields[event.target.dataset.field] = event.target.value;
        fields['Id'] = this.playgroupAnimalId;

        this.handleUpdateRecord(fields);
    }

    handleOnChangeAnimalPlayRating(event){
        const target = event.target;
        this.playRatingValue = target.value;

        this.showSpinner = true;

        const fields = {};
        fields[event.target.dataset.field] = target.value;
        fields['Id'] = this.playgroupAnimalId;

        this.handleUpdateRecord(fields);
    }

    handleUpdateRecord(fields){
        window.console.log('handleUpdateRecords: ', JSON.stringify(fields));
        const recordInput = { fields };

        updateRecord(recordInput)
        .then(() => {
            window.console.log('success');
        })
        .catch(error => {
            window.console.log('error: ', error.body.message);
            this.errorMessage = 'Error updating Animal:';
            this.error = error;
        })
        .finally(() => {
            this.showSpinner = false;
        });
    }

    handleToggleChange(event){
        const evt = event.target;
        const fields = {};
        fields[this.contactIdFieldAPI] = evt.dataset.id;
        fields[this.contactNovelFieldAPI] = evt.checked ? 'Familiar' : 'Novel';
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
        this.playgroupUpdateInProgress = true;
        removeFromPlaygroup({animalPlagroupId: this.playgroupAnimalId})
        .then(() => {
            const selectedEvent = new CustomEvent('removedevent', {});
            this.dispatchEvent(selectedEvent);
        })
        .catch((error) => {
            this.error = error;
        })
        .finally(() => {
            this.playgroupUpdateInProgress = false;
        });
    }

    get layoutItemPadding(){
        return FORM_FACTOR == 'small' ? 'around-small' : 'around-medium';
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