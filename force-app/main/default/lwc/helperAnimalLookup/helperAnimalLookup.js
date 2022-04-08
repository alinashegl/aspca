import { LightningElement, api } from 'lwc';

export default class HelperAnimalLookup extends LightningElement {
    @api helperAnimal;

    customLookupNewId;
    lookupIdChanged = false;

    get customLookupFields(){
        return ['Animal_Name_Id__c', 'Name'];
    }

    get customLookupDisplayFields(){
        return 'Animal_Name_Id__c, Name';
    }

    get customLookupFieldToQuery(){
        return 'Animal_Name_Id__c';
    }

    location = 'MRC';
    get customLookupWhereClause(){
        return ' Current_Recent_Shelter_Location__c = \'' + this.location + '\'';
    }

    get customLookupLabelName(){
        return 'Helper Dog';
    }

    handleCustomLookupExpandSearch(event){
        let data = event.detail.data;
        let dataId = data.elementId;
        this.template.querySelector('[data-id="' + dataId + '"]').className =
           data.expandField ? 'slds-col slds-size_1-of-1' : data.initialColSize;
    }

    customLookupEvent(event){
        this.customLookupNewId = event.detail.data.recordId;
        //need to come back to this
        this.lookupIdChanged = !this.record || (this.customLookupNewId != this.record.Id);
    }
}