import { LightningElement, wire } from 'lwc';
import getDailyCare from '@salesforce/apex/DailyCareLWCController.getDailyCare';
import SystemModstamp from '@salesforce/schema/APXT_BPM__Conductor__c.SystemModstamp';

import GENERAL_REMINDERS_FIELD from '@salesforce/schema/Daily_Care__c.General_Reminders__c';
import AM_REMINDERS_FIELD from '@salesforce/schema/Daily_Care__c.AM_Reminders__c';
import PM_REMINDERS_FIELD from '@salesforce/schema/Daily_Care__c.PM_Reminders__c';
import SPECIAL_PROJECTS_FIELD from '@salesforce/schema/Daily_Care__c.Special_Projects__c';
import SCENT_FIELD from '@salesforce/schema/Daily_Care__c.Scent_of_the_Week__c';
import { NavigationMixin } from 'lightning/navigation';

export default class DailyCareMain extends NavigationMixin(LightningElement) {
    generalRemindersField = GENERAL_REMINDERS_FIELD;
    amRemindersField = AM_REMINDERS_FIELD;
    pmRemindersField = PM_REMINDERS_FIELD;
    specialProjectsField = SPECIAL_PROJECTS_FIELD;
    scentField = SCENT_FIELD;

    careDate;
    dailyCareId;
    animalCareList= [];
    roundPicklistsValues = [];
    error;

    @wire(getDailyCare, {careDate: '$careDate'})
    response(result) {
        if(result.data){
            this.dailyCareId = result.data.dailyCareId;
            this.animalCareList = result.data.animalDailyCares;
            this.roundPicklistsValues = result.data.roundPicklistOptions;
        }
        else if(result.error){
            this.error = result.error;
        }
    }

    connectedCallback(){
        if(this.careDate == undefined){
            let today = new Date();
            this.careDate = today.toISOString().substring(0, 10);
        }

        // const styleTag = document.createElement('style');
        //     styleTag.innerText = "input-field { min-height: 250px; }";

        //     this.template.querySelector('lightning-input-field').appendChild(styleTag);
    }

    dateChange(event){
        this.careDate = event.target.value;
    }

    get hasDate(){
        return this.careDate != undefined && this.careDate != null;
    }

    get date(){
        return this.hasDate ? this.careDate : null;
    }

    get hasAnimalCareList(){
        return this.animalCareList != undefined && this.animalCareList != null;
    }
    handlePdf(event){
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: '/apex/DailyCarePDF?dailyCareId='+this.dailyCareId
            }
        }).then(generatedUrl => {
            window.open(generatedUrl,'_blank');
        });
    }

    handleDailyCare(event){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.dailyCareId,
                objectApiName: 'Daily_Care__c',
                actionName: 'view'
            },
        });
    }
}