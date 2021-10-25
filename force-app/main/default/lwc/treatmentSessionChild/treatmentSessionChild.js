import { RecordFieldDataType } from 'lightning/uiRecordApi';
import { LightningElement, api, wire } from 'lwc';

export default class TreatmentSessionChild extends LightningElement {
    @api record;
    @api objectApi;
    @api protocolId;
    customLookupNewId;
    isLoading = false;

    hasChanged = false;

    connectedCallback(){
        if(this.record){
            this.customLookupNewId = (this.isContactList) ? this.record.Contact__c : this.record.Additional_Dog__c;
        }
    }

    handleSuccess(event){
        window.console.log('successfully updated: ', event.detail.id);
        this.hasChanged = false;
        if(this.record == undefined){
            this.updateList();
        }
        this.isLoading = false;
    }

    handleUpdateRecordSubmit(){
        this.isLoading = true;
    }

    handleNewRecordSubmit(event){
        this.isLoading = true;
        event.preventDefault(); 
        const fields = event.detail.fields;
        if(this.isContactList){
            fields['Contact__c'] = this.customLookupNewId;
        } else {
            fields['Additional_Dog__c'] = this.customLookupNewId
        }

        fields['Session_Protocol__c'] = this.protocolId;
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleRemoveRecord(){
        window.console.log('in handleRemoveRecord')
        let eventDetails = {id:this.record.Id};
        const event = new CustomEvent('deletechild', {
            detail: eventDetails
        });
        this.dispatchEvent(event);
    }

    updateList(){
        const event = new CustomEvent('refreshlist', {});
        this.dispatchEvent(event);
    }

    enableSaveButton(){
        this.hasChanged = true;
    }

    cancelAddNew(){
        this.updateList();
    }

    handleLookup(event){
        window.console.log('handleLookup: ', JSON.stringify ( event.detail) );
        this.customLookupNewId = event.detail.data.recordId;
        // this.lookupIdChanged = this.customLookupNewId != this.record.Id;
    }

    get isContactList(){
        return this.objectApi === 'Session_Protocol_Contact__c' ? true : false;
    }

    get disableSaveButton(){
        return !this.hasChanged;
    }

    get saveButtonIcon(){
        return this.isLoading ? 'utility:spinner' : "action:approval";
    }

    get saveButtonVariant(){
        return this.disableSaveButton ? 'border-filled' : 'border';
    }

    get addNewLabel(){
        return this.isContactList ? 'Save New Contact' : 'Save New Dog';
    }

    get parentFieldName(){
        return this.isContactList ? 'Contact__c' : 'Additional_Dog__c';
    }

    get customLookUpObject(){
        return this.isContactList ? 'Contact' : 'Animal__c';
    }

    get customLookupFields(){
        return this.isContactList ? ['Name','Email','Phone'] : ['Animal_Name__c', 'Name'];
    }

    get customLookupDisplayFields(){
        return this.isContactList ? 'Name, Email, Phone' : 'Animal_Name__c, Name';
    }

    get customLookupPlaceholder(){
        return this.isContactList ? 'Search Contacts...' : 'Search Dogs...';
    }

    get customLookupIcon(){
        return this.isContactList ? 'standard:contact' : 'custom:custom47';
    }

    get customLookupWhereClause(){
        if(!this.isContactList){
            return 'Potential_Helper_Dog__c = true AND ';
        }
    }

    get customLookupFeidlToQuery(){
        return this.isContactList ? 'Name' : 'Animal_Name__c';
    }
    get customLookupLabelName(){
        return this.isContactList ? 'Protocol Contact' : 'Helper Dog';
    }
}