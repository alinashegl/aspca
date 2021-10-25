import { LightningElement, api, wire } from 'lwc';
import getRecentlyViewedRecords from '@salesforce/apex/CustomLookupLWCController.getRecentlyViewedRecords';
import getCurrentRecord from '@salesforce/apex/CustomLookupLWCController.getCurrentRecord';
import search from '@salesforce/apex/CustomLookupLWCController.search';

const DELAY = 200;

export default class CustomLookup extends LightningElement {

    @api valueId;
    @api valueName;
    @api objName = 'Account';
    @api iconName = 'standard:account';
    @api labelName;
    @api readOnly = false;
    @api currentRecordId;
    @api placeholder = 'Search';
    @api createRecord;
    @api fields = ['Name'];
    @api displayFields = 'Name, Rating, AccountNumber';
    @api whereClause;
    @api fieldToQuery = 'Name';

    error;

    searchKey = '';
    delayTimeout;
    pageCount = 0;
    clickCount = 0;
    offset = 0;

    searchRecords;
    selectedRecord;
    objectLabel;
    isLoading = false;
    showModal = false;
    showCreateRecord = false;
    showTable = false;

    field;
    field1;
    field2;

    @wire(getCurrentRecord, {objectName: '$objName', recordId: '$valueId', fields: '$fields'})
    response(result){
        window.console.log('lookup result: ', JSON.stringify(result));
        if(result.data){
            this.currentRecordResponse(result.data);
        }
    }

    connectedCallback(){
        document.addEventListener('click', this._handler = this.close.bind(this));

        // if(this.objName.includes('__c')){
        //     let obj = this.objName.substring(0, this.objName.length-3);
        //     this.objectLabel = obj.replaceAll('_',' ');
        // }else{
        //     this.objectLabel = this.objName;
        // }
        // this.objectLabel    = this.titleCase(this.objectLabel);
        let fieldList;
        if( !Array.isArray(this.displayFields)){
            fieldList       = this.displayFields.split(',');
        }else{
            fieldList       = this.displayFields;
        }
        
        if(fieldList.length > 1){
            this.field = fieldList[0].trim();
            this.field1 = fieldList[1].trim();
        }
        if(fieldList.length > 2){
            this.field2 = fieldList[2].trim();
        }
        let combinedFields = [];
        fieldList.forEach(field => {
            if( !this.fields.includes(field.trim()) ){
                combinedFields.push( field.trim() );
            }
        });

        this.fields = combinedFields.concat( JSON.parse(JSON.stringify(this.fields)) );
    }    

    disconnectedCallback() {
        document.removeEventListener('click', this._handler);
    }

    handleQueryAll(){
        window.console.log('handle query all');
        this.showTable = false;
        this.showModal = true;
        this.searchAllRecords();
    }

    searchAllRecords(){
        this.handleQuery();
    }

    handlePrevious() {
        this.offset = this.offset -1;
        this.searchAllRecords();

    }

    handleNext() {
        this.offset = this.offset +1;
        this.searchAllRecords();
    }

    handleAddNew(){
        window.console.log('handle add new');
        this.showTable = false;
        this.showModal = true;
        this.showCreateRecord = true;
    }

    handleOnFocus(){
        getRecentlyViewedRecords({type: this.objName, whereClause: this.whereClause})
        .then((result) =>{
            this.handleResponse(result);
            this.showSpinner = false;
            this.showTable = true;
        });    
    }

    handleInputChange(event){
        window.clearTimeout(this.delayTimeout);
        this.clickCount = 0;
        this.offset = 0;
        this.searchKey = event.target.value;
        this.isLoading = true;
        this.delayTimeout = setTimeout(() => {
            if(this.searchKey.length >= 2){
                this.handleQuery();
            }
        }, DELAY);
    }

    handleQuery(){
        search({ 
            objectName : this.objName,
            fields     : this.fields,
            searchTerm : this.searchKey,
            offset: this.offset,
            whereClause: this.whereClause,
            fieldToQuery: this.fieldToQuery
        })
        .then(result => {
            this.pageCount = result.pageCount;
            this.handleResponse(result.recordList);
            
        })
        .catch(error => {
            console.error('Error:', error);
        })
        .finally( ()=>{
            this.isLoading = false;
        });
    }

    handleResponse(result){
        let stringResult = JSON.stringify(result);
        let allResult    = JSON.parse(stringResult);
        window.console.log('this.field: ', this.field);
        window.console.log('this.field1: ', this.field1);
        allResult.forEach( record => {
            record.FIELD1 = record[this.field];
            record.FIELD2 = record[this.field1];
            if( this.field2 ){
                record.FIELD3 = record[this.field2];
            }else{
                record.FIELD3 = '';
            }
        });
        this.searchRecords = allResult;
        window.console.log('searchRecords: ');
        window.console.table(this.searchRecords);
    }

    currentRecordResponse(result){
        this.currentRecordId = result.Id;
        let returnedRecord = result;
        let record = {
            FIELD1 : returnedRecord[this.field],
            FIELD2 : returnedRecord[this.field1]
        }
        if( this.field2 ){
            record.FIELD3 = [this.field2];
        }else{
            record.FIELD3 = '';
        }

        this.selectedRecord = record;
    }

    handleSelect(event){
        window.console.log('handle Select');
        this.showModal = false;
        this.clickCount = 0;
        
        let recordId = event.currentTarget.dataset.recordId;
        
        let selectRecord = this.searchRecords.find((item) => {
            return item.Id === recordId;
        });
        this.selectedRecord = selectRecord;
        
        const selectedEvent = new CustomEvent('lookup', {
            detail: {  
                data : {
                    record          : selectRecord,
                    recordId        : recordId,
                    currentRecordId : this.currentRecordId
                }
            }
        });
        this.dispatchEvent(selectedEvent);
    }

    handleClose(){
        this.selectedRecord = undefined;
        this.searchRecords  = undefined;
        this.handleOnFocus();
    }

    titleCase(string) {
        var sentence = string.toLowerCase().split(" ");
        for(var i = 0; i< sentence.length; i++){
            sentence[i] = sentence[i][0].toUpperCase() + sentence[i].slice(1);
        }
        return sentence;
    }

    handleCancel(){
        this.showModal = false;
        this.showCreateRecord = false;
        this.clickCount = 0;
    }

    handleNewRecordResponse(event){
        this.valueId = event.detail.id;
        window.console.log('handleNewRecordResponse: ', event.detail.id);
        this.showModal = false;
        this.clickCount = 0;
    }

    handleClick(event) {
        event.stopPropagation();
        return false;
    }
    close() { 
        console.log('we should close now');
        this.showTable = false;
    }
    
    handleModalIconClick(){
        this.clickCount = this.clickCount == 3 ? 0 : this.clickCount + 1; 
    }

    get showSearchRecords(){
        return this.showTable;
    }

    get modalTitle(){
        return this.showCreateRecord ? 'Create New ' + this.labelName : 'Search for ' + this.labelName;
    }

    get disablePreviousButton(){
        return this.offset == 0;
    }

    get disableNextButton(){
        return this.searchRecords && this.searchRecords.length < 25 ? true : false;
    }

    get pageNumber(){
        return this.offset + 1;
    }

    get searchBarIcon(){
        return this.isLoading ? 'utility:spinner' : 'utility:search';
    }

    get searchIcon(){
        return 'utility:search';
    }

    get addNewIcon(){
        return 'utility:new';
    }

    get imageClass(){
        return this.clickCount > 2 ? 'background_img' : '';
    }

}