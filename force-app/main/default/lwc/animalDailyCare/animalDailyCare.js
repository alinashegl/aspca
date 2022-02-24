import { LightningElement, api, wire } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import getAnimalDailyCareInfo from '@salesforce/apex/DailyCareLWCController.getAnimalDailyCareInfo';

// import ANIMAL_NAME_FIELD from '@salesforce/schema/Animal_Daily_Care__c.Animal__r.Animal_Name_Id__c';
import HANDLING_INSTRUCTIONS_FIELD from '@salesforce/schema/Animal_Daily_Care__c.Handling_Instructions__c';
import MOVEMENT_FOR_CLEANING_FIELD from '@salesforce/schema/Animal_Daily_Care__c.Movements_For_Cleaning__c';
import ROUND_FIELD from '@salesforce/schema/Animal_Daily_Care__c.Round__c';
import SPECIAL_CARE_OTHER_FIELD from '@salesforce/schema/Animal_Daily_Care__c.Special_Care_Other__c';
import SPECIAL_CARE_OUTSIDE_FIELD from '@salesforce/schema/Animal_Daily_Care__c.Special_Care_Outside_TX__c';
import SPECIAL_CARE_FIELD from '@salesforce/schema/Animal_Daily_Care__c.Special_Care_TX__c';

export default class AnimalDailyCare extends LightningElement {
    // animalNameField = ANIMAL_NAME_FIELD;
    handlingInstructionsField = HANDLING_INSTRUCTIONS_FIELD;
    movemntForCleaningField = MOVEMENT_FOR_CLEANING_FIELD;
    roundField = ROUND_FIELD;
    specialCareOtherField = SPECIAL_CARE_OTHER_FIELD;
    specialCareOutsideField = SPECIAL_CARE_OUTSIDE_FIELD;
    specialCareField = SPECIAL_CARE_FIELD;

    handlingInstructionsFieldAPI = HANDLING_INSTRUCTIONS_FIELD.fieldApiName;
    movemntForCleaningFieldAPI = MOVEMENT_FOR_CLEANING_FIELD.fieldApiName;
    roundFieldAPI = ROUND_FIELD.fieldApiName;
    specialCareOtherFieldAPI = SPECIAL_CARE_OTHER_FIELD.fieldApiName;
    specialCareOutsideFieldAPI = SPECIAL_CARE_OUTSIDE_FIELD.fieldApiName;
    specialCareFieldAPI = SPECIAL_CARE_FIELD.fieldApiName;

    @api recordId;
    animalDailyCareInfo;
    showSpinner = false;

    error;

    @wire(getAnimalDailyCareInfo, {animalDailyCareId: '$recordId'})
    response(result) {
        if(result.data){
            this.animalDailyCareInfo = result.data;
        }
        else if(result.error){
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
            this.error = error;
        })
        .finally(() => {
            this.showSpinner = false;
        });
    }
}