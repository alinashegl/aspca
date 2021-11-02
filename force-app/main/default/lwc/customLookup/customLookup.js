import { LightningElement, api, wire } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor'
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
    @api elementId;
    @api initialColSize;
    @api createNewFields;
    @api allowCreateNew = false;

    formFactor = FORM_FACTOR;
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
    showCreateNew = false;
    showRecent = false;
    editRecord = false;
    showExpandedSearch = false;

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
        window.console.log('in connectedCallback');
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

    removeListener(){
        window.console.log('in removeListener');
        document.removeEventListener('click', this._handler);
    }

    handleQueryAll(){
        window.console.log('handle query all');
        this.showRecent = false;
        this.handleQuery();
    }

    handlePrevious() {
        this.offset = this.offset -1;
        this.handleQuery();
    }

    handleNext() {
        this.offset = this.offset +1;
        this.handleQuery();
    }

    handleAddNew(){
        window.console.log('handle add new');
        // document.addEventListener('click', this._handler = this.close.bind(this));
        this.showRecent = false;
        this.showExpandedSearch = false;
        this.showCreateNew = true;
        this.expandInput(true);
    }

    handleOnFocus(){
        window.console.log('in handleOnFocus');
        this.isLoading = true;
        if(this.isEditMode && !this.showRecent && !this.showExpandedSearch){
            this.editRecord = true;
            this.handleQueryRecentlyViewed();
        }
    }

    handleQueryRecentlyViewed(){
        window.console.log('in handleOnFocus');
        document.addEventListener('click', this._handler = this.close.bind(this));
        getRecentlyViewedRecords({type: this.objName, whereClause: this.whereClause})
        .then((result) =>{
            this.handleResponse(result);
        })
        .finally( ()=>{
            this.showRecent = true;
            this.isLoading = false;
        });
    }

    handleInputChange(event){
        window.console.log('in handleInputChange');
        window.clearTimeout(this.delayTimeout);
        this.clickCount = 0;
        this.offset = 0;
        this.searchKey = event.target.value;
        this.isLoading = true;
        this.delayTimeout = setTimeout(() => {
            if(this.searchKey.length >= 2 || this.searchKey.length == 0){
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
        // window.console.log('in handleResponse: ', JSON.stringify(result));
        let stringResult = JSON.stringify(result);
        let allResult    = JSON.parse(stringResult);
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
        // window.console.log('this.searchRecords: ', this.searchRecords);
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
        this.showRecent = false;
        this.showExpandedSearch = false;
        this.editRecord = false;
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

    handleNewRecordResponse(event){
        this.editRecord = false;
        this.showCreateNew = false;
        this.valueId = event.detail.id;
        window.console.log('handleNewRecordResponse: ', event.detail.id);
        this.clickCount = 0;
        this.expandInput(false);

        const selectedEvent = new CustomEvent('lookup', {
            detail: {  
                data : {
                    recordId        : event.detail.id,
                }
            }
        });
        this.dispatchEvent(selectedEvent);
    }

    expandInput(expand){
        const selectedEvent = new CustomEvent('expandfield', { 
            detail: {  
                data : {
                    expandField : expand,
                    initialColSize : this.initialColSize,
                    elementId : this.elementId
                }
            }
        });

        this.dispatchEvent(selectedEvent);
    }

    handleClose(event){
        event.stopPropagation();
        this.editRecord = true;
        this.searchRecords  = undefined;
        this.handleQueryRecentlyViewed();
    }

    handleToggleExpandSearch(){
        window.console.log('in handleExpandSearch');
        if(this.isEditMode){
            this.showExpandedSearch = !this.showExpandedSearch;
            this.showRecent = !this.showRecent;
            if(this.showExpandedSearch){
                this.handleQueryAll();
                this.expandInput(true);
            } else {
                this.searchKey = '';
                this.handleQueryRecentlyViewed();
                this.expandInput(false);
            }
        }
    }

    handleInputIconClick(){
        window.console.log('in handleIconClick');
        this.isLoading = true;
        if(this.selectedRecord == undefined && !this.editRecord){
            this.editRecord = true;
            this.handleQueryRecentlyViewed();
        }
        else{
            if(!this.isEditMode || this.showCreateNew){
                this.showCreateNew = false;
                this.editRecord = true;
                this.expandInput(false);
                this.handleQueryRecentlyViewed();
            } else {
                this.handleToggleExpandSearch();
            }
        }
    }

    titleCase(string) {
        var sentence = string.toLowerCase().split(" ");
        for(var i = 0; i< sentence.length; i++){
            sentence[i] = sentence[i][0].toUpperCase() + sentence[i].slice(1);
        }
        return sentence;
    }

    close() { 
        window.console.log('in close');
        this.showRecent = false;
        this.showExpandedSearch = false;
        this.editRecord = false;
        this.showCreateNew = false;
        this.expandInput(false);
        this.removeListener();
    }
    
    handleModalIconClick(){
        this.clickCount = this.clickCount == 3 ? 0 : this.clickCount + 1; 
    }

    get inputValue(){
        return this.isReadOnlyMode ? this.selectedRecord.FIELD1 : this.searchKey;
    }

    get isEditMode(){
        return this.editRecord || this.selectedRecord == undefined;
    }

    get isReadOnlyMode(){
        return this.selectedRecord && !this.editRecord;
    }

    get isInputDisabled(){
        return this.isReadOnlyMode || this.showCreateNew;
    }

    get showRecentRecords(){
        return this.showRecent;
    }

    get modalTitle(){
        return this.showCreateNew ? 'Create New ' + this.labelName : 'Search for ' + this.labelName;
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
        return this.isLoading ? 'utility:spinner' : 
                this.selectedRecord == undefined && !this.editRecord ? 'utility:search' :
                    !this.isEditMode || this.showCreateNew ? 'utility:close' :
                        this.showExpandedSearch ? 'utility:contract_alt' : 'utility:expand_alt';
    }

    get searchBarIconTitle(){
        return this.isLoading ? 'Loading' : 
            this.showCreateNew ? 'Cancel' :
                this.selectedRecord == undefined && !this.editRecord ? 'Search' :
                !this.isEditMode ? 'Remove Selection' :
                    this.showExpandedSearch ? 'Contract' : 'Expand';
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

    get showSearchResults(){
        return this.showRecent || this.showExpandedSearch || this.showCreateNew;
    }

    handleDivClick(event){
        window.console.log('in handleDivClick')
        event.stopPropagation();
    }

    // count = 0;

    // get showRecent1 (){
    //     return this.count == 1;
    // }

    // get showExpandedSearch1 (){
    //     return this.count == 2;
    // }

    // get showCreateNew1 (){
    //     return this.count == 3;
    // }

    get gridSize(){
        if(this.showCreateNew || FORM_FACTOR == 'Small' || (FORM_FACTOR == 'Medium' && this.showExpandedSearch)){
            return 'slds-col slds-size_1-of-1';
        } else {
            if(FORM_FACTOR == 'Medium'){
                return 'slds-col slds-size_1-of-2';
            }
            else {
                return 'slds-col slds-size_1-of-3';
            }
        }
    }

    get inputFieldClass(){
        return this.editRecord ? 'slds-input slds-combobox__input slds-combobox__input-value slds-has-focus' : 'slds-input slds-combobox__input slds-combobox__input-value';
    }


    // handleComboboxIconClick(){
    //     this.template
    //     .querySelector('.accounts_list')
    //     .classList.remove('slds-hide');
    //     this.template
    //     .querySelector('.slds-searchIcon')
    //     .classList.add('slds-hide');
    //     this.template
    //     .querySelector('.slds-icon-utility-down')
    //     .classList.remove('slds-hide');
    //     this.template
    //     .querySelector('.slds-dropdown-trigger')
    //     .classList.add('slds-is-open');
    // }

}