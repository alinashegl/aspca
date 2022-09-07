import { LightningElement, api, wire } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor'
import { NavigationMixin } from "lightning/navigation";
import { refreshApex } from '@salesforce/apex';
import getPlaygroupSessionInfo from '@salesforce/apex/playgroupSessionLWCController.getPlaygroupSessionInfo';

export default class PlaygroupSessionMain extends NavigationMixin(LightningElement) {
    @api recordId;
    wireResponse;
    showSpinner = true;
    animals = [];
    playgroupContacts = [];

    toggleDropdown = false;
    showToDoList = false;
    refresh = false;

    //variables to pass to ToDoList
    toDoListAction;

    //customLookup variables
    customLookupFields = ["Name","Email","Title"];
    customLookupDisplayFields = 'Name, Email, Title';
    customLookupExpandedField = false;

    session;
    sessionPlaygroupLeader;
    sessionPendingUpdate = false;
    sessionUpdateInProgress = false;
    sessionInfoError;
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
        } else if(result.error){
            this.sessionInfoError = result.error;
            this.showSpinner = false;
        }
    }

    customLookupEvent(event){
        this.sessionPlaygroupLeader = event.detail.data.recordId;
        this.sessionPendingUpdate = true;
    }

    handleCustomLookupExpandSearch(event){
        let data = event.detail.data;
        this.customLookupExpandedField = data.expandField;
    }

    handleSaveSession(event){
        event.preventDefault();
        const fields = event.detail.fields;
        fields['Playgroup_Leader__c'] = this.sessionPlaygroupLeader;
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

    handleEditSession(){
        this.toDoListAction = 'edit';
        this.showToDoList = true;
        this.handleToggleDropdown();
    }

    handleCreateNewSession(){
        this.toDoListAction = 'new';
        this.showToDoList = true;
        this.handleToggleDropdown();
    }

    handleCopySession(){
        this.toDoListAction = 'copy';
        this.showToDoList = true;
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

    handleCopyEvent(event){
        this.showToDoList = false;
        if(event.detail.id){
            this.playgroupContacts = [];
            this.sessionPlaygroupLeader = undefined;
            this.recordId = event.detail.id;
            refreshApex(this.wireResponse);
        }
        else{
            this.sessionInfoError = event.detail.error;
        }
    }

    handleEditEvent(event){
        this.showToDoList = false;
        if(event.detail.id){
            refreshApex(this.wireResponse);
        }
        else if(event.detail.error){
            this.sessionInfoError = event.detail.error;
        }
    }

    handleCloseToDoList(){
        this.showToDoList = false;
    }

    handleNavigateToSession(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.session.Id,
                objectApiName: 'Playgroup_Session__c',
                actionName: 'view'
            }
        });
        refreshApex(this.wireResponse);
    }

    handleAnimalRemovedEvent(){
        refreshApex(this.wireResponse);
    }

    handleContactEvent(){
        this.refresh = !this.refresh;
    }

    get customLookupLeaderDeviceSize(){
        if(FORM_FACTOR == 'Large'){
            return this.customLookupExpandedField ? '6' : '3';
        }
        if(FORM_FACTOR == 'Medium'){
            return this.customLookupExpandedField ? '12' : '6';
        }
    }

    get smallForm(){
        return FORM_FACTOR == 'Small';
    }

    get customLookupValueId(){
        if(this.sessionPlaygroupLeader){
            return this.sessionPlaygroupLeader;
        }
    }

    get dropdownIcon(){
        return this.sessionPendingUpdate ? 'utility:save' : this.toggleDropdown ? 'utility:chevrondown' : 'utility:chevronright';
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
    
    get sessionButtonLabel(){
        return 'Playgroup: ' + this.session.Name;
    }

    get createNewSessionButtonLabel(){
        return 'Create New PG';
    }
    
    get copySessionButtonLabel(){
        return 'Copy Dogs to Next PG';
    }

    get editAnimalsButtonLabel(){
        return '+/- Current PG Dogs';
    }

    get editAnimalsHelpText(){
        return 'Return to PG To Do List to modify dogs in this playgroup';
    }

    get copySessionHelpText(){
        return 'Copy dogs from current playgroup and return to PG To Do List to edit next playgroup; Play Notes will be transferred for dogs remaining in playgroup';
    }

    get createNewSessionHelpText(){
        return 'Start new playgroup from scratch';
    }

    get toDoListSessionId(){
        return this.toDoListAction === 'new' ? undefined : this.session.Id;
    }

    get toDoListAnimalIds(){
        if(this.toDoListAction === 'new'){
            return undefined;
        } else {
            let animalIds = [];
            this.animals.forEach(animal => {
                animalIds.push(animal.Animal__c);
            });
            return animalIds;
        }
    }

    get customLookupCreateNewFields(){
        return [
            {fieldAPI: 'FirstName', fieldLabel: 'First Name', required: true},
            {fieldAPI: 'LastName', fieldLabel: 'Last Name', required: true},
            {fieldAPI: 'Title', required: false},
            {fieldAPI: 'Department', required: false},
            {fieldAPI: 'Email', required: false}
        ];
    }
}