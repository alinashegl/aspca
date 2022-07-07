import { LightningElement, api, wire } from 'lwc';

export default class TreatmentSessionChild extends LightningElement {
    @api record;
    @api objectApi;
    @api protocolId;

    customLookupNewId;
    isLoading = false;

    lookupIdChanged = false;
    fieldChanged = false;

    connectedCallback(){
        if(this.record){
            this.customLookupNewId = (this.isContactList) ? this.record.Contact__c : this.record.Additional_Dog__c;
        }
    }

    handleSuccess(event){
        this.lookupIdChanged = false;
        this.fieldChanged = false;
        if(this.record == undefined){
            this.updateList();
        }
        this.isLoading = false;
    }

    handleUpdateRecordSubmit(event){
        this.isLoading = true;
        event.preventDefault(); 
        const fields = event.detail.fields;
        if(this.isContactList){
            fields['Contact__c'] = this.customLookupNewId;
        } else {
            fields['Additional_Dog__c'] = this.customLookupNewId
        }
        this.template.querySelector('lightning-record-edit-form').submit(fields);
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
        this.hasChanged;
    }

    cancelAddNew(){
        this.updateList();
    }

    customLookupEvent(event){
        this.customLookupNewId = event.detail.data.recordId;
        this.lookupIdChanged = !this.record || (this.customLookupNewId != this.record.Id);
    }

    handleCustomLookupExpandSearch(event){
        let data = event.detail.data;
        let dataId = data.elementId;
        this.template.querySelector('[data-id="' + dataId + '"]').className =
           data.expandField ? 'slds-col slds-size_1-of-1' : data.initialColSize;
    }

    handlePotentialHelperClick(){
        this.showPotentialHelperDogs = !this.showPotentialHelperDogs;
    }

    handleConfirmedHelperClick(){
        this.showConfirmedHelperDogs = !this.showConfirmedHelperDogs;
    }

    get potentialHelperDogButtonVariant(){
        return this.showPotentialHelperDogs ? 'brand' : 'neutral';
    }

    get potentialConfirmedDogButtonVariant(){
        return this.showConfirmedHelperDogs ? 'brand' : 'neutral';
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

    get customLookUpObjectIsAnimal(){
        return this.customLookUpObject == 'Animal__c';
    }

    get customLookupFields(){
        return this.isContactList ? ['Name','Email','Phone'] : ['Animal_Name__c', 'Name'];
    }

    get customLookupDisplayFields(){
        return this.isContactList ? 'Name, Email, Phone' : 'Animal_Name__c, Name';
    }

    get customLookupCreateNewFields(){
        return this.isContactList ? [
            {fieldAPI: 'FirstName', fieldLabel: 'First Name', required: true},
            {fieldAPI: 'LastName', fieldLabel: 'Last Name', required: true},
            {fieldAPI: 'Title', required: false},
            {fieldAPI: 'Department', required: false},
            {fieldAPI: 'Email', required: false}
        ] : undefined;
    }

    get customLookupPlaceholder(){
        return this.isContactList ? 'Search Contacts...' : 'Search Dogs...';
    }

    get customLookupIcon(){
        return this.isContactList ? 'standard:contact' : 'custom:custom47';
    }

    get customLookupFieldToQuery(){
        return this.isContactList ? 'Name' : 'Animal_Name__c';
    }

    get customLookupLabelName(){
        return this.isContactList ? 'Protocol Contact' : 'Helper Dog';
    }

    showPotentialHelperDogs = true;
    showConfirmedHelperDogs = true;

    get customLookupWhereClause(){
        if(!this.isContactList){
            let whereClause = ' Location_Filter__c = true AND Active_Animal__c = true ';
            if(this.showPotentialHelperDogs && this.showConfirmedHelperDogs){
                whereClause += 'AND (Confirmed_Helper_Dog__c = true OR Potential_Helper_Dog__c = true) ';
            } 
            else if(this.showPotentialHelperDogs){
                whereClause += 'AND Potential_Helper_Dog__c = true ';
            } else if(this.showConfirmedHelperDogs){
                whereClause += 'AND Confirmed_Helper_Dog__c = true ';
            }
            return whereClause;          
        }
    }

    get hasChanged(){
        return this.lookupIdChanged || this.fieldChanged;
    }

    get customLookupAllowCreateNew(){
        return this.isContactList ? true : false;
    }
}