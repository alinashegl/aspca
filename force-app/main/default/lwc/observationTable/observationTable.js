import { LightningElement, api, wire } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor'
import { NavigationMixin } from "lightning/navigation";
import { createRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import getObservations from '@salesforce/apex/ObservationController.getObservations';

import OBSERVATION_OBJECT from "@salesforce/schema/Observation__c";
import OBSERVATION_DATE_FIELD from '@salesforce/schema/Observation__c.Observation_Date__c';
import OBSERVATION_NOTES_FIELD from '@salesforce/schema/Observation__c.Observation_Notes__c';
import OBSERVATION_BY_FIELD from '@salesforce/schema/Observation__c.Observation_Reported_By__c';
import OBSERVATION_RESPONSE_FIELD from '@salesforce/schema/Observation__c.Behavior_Response__c';
import OBSERVATION_BEH_FIELD from '@salesforce/schema/Observation__c.Behavior_Staff_Initials__c';
import OBSERVATION_TYPE_FIELD from '@salesforce/schema/Observation__c.Observation_Type__c';
import OBSERVATION_ANIMAL_FIELD from '@salesforce/schema/Observation__c.Animal__c';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'View',
      type: 'button',
      initialWidth: '50px',
      typeAttributes: { label: "View", name: "goToObservation", variant: "base"}
    },
    { label: 'Date', fieldName: 'Observation_Date__c', type:'date-local', initialWidth: '50px'},
    { label: 'Notes', fieldName: 'Observation_Notes__c' },
    { label: 'Initials', fieldName: 'Observation_Reported_By__c', initialWidth: '50px' }
];

export default class ObservationTable extends NavigationMixin(LightningElement) {
    @api recordId;
    @api observationType;
    count = 5;
    returnedList = [];
    observationList = [];
    wireResponse;
    columns = columns;
    addNewObservation = false;
    updating = true;

    @wire(getObservations, {recordId: '$recordId', observationType: '$observationType'})
    response(result){
        this.wireResponse = result;
        this.returnedList = result.data;
        this.updateActiveList();
    }

    handleRowAction(event) {
        if (event.detail.action.name === "goToObservation") {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.detail.row.Id,
                    objectApiName: 'Observation__c',
                    actionName: 'view'
                }
            });
        }
    }

    goToObservation(event){
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.dataset.id,
                objectApiName: 'Observation__c',
                actionName: 'view'
            }
        })
        .then(url => { window.open(url) });
    }

    updateActiveList(){
        if(this.count == 5 && this.returnedList && this.returnedList.length > 5){
            this.observationList = this.returnedList.slice(0, 5)

        } else {
            this.observationList = this.returnedList;
        }
        this.updating = false;
    }

    handleNew(){
        window.console.log('new button clicked');
        this.addNewObservation = !this.addNewObservation;
    }

    handleInsertNewObservation(){

        const inputsValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);

        const textAreaValid = [...this.template.querySelectorAll('lightning-textarea')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
        }, true);

        if (inputsValid && textAreaValid) {
            this.insertNewObservation();
        } else {
            this.handleToastEvent("Error Validating Fields", 'Please populate all fields and try again.', "error");
        }
    }

    insertNewObservation(){
        this.updating = true;
        const fields = {};
        fields[OBSERVATION_TYPE_FIELD.fieldApiName] = this.observationType;
        fields[OBSERVATION_DATE_FIELD.fieldApiName] = this.template.querySelector("lightning-input[data-name=dateInput]").value;
        fields[OBSERVATION_NOTES_FIELD.fieldApiName] = this.template.querySelector("lightning-textarea[data-name=descriptionInput]").value;
        fields[OBSERVATION_BY_FIELD.fieldApiName] = this.template.querySelector("lightning-input[data-name=initialInput]").value;
        if(this.isConcernType){
            fields[OBSERVATION_RESPONSE_FIELD.fieldApiName] = this.template.querySelector("lightning-textarea[data-name=responseInput]").value;
            fields[OBSERVATION_BEH_FIELD.fieldApiName] = this.template.querySelector("lightning-input[data-name=behInitialInput]").value;
        }
        fields[OBSERVATION_ANIMAL_FIELD.fieldApiName] = this.recordId;

        const recordInput = { apiName: OBSERVATION_OBJECT.objectApiName, fields };
        
        window.console.log('fields =', JSON.stringify(fields));

        createRecord(recordInput)
        .then((response) => {
            this.handleToastEvent('Success', 'Observation successfully created', 'success' );
        })
        .catch((error) => {
            console.error(error);
            this.handleToastEvent("Error creating record", error.message, "error");
        })
        .then(() =>{
            this.addNewObservation = false;
            refreshApex(this.wireResponse);
        })
        .finally(() => {
            this.updating = false;
        });
    }

    toggleViewAll(){
        this.count = this.count == 5 ? null : 5;
        this.updateActiveList();
    }

    handleToastEvent(title, message, variant){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }

    get observatinLenght(){
        return this.observationList.data.length;
    }

    get titleLabel(){
        return this.observationList && this.returnedList ? this.observationType +  's (' +  this.observationList.length + ' of ' + this.returnedList.length + ')' : this.observationType +  's (0)';
    }

    get footerButtonLabel(){
        return this.count == 5? 'View All' : 'Collapse View';
    }

    get buttonIconToggleView(){
        return this.count == 5 ? 'utility:chevronright' : 'utility:chevrondown';
    }

    get buttonIconAddNew(){
        return this.addNewObservation ? 'utility:close' : 'utility:new';
    }

    get newButtonLabel(){
        return 'New ' + this.observationType;
    }

    get dateValue(){
        let today = new Date();
        let dd = String(today.getDate()).padStart(2, '0');
        let mm = String(today.getMonth() + 1).padStart(2, '0');
        let yyyy = today.getFullYear();

        today = yyyy + '-' + mm + '-' + dd;
        return today;
    }

    get isSmallDevice(){
        return FORM_FACTOR == 'Small';
    }

    get addNewButtonClass(){
        return this.isSmallDevice ? 'slds-form-element__static' : 'slds-form-element__static slds-var-m-top_large'
    }

    get moreThan5(){
        return this.returnedList && this.returnedList.length > 5 ? true: false;
    }

    get isConcernType(){
        return this.observationType == 'Concern';
    }
}