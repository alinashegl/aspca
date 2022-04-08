import { LightningElement, api, wire } from 'lwc';

import ANIMAL_NAME_ID_FIELD from '@salesforce/schema/Animal__c.Animal_Name_Id__c';
import ANIMAL_GENDER_FIELD from '@salesforce/schema/Animal__c.Gender__c';
import ANIMAL_BREED_FIELD from '@salesforce/schema/Animal__c.Breed__c';
import ANIMAL_LOCATION_FIELD from '@salesforce/schema/Animal__c.Current_Location__c';
import ANIMAL_SHELTER_COLOR_FIELD from '@salesforce/schema/Animal__c.Shelter_Color_Coding__c';
import ANIMAL_SHELTER_LOCATION_FIELD from '@salesforce/schema/Animal__c.Shelter_Location__c';
import ANIMAL_CURRENT_LOCATION_FIELD from '@salesforce/schema/Animal__c.Current_Location__c';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';

export default class MrcTreatmentPlansAnimal extends LightningElement {
    @api recordId;
    @api animalInfo
    error;
    showModal = false;

    animalNameIdField = ANIMAL_NAME_ID_FIELD.fieldApiName;
    animalGenderField = ANIMAL_GENDER_FIELD.fieldApiName;
    animalBreedField = ANIMAL_BREED_FIELD.fieldApiName;
    animalLocationField = ANIMAL_LOCATION_FIELD.fieldApiName;
    animalKennelLocationField = ANIMAL_SHELTER_LOCATION_FIELD.fieldApiName;
    currentLocationField = ANIMAL_CURRENT_LOCATION_FIELD.fieldApiName;
    animalShelterColorField = ANIMAL_SHELTER_COLOR_FIELD.fieldApiName;

    editHelperDogs(){
        window.console.log('edit helper dogs');
        this.showModal = !this.showModal;
    }

    get showAnimalInfo(){
        return this.animalInfo != undefined && this.animalInfo.dog != undefined;
    }

    get animalName() {
        return ' ' + this.animalInfo.dog[this.animalNameIdField];
    }

    get currentLocation(){
        return this.animalInfo.dog[this.currentLocationField];
    }

    get gender(){
        return this.animalInfo.dog[this.animalGenderField];
    }

    get breed(){
        return this.animalInfo.dog[this.animalBreedField];
    }

    get kennelLocation(){
        return this.animalInfo.dog[this.animalKennelLocationField];
    }

    get isShelterColorRed() {
        let isRed = false;
        if(this.animalInfo.dog[this.animalShelterColorField] != undefined){
            let shelterColor = this.animalInfo.dog[this.animalShelterColorField];
            if(shelterColor.includes('Red')){
                isRed = true;
            }
        }
        
        return isRed;
    }

    get isPlayPause(){
        return this.animalInfo != undefined && this.animalInfo.isPlayPause;
    }

    get fearSocializationProtocols(){
        if(this.animalInfo != undefined && this.animalInfo.categoryToProtocolMap != undefined){
            return this.animalInfo.categoryToProtocolMap["Fear Socialization"];
        }
    }

    get fearLeashingProtocols(){
        if(this.animalInfo != undefined && this.animalInfo.categoryToProtocolMap != undefined){
            return this.animalInfo.categoryToProtocolMap["Fear Leashing"];
        }
    }

    get fearWalkingProtocols(){
        if(this.animalInfo != undefined && this.animalInfo.categoryToProtocolMap != undefined){
            return this.animalInfo.categoryToProtocolMap["Fear Walking"];
        }
    }

    get fearHandlingProtocols(){
        if(this.animalInfo != undefined && this.animalInfo.categoryToProtocolMap != undefined){
            return this.animalInfo.categoryToProtocolMap["Fear Handling"];
        }
    }

    get fearContainmentProtocols(){
        if(this.animalInfo != undefined && this.animalInfo.categoryToProtocolMap != undefined){
            return this.animalInfo.categoryToProtocolMap["Fear Containment"];
        }
    }

    get nonFearProtocols(){
        if(this.animalInfo != undefined && this.animalInfo.categoryToProtocolMap != undefined){
            return this.animalInfo.categoryToProtocolMap["Non Fear Protocols"];
        }
    }

    // begin modal actions
    objectApi = "Additional_Dog_Present__c";
    record = {};
    // location = ;

    handleCloseModal(){
        this.showModal = false;
    }

    handleSave(){
        //handlesave
    }

}