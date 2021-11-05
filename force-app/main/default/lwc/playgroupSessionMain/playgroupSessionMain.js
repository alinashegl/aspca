import { LightningElement, api, wire } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor'
import getPlaygroupSessionInfo from '@salesforce/apex/playgroupSessionLWCController.getPlaygroupSessionInfo';
import startPlaygroupSession from '@salesforce/apex/playgroupSessionLWCController.startPlaygroupSession';
import { getRecordCreateDefaults } from 'lightning/uiRecordApi';

export default class PlaygroupSessionMain extends LightningElement {
    @api recordId;
    @api newSession = false; //if newSession = true need to create a session
    @api animalIds = [];
    wireResponse;
    showSpinner = true;
    animals = [];
    playgroupContacts = [];
    session;
    sessionPlaygroupLeader;
    toggleDropdown = false;

    customLookupFields = ["Name","Email","Title"];
    customLookupDisplayFields = 'Name, Email, Title';
    customLookupCreateNewFields = ['FirstName', 'LastName', 'Title', 'Department', 'Email'];
    customLookupExpandedField = false;
    formFactor = FORM_FACTOR;

    sessionPendingUpdate = false;
    error;

    @wire(getPlaygroupSessionInfo, {sessionId: '$recordId'})
    response(result){
        this.wireResponse = result;
        if(result.data ){
            this.session = result.data.playgroupSession;
            this.sessionPlaygroupLeader = result.data.playgroupSession.Playgroup_Leader__c;
            if(result.data.animalPlaygroups){
                this.animals = result.data.animalPlaygroups;
            }
            if(result.data.playgroupContacts){
                this.playgroupContacts = result.data.playgroupContacts;
            }
            this.showSpinner = false;
        }
    }

    handleCopyPlaygroup(){
        this.showSpinner = true;
        startPlaygroupSession({sessionId: this.recordId})
        .then((response) => {
            this.recordId = response;
        })
        .finally(() => {
            this.showSpinner = false;
        })
    }

    customLookupEvent(event){
        window.console.log('customLookupEvent: ', JSON.stringify ( event.detail));
        this.sessionPlaygroupLeader = event.detail.data.recordId;
    }

    handleCustomLookupExpandSearch(event){
        window.console.log('in handleCustomLookupExpandSearch: ', JSON.stringify ( event.detail.data) );
        let data = event.detail.data;
        this.customLookupExpandedField = data.expandField;
    }

    sessionUpdateInProgress = false;
    handleSaveSession(event){
        event.preventDefault();
        const fields = event.detail.fields;
        window.console.log('fields: ', JSON.stringify(fields));
        this.template.querySelector('lightning-record-edit-form').submit(fields);
        this.sessionUpdateInProgress = true;
    }

    handleOnChangeSessionInfo(){
        this.sessionPendingUpdate = true;
    }

    handleSessionUpdateSuccess(){
        this.sessionPendingUpdate = false;
        this.sessionUpdateInProgress = false;
        this.toggleDropdown = false;
    }

    handleSessionUpdateError(event){
        const error = event.detail.detail;
        this.error = error;
    }

    handleCreateNewSession(){
        window.console.log('createNewSession');
        this.handleToggleDropdown();
    }

    handleCopySession(){
        window.console.log('copySession');
        this.handleToggleDropdown();
    }

    async handleReset() {
        await this.resetFields();
        this.sessionPendingUpdate = false;
        this.handleToggleDropdown();
    }

    resetFields(){
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }

    handleToggleDropdown(){
        this.toggleDropdown = !this.toggleDropdown;
    }

    // saveAnimalUpdates = false;
    // handleSaveSession(){
    //     window.console.log('handleSaveSession')
    //     this.saveAnimalUpdates = true;
    // }

    get customLookupLeaderDeviceSize(){
        if(FORM_FACTOR == 'Large'){
            return this.customLookupExpandedField ? '6' : '3';
        }
        if(FORM_FACTOR == 'Medium'){
            return this.customLookupExpandedField ? '12' : '6';
        }
    }

    get smallForm(){
        return this.formFactor == 'Small';
    }

    get currentDateTime(){
        if(!this.recordId){
            return (new Date().toISOString());
        }
    }

    get customLookupValueId(){
        if(this.sessionPlaygroupLeader){
            return this.sessionPlaygroupLeader;
        }
    }

    get dropdownIcon(){
        return this.toggleDropdown ? 'utility:chevrondown' : 'utility:chevronright';
    }

    get hasAnimalList(){
        return this.animals.length > 0;
    }

    get disableSaveButton(){
        return !this.sessionPendingUpdate;
    }

    get isSessionPendingUpdate(){
        return this.sessionPendingUpdate;
    }
}