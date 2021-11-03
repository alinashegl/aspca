import ForecastEnabled from '@salesforce/schema/User.ForecastEnabled';
import { LightningElement, api } from 'lwc';

export default class PlaygroupSessionContacts extends LightningElement {
    @api sessionId;
    customLookupNewId;

    showDogList = false;
    contactList = [];

    dogList =[
        {Id: 'Santa\'s Little Helper', Name: 'Santa\'s Little Helper'},
        {Id: 'Eddie', Name: 'Eddie'},
        {Id: 'Mika', Name: 'Mika'},
        {Id: 'AJ', Name: 'AJ'}
    ];

    customLookupEvent(event){
        window.console.log('handleLookup: ', JSON.stringify ( event.detail) );
        this.customLookupNewId = event.detail.data.recordId;
        this.showDogList = true;
        this.contactList.push(event.detail.data.record.Name);
    }

    handleCustomLookupExpandSearch(event){
        window.console.log('in handleCustomLookupExpandSearch: ', JSON.stringify ( event.detail.data) );
        let data = event.detail.data;
        let dataId = data.elementId;
        this.template.querySelector('[data-id="' + dataId + '"]').className =
           data.expandField ? 'slds-col slds-size_1-of-1' : data.initialColSize;
    }

    handleAddContact(){
        window.console.log('addContact');

    }

    handleCancelAddContact(){
        window.console.log('handleCancelAddContact');
    }

    handleToggleChange(event){
        let dataId = event.target.dataset.id;
        let value = event.target.checked;
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
}