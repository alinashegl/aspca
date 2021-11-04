import { LightningElement, api, track, wire } from 'lwc';
import addContact from '@salesforce/apex/playgroupSessionLWCController.addContact';
import removeContact from '@salesforce/apex/playgroupSessionLWCController.removeContact';

export default class PlaygroupSessionContacts extends LightningElement {
    @api sessionId;
    @api animals = [];
    @api contacts = [];
    customLookupNewId;

    showAnimalList = false;
    contactList = [];
    ranRenderedCallback = false;


    renderedCallback(){
        if(!this.ranRenderedCallback){
            window.console.log("session Contacts animals: ", JSON.stringify(this.animals));
            if(this.contacts.length > 0){
                this.contacts.forEach(contact => {
                    this.contactListPill.push({
                        label: contact.Contact__r.Name,
                        name: contact.Contact__c
                    });
                });
            }
            this.ranRenderedCallback = true;
        }
    }

    isDuplicateContact = false;

    customLookupEvent(event){
        window.console.log('handleLookup: ', JSON.stringify ( event.detail) );
        this.customLookupNewId = event.detail.data.recordId;
        this.showAnimalList = true;
        // this.contactList.push(event.detail.data.record.Name);
        this.tempContact = event.detail.data.record;
        if(this.contacts.find(cont => cont.Contact__c == this.tempContact.Id)){
            window.console.log('isDuplicateContact');
            this.isDuplicateContact = true;
        } else {
            window.console.log('is not DuplicateContact');
            this.isDuplicateContact = false;
        }
    }

    handleCustomLookupExpandSearch(event){
        window.console.log('in handleCustomLookupExpandSearch: ', JSON.stringify ( event.detail.data) );
        let data = event.detail.data;
        let dataId = data.elementId;
        this.template.querySelector('[data-id="' + dataId + '"]').className =
           data.expandField ? 'slds-col slds-size_1-of-1' : data.initialColSize;
    }

    @track contactListPill = [];

    tempContact;
    showContactLookup = true;
    customLookupClearSelection = true;
    error;

    handleAddContact(){
        window.console.log('addContact');
        addContact({sessionId: this.sessionId, contactId: this.tempContact.Id, animalIdsWithNovelContact: this.tempAnimalsWithNovelContact})
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
            }
        })
        .catch((error) => {
            console.error('error: ', error.statusText);
            console.error('error message: ', error.body.message);
            this.error = error;
        });
    }

    get disableSaveButton(){
        return tempContact == undefined ? true : false;
    }

    get showContactList(){
        return this.contactListPill.length > 0;
    }

    handleRemoveContact(event){
        const name = event.detail.item.name;
        this.contactListPill = this.contactListPill.filter(x => x.name !== name);
    }

    handleCancelAddContact(){
        window.console.log('handleCancelAddContact');
    }

    tempAnimalsWithNovelContact = [];

    handleToggleChange(event){
        let dataId = event.target.dataset.id;
        let value = event.target.checked;
        this.tempAnimalsWithNovelContact.push(dataId);

        window.console.log('handleToggleChange: ', dataId);
        window.console.log('value: ', value);

    }

    get customLookupFields(){
        return ['Name','Email','Phone'];
    }

    get customLookupDisplayFields(){
        return 'Name, Email, Phone';
    }

    get customLookupCreateNewFields(){
        return ['FirstName', 'LastName', 'Title', 'Department', 'Email'];
    }

    get showFirstContact(){
        return this.contactList[0];
    }

    get disableSaveContactButton(){
        return this.isDuplicateContact;
    }

    get addContactButtonLabel (){
        return this.isDuplicateContact ? 'Cannot add duplicate' : 'Add';
    }
}