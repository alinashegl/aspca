import { LightningElement, api, wire } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import getAnimalDailyCareInfo from '@salesforce/apex/DailyCareLWCController.getAnimalDailyCareInfo';

import HANDLING_INSTRUCTIONS_FIELD from '@salesforce/schema/Animal_Daily_Care__c.Handling_Instructions__c';
import MOVEMENT_AND_CLEANING__DESTINATION_FIELD from '@salesforce/schema/Animal_Daily_Care__c.Mvmt_Round_Notes_Cleaning_Destination__c';
import FEEDING_AMOUNT_FIELD from '@salesforce/schema/Animal_Daily_Care__c.Feeding_Amount__c';
import ROUND_FIELD from '@salesforce/schema/Animal_Daily_Care__c.Round__c';
import SPECIAL_CARE_OTHER_FIELD from '@salesforce/schema/Animal_Daily_Care__c.Special_Care_Other__c';
import SPECIAL_CARE_OUTSIDE_FIELD from '@salesforce/schema/Animal_Daily_Care__c.Special_Care_Outside_TX__c';
import SPECIAL_CARE_FIELD from '@salesforce/schema/Animal_Daily_Care__c.Special_Care_TX__c';
import ENRICHMENT_FIELD from '@salesforce/schema/Animal_Daily_Care__c.Enrichment__c';


import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import ANIMAL_DAILY_CARE_OBJECT from '@salesforce/schema/Animal_Daily_Care__c';


export default class AnimalDailyCare extends LightningElement {

    @wire(getObjectInfo, { objectApiName: ANIMAL_DAILY_CARE_OBJECT })
    animalDailyCareMetadata;
    // now retriving the StageName picklist values of Opportunity
    @wire(getPicklistValues,
        {
            recordTypeId: '$animalDailyCareMetadata.data.defaultRecordTypeId', 
            fieldApiName: ROUND_FIELD
        }
    )
    roundPicklist;

    handlingInstructionsFieldAPI = HANDLING_INSTRUCTIONS_FIELD.fieldApiName;
    movemntAndCleaningDestinationFieldAPI = MOVEMENT_AND_CLEANING__DESTINATION_FIELD.fieldApiName;
    roundFieldAPI = ROUND_FIELD.fieldApiName;
    specialCareOtherFieldAPI = SPECIAL_CARE_OTHER_FIELD.fieldApiName;
    specialCareOutsideFieldAPI = SPECIAL_CARE_OUTSIDE_FIELD.fieldApiName;
    specialCareFieldAPI = SPECIAL_CARE_FIELD.fieldApiName;
    feedingAmountFieldAPI = FEEDING_AMOUNT_FIELD.fieldApiName;
    enrichmentAPI = ENRICHMENT_FIELD.fieldApiName;

    @api recordId;
    animalDailyCareInfo;
    showSpinner = false;

    error;
    errorMessage;

    @wire(getAnimalDailyCareInfo, {animalDailyCareId: '$recordId'})
    response(result) {
        if(result.data){
            this.animalDailyCareInfo = result.data;
        }
        else if(result.error){
            this.errorMessage = 'Error retrieving Animal Daily Care:';
            this.error = result.error;
        }
    }

    handleInputBlur(event){
        this.showSpinner = true;

        const fields = {};
        fields[event.target.dataset.field] = event.target.value;
        fields['Id'] = this.recordId;

        const recordInput = { fields };

        updateRecord(recordInput)
        .then(() => {
            window.console.log('success');
        })
        .catch(error => {
            window.console.log('error: ', error.body.message);
            this.errorMessage = 'Error updating Animal Daily Care:';
            this.error = error;
        })
        .finally(() => {
            this.showSpinner = false;
        });
    }
}