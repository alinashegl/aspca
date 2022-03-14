import { LightningElement, api, wire } from 'lwc';
import getAnimalInfo from '@salesforce/apex/MRCTreatmentPlansReportLWCController.getAnimalInfo';

import ANIMAL_NAME_ID_FIELD from '@salesforce/schema/Animal__c.Animal_Name_Id__c';
import ANIMAL_GENDER_FIELD from '@salesforce/schema/Animal__c.Gender__c';
import ANIMAL_BREED_FIELD from '@salesforce/schema/Animal__c.Breed__c';
import ANIMAL_LOCATION_FIELD from '@salesforce/schema/Animal__c.Current_Location__c';

export default class MrcTreatmentPlansAnimal extends LightningElement {
    @api recordId;
    animalInfo;
    error;

    @wire(getAnimalInfo, {recordId: '$recordId'})
    response(result){
        if(result.data){
            this.animalInfo = result.data;
        }
        else {
            this.error=result.error;
        }
    }

    animalNameIdField = ANIMAL_NAME_ID_FIELD.fieldApiName;
    animalGenderField = ANIMAL_GENDER_FIELD.fieldApiName;
    animalBreedField = ANIMAL_BREED_FIELD.fieldApiName;
    animalLocationField = ANIMAL_LOCATION_FIELD.fieldApiName;

    get fearSocializationProtocols(){
        if(this.animalInfo != undefined && this.animalInfo.categoryToProtocolIdMap != undefined){
            return this.animalInfo.categoryToProtocolIdMap["Fear Socialization"];
        }
    }

    get fearLeashingProtocols(){
        if(this.animalInfo != undefined && this.animalInfo.categoryToProtocolIdMap != undefined){
            return this.animalInfo.categoryToProtocolIdMap["Fear Leashing"];
        }
    }

    get fearWalkingProtocols(){
        if(this.animalInfo != undefined && this.animalInfo.categoryToProtocolIdMap != undefined){
            return this.animalInfo.categoryToProtocolIdMap["Fear Walking"];
        }
    }

    get fearHandlingProtocols(){
        if(this.animalInfo != undefined && this.animalInfo.categoryToProtocolIdMap != undefined){
            return this.animalInfo.categoryToProtocolIdMap["Fear Handling"];
        }
    }

    get fearContainmentProtocols(){
        if(this.animalInfo != undefined && this.animalInfo.categoryToProtocolIdMap != undefined){
            return this.animalInfo.categoryToProtocolIdMap["Fear Containment"];
        }
    }

    get nonFearProtocols(){
        if(this.animalInfo != undefined && this.animalInfo.categoryToProtocolIdMap != undefined){
            return this.animalInfo.categoryToProtocolIdMap["Non Fear Protocols"];
        }
    }


}