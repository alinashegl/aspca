import { LightningElement, api, wire } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor'
import getRecentlyViewedRecords from '@salesforce/apex/CustomLookupLWCController.getRecentlyViewedRecords';
import getCurrentRecord from '@salesforce/apex/CustomLookupLWCController.getCurrentRecord';
import search from '@salesforce/apex/CustomLookupLWCController.search';
import UserPreferencesExcludeMailAppAttachments from '@salesforce/schema/User.UserPreferencesExcludeMailAppAttachments';

const DELAY = 200;

export default class CustomLookup extends LightningElement {
    //potential params from parent component

    //If the lookup field is already populated, this is the id of that record
    @api valueId;

    //The object api name of the lookup object - default is Account
    @api objName = 'Account';

    //Icon to appear next the list of options - default is standard:account
    @api iconName = 'standard:account';

    //The label for the lookup field
    @api labelName;

    //Placeholder to show when the field is null
    @api placeholder = 'Search';

    //If lookup field is already populated we need to query it to show the correct information, this is the list of fields to return in that query
    @api fields = ['Name'];

    //List of fields to display as columns in the search results (1st field by default, other fields only show in expanded view) max of 3 fields
    @api displayFields = 'Name, Rating, AccountNumber';

    //If the query needs to be filtered, included that here
    @api whereClause;

    //API name of the field that is used to filter th query when the user types in the lookup field.
    @api fieldToQuery = 'Name';

    //If the component is resizable, this is the Id of the element that holds the component on the parent component, so the 
    //template.querySelector can find the right compoenent and change the class to resize it
    @api elementId;

    //Used along with the elementId, to set the componenet back to it's original size
    @api initialColSize;

    //Show the option to create new record or not
    @api allowCreateNew = false;

    //JSON string of fields to show on the create new form and which ones are required (example is below)
    @api createNewFieldsWithRequired;

    //if read only, do not allow edits
    @api readOnly = false;

    //Boolean that whenever changed will reset the lookupfield to null and clear out the search terms
    _clearSelection;
    @api
    get clearSelection() {
        return this._clearSelection;
    }
    set clearSelection(value) {
        this._clearSelection = value;
        this.selectedRecord = undefined;
        this.searchKey = '';
        this.editRecord = true;
    }

    formFactor = FORM_FACTOR;
    errors;

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

    //if the recordId exists we need to get the record to display the correct information
    @wire(getCurrentRecord, {objectName: '$objName', recordId: '$valueId', fields: '$fields'})
    response(result){
        if(result.data){
            this.currentRecordResponse(result.data);
        }
    }

    //need to prep the field information to display correctly
    connectedCallback(){
        let fieldList;
        if( !Array.isArray(this.displayFields)){
            fieldList       = this.displayFields.split(',');
        }else{
            fieldList       = this.displayFields;
        }
        
        if(fieldList.length == 1) {
            this.field = fieldList[0].trim();
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

    //set the field values based on the response from querying the record
    currentRecordResponse(result){
        // this.currentRecordId = result.Id;
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

    //remove the 'click' listener since the drop down is no longer open
    removeListener(){
        document.removeEventListener('click', this._handler);
    }

    //if user clicks inside the dropdown or the input field, do not close the dropdown
    handleDivClick(event){
        event.stopPropagation();
    }

    //update the list of records
    handlePrevious() {
        this.offset = this.offset -1;
        this.handleQuery();
    }

    //update the list of records
    handleNext() {
        this.offset = this.offset +1;
        this.handleQuery();
    }

    //show the create new record page
    handleAddNew(){
        this.showRecent = false;
        this.showExpandedSearch = false;
        this.showCreateNew = true;
        this.expandInput(true);
    }

    //when user clicks into the text box, need to open the dropdown and query the recently viewed records
    handleOnFocus(){
        if(!this.readOnly){
            this.isLoading = true;
            if(this.isEditMode && !this.showRecent && !this.showExpandedSearch){
                this.editRecord = true;
                this.handleQueryRecentlyViewed();
            }
        }
    }

    //query for the recently viewed records
    handleQueryRecentlyViewed(){
        //the click event listener is triggered on each click, if the clicks outside of specific areas the dropdown closes
        document.addEventListener('click', this._handler = this.close.bind(this));
        getRecentlyViewedRecords({objectAPI: this.objName, whereClause: this.whereClause})
        .then((result) =>{
            if(result && result.length > 0){
                this.handleResponse(result);
            } else {
                this.delayTimeout = setTimeout(() => {
                    this.handleQuery();
                }, DELAY);
            }
        })
        .finally( ()=>{
            this.showRecent = true;
            this.isLoading = false;
        });
    }

    //When user is typing in the text box, update the query
    handleInputChange(event){
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

    //calls the apex method to query the records
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

    //takes the respone from the queried records and preps the data to display correctly to the user
    handleResponse(result){
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
    }

    //When a record is selected from the dopdown, set it as the selected record, and close the dropdown
    handleSelect(event){
        this.showRecent = false;
        this.showExpandedSearch = false;
        this.editRecord = false;
        this.clickCount = 0;
        
        let recordId = event.currentTarget.dataset.recordId;
        
        let selectRecord = this.searchRecords.find((item) => {
            return item.Id === recordId;
        });
        this.selectedRecord = selectRecord;
        this.expandInput(false);
        
        //let the parent component know a record was selected and pass the record Id
        const selectedEvent = new CustomEvent('lookup', {
            detail: {  
                data : {
                    record          : selectRecord,
                    recordId        : recordId
                }
                // ,currentRecordId : this.currentRecordId
            }
        });
        this.dispatchEvent(selectedEvent);
    }

    handleOnSubmit(event){
        this.errors = null;
        event.preventDefault();
        const fields = event.detail.fields;
        let errorList = [];
        if(this.createNewFieldsWithRequired != undefined){
            this.createNewFieldsWithRequired.forEach(element => {
                if(element.required && (fields[element.fieldAPI] == null || fields[element.fieldAPI] === '')){
                    errorList.push(element.fieldLabel);
                }
            });
            if(errorList == undefined || errorList.length == 0){
                this.template.querySelector('lightning-record-form').submit(fields);
            }
            else {
                this.errors = errorList.join(", ");;
            }
        } else {
            this.template.querySelector('lightning-record-form').submit(fields);
        }
    }

    //If user has created a new record instead of selecting an existing one
    handleNewRecordResponse(event){
        this.editRecord = false;
        this.showCreateNew = false;
        this.valueId = event.detail.id;
        this.clickCount = 0;
        let response;
        getCurrentRecord({objectName: this.objName, recordId: event.detail.id, fields: this.fields})
        .then((result) =>{
            response = result;
            this.currentRecordResponse(result);
        })
        .finally( ()=>{
            this.showRecent = true;
            this.isLoading = false;
            this.expandInput(false);
            
            //let the parent component know a record was created and pass the record Id
            const selectedEvent = new CustomEvent('lookup', {
                detail: {  
                    data : {
                        recordId       : event.detail.id,
                        record : response
                    }
                }
            });
            this.dispatchEvent(selectedEvent);
        });
    }

    //When the input field/dropdown needs to expand to make it easier for the user to see the table, we need to let the parent component know.
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

    //When the input field/dropdown size needs to change we use this method
    handleToggleExpandSearch(){
        if(this.isEditMode){
            this.showExpandedSearch = !this.showExpandedSearch;
            this.showRecent = !this.showRecent;
            if(this.showExpandedSearch){
                this.showRecent = false;
                this.handleQuery();
                this.expandInput(true);
            } else {
                this.searchKey = '';
                this.handleQueryRecentlyViewed();
                this.expandInput(false);
            }
        }
    }

    //when the user clicks on the icon in the text field, need to open the dropdown and query the recently viewed records
    handleInputIconClick(){
        this.selectedRecord = null;
        this.searchKey = '';
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

    //this is used by the event listener
    close() { 
        this.showRecent = false;
        this.showExpandedSearch = false;
        this.editRecord = false;
        this.showCreateNew = false;
        this.expandInput(false);
        this.removeListener();
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

    get addNewIcon(){
        return 'utility:new';
    }

    get inputFieldClass(){
        return this.editRecord ? 'slds-input slds-combobox__input slds-combobox__input-value slds-has-focus' : 'slds-input slds-combobox__input slds-combobox__input-value';
    }

    get hasCreateNewFields(){
        return this.createNewFieldsWithRequired != undefined;
    }

    get createNewFieldList(){
         if(this.hasCreateNewFields){
            let fieldList = [];
            this.createNewFieldsWithRequired.forEach(element => {
                fieldList.push(element.fieldAPI);
            });
            return fieldList;
        }
    }

    get showErrors(){
        return this.errors != undefined && this.errors != null;
    }
}

/************************Example code to include in parent component*********************/
/*
Example of how to add the customLookupComponent on a parent component
    <div class="slds-col slds-size_1-of-1 slds-medium-size_3-of-6 slds-large-size_1-of-6" data-id='customlookupcreatenew'>
        <label class="slds-form-element__label" for="form-element-01">Person In PG</label>
        <c-custom-lookup
            obj-name='Contact'
            icon-name='standard:contact'
            value-id={customLookupValueId}
            placeholder='Search Contacts...'
            fields={customLookupFields}
            display-fields={customLookupDisplayFields}
            create-new-fields-with-required={customLookupCreateNewFields}
            field-to-query='Name'
            label-name='Playgroup Contact'
            onlookup={customLookupEvent}
            onexpandfield={handleCustomLookupExpandSearch}
            element-id='customlookupcreatenew'
            clear-selection={customLookupClearSelection}
            allow-create-new=true
            initial-col-size='slds-col slds-size_1-of-1 slds-medium-size_3-of-6 slds-large-size_1-of-6'
        >
        </c-custom-lookup>
    </div>
*/

/*
Example of customLookupValueId - returns Id of lookup field's current value
    get customLookupValueId(){
        if(this.sessionPlaygroupLeader){
            return this.sessionPlaygroupLeader;
        }
    }
*/

/*
Example of customLookupFields
    customLookupFields = ["Name","Email","Title"];
*/

/*
Example of customLookupDisplayFields
    customLookupDisplayFields = 'Name, Email, Title';
*/

/*
Example of createNewFieldsWithRequired
    get customLookupCreateNewFields(){
        return [
            {fieldAPI: 'FirstName', fieldLabel: 'First Name', required: true},
            {fieldAPI: 'LastName', fieldLabel: 'Last Name', required: true},
            {fieldAPI: 'Title', required: false},
            {fieldAPI: 'Department', required: false},
            {fieldAPI: 'Email', required: false}
        ];
    }
*/

/*
Example of handling the customLookupEvent
(this is when a selection has been made and the recordId is passed to the parent component)
    customLookupEvent(event){
        this.customLookupNewId = event.detail.data.recordId;
    }
*/

/*
Example of handling the expand Search Event
    handleCustomLookupExpandSearch(event){
        let data = event.detail.data;
        let dataId = data.elementId;
        this.template.querySelector('[data-id="' + dataId + '"]').className =
            data.expandField ? 'slds-col slds-size_1-of-1' : data.initialColSize;
    }
*/