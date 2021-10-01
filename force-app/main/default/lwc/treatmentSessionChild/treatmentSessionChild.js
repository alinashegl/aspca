import { LightningElement, api } from 'lwc';

export default class TreatmentSessionChild extends LightningElement {
    @api record;
    @api objectApi;
    @api protocolId;

    hasChanged = false;

    connectedCallback(){
        window.console.log('objectApi = ', this.objectApi);
    }

    handleSuccess(){
        window.console.log('successfully updated');
        this.hasChanged = false;
        if(this.record == undefined){
            this.updateList();
        }
    }

    handleSubmit(event){
        event.preventDefault(); 
        this.handleRemoveRecord();
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

    get isContactList(){
        return this.objectApi === 'Session_Protocol_Contact__c' ? true : false;
    }

    get buttonStatus(){
        return !this.hasChanged;
    }

    get saveButtonVariant(){
        return this.hasChanged ? 'brand' : 'border-filled';
    }

    get addNewLabel(){
        return this.isContactList ? 'Save New Contact' : 'Save New Dog';
    }

    get parentFieldName(){
        return this.isContactList ? 'Contact__c' : 'Additional_Dog__c';
    }

}