import { LightningElement, api, wire } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';

// import ANIMAL_PG_NAME_FIELD from '@salesforce/schema/Animal_Playgroup__c.Animal_Name__c';
import ANIMAL_PG_NOTES_FIELD from '@salesforce/schema/Animal_Playgroup__c.Playgroup_Individual_Notes__c';
// import ANIMAL_LOCATION_FIELD from '@salesforce/schema/Animal_Playgroup__c.Animal__r.Shelter_Location2__c';
// import ANIMAL_ID_FIELD from '@salesforce/schema/Animal_Playgroup__c.Animal__r.Name';
// import ANIMAL_SEX_FIELD from '@salesforce/schema/Animal_Playgroup__c.Animal__r.Gender__c';
// import ANIMAL_PLAY_PRIORITY_FIELD from '@salesforce/schema/Animal_Playgroup__c.Animal__r.Play_Priority__c';
// import ANIMAL_PLAY_CATEGORY_FIELD from '@salesforce/schema/Animal_Playgroup__c.Animal__r.Play_Category__c';

export default class PlaygroupSessionAnimal extends LightningElement {
    @api animalId;
    @api animalPlaygroupId;

    fields = [ANIMAL_PG_NOTES_FIELD];

    @wire(getRecord, {recordId: '$animalPlaygroupId', fields: '$fields'})
    animalPlaygroup;
    
}