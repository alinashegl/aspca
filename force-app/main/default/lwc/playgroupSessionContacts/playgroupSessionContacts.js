import { LightningElement, api, track, wire } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor'
import addContact from '@salesforce/apex/playgroupSessionLWCController.addContact';
import removeContact from '@salesforce/apex/playgroupSessionLWCController.removeContact';

export default class PlaygroupSessionContacts extends LightningElement {
    @api animals = [];

    _sessionId;
    @api
    get sessionId() {
        return this._sessionId;
    }
    set sessionId(value) {
        this._sessionId = value;
    }

    _contacts;
    @api
    get contacts() {
        return this._contacts;
    }
    set contacts(value) {
        this._contacts = value;
        this.contactListPill = [];
        if(this.contacts.length > 0){
            this.contacts.forEach(contact => {
                this.contactListPill.push({
                    label: contact.Name,
                    name: contact.Id
                });
            });
        }
    }

    @track contactListPill = [];

    customLookupNewId;
    customLookupClearSelection = true;
    showAnimalList = false;
    contactList = [];
    modalClass = FORM_FACTOR == 'Small' ? 'slds-fade-in-open' : 'slds-modal slds-fade-in-open';
    tempAnimalsWithNovelContact = [];
    tempContact;
    isDuplicateContact = false;
    confirmDelete = false;
    contactToRemove;
    error;
    showSpinner = false;

    customLookupEvent(event){
        this.customLookupNewId = event.detail.data.recordId;
        this.showAnimalList = true;
        this.tempContact = event.detail.data.record;
        if(this.contactListPill.find(cont => cont.name == this.customLookupNewId)){
            this.isDuplicateContact = true;
        } else {
            this.isDuplicateContact = false;
        }
    }

    handleCustomLookupExpandSearch(event){
        let data = event.detail.data;
        let dataId = data.elementId;
        this.template.querySelector('[data-id="' + dataId + '"]').className =
            data.expandField ? 'slds-col slds-size_1-of-1' : data.initialColSize;
    }

    handleAddContact(){
        this.showSpinner = true;
        addContact({sessionId: this.sessionId, contactId: this.customLookupNewId, animalIdsWithNovelContact: this.tempAnimalsWithNovelContact})
        .then ((result) =>{
            if(result){
                this.contactListPill.push({
                    label: this.tempContact.Name,
                    name: this.tempContact.Id
                });

                this.tempAnimalsWithNovelContact = [];
                this.tempContact = undefined;
                this.showAnimalList = false;
                this.customLookupClearSelection = !this.customLookupClearSelection;
                this.dispatchContactEvent();
            }
        })
        .catch((error) => {
            this.error = error;
        })
        .finally(() => {
            this.showSpinner = false;
        });
    }

    handleRemoveContact(event){
        this.contactToRemove = event.detail.item;
        this.confirmDelete = true;
    }

    handleDeleteContact(){
        this.showSpinner = true;
        removeContact({sessionId: this.sessionId, contactId: this.contactToRemove.name})
        .then((result) => {
            if(result){
                this.contactListPill = this.contactListPill.filter(x => x.name !== this.contactToRemove.name);
                this.confirmDelete = false;
                this.dispatchContactEvent();
            }
        })
        .catch((error) => {
            this.error = error;
        })
        .finally(() => {
            this.showSpinner = false;
        });
    }

    handleCloseModal (){
        this.confirmDelete = false;
    }

    handleCancelAddContact(){
        this.tempAnimalsWithNovelContact = [];
        this.tempContact = undefined;
        this.showAnimalList = false;
        this.customLookupClearSelection = !this.customLookupClearSelection;
        this.isDuplicateContact = false;
    }

    handleToggleChange(event){
        let dataId = event.target.dataset.id;
        let value = event.target.checked;
        this.tempAnimalsWithNovelContact.push(dataId);
    }

    dispatchContactEvent(){
        const selectedEvent = new CustomEvent('contactevent', {});
        this.dispatchEvent(selectedEvent);
    }

    get customLookupFields(){
        return ['Name','Email','Phone'];
    }

    get customLookupDisplayFields(){
        return 'Name, Email, Phone';
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

    get disableSaveContactButton(){
        return this.isDuplicateContact;
    }

    get addContactButtonLabel (){
        return this.isDuplicateContact ? 'Duplicate Contact' : 'Add';
    }

    get isLargeFormFactor(){
        return FORM_FACTOR != 'Small';
    }

    get deleteButtonLabel(){
        return FORM_FACTOR == 'Small' ? 'Delete' : 'Delete Contact';
    }

    get showAnimalToggle(){
        return this.showAnimalList && !this.isDuplicateContact;
    }

    get showContactList(){
        return this.contactListPill.length > 0;
    }
}