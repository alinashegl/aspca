import { LightningElement, api } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import vkStyles from '@salesforce/resourceUrl/vkDatatableStyles';

const DELAY = 300;
const SHOWIT = 'visibility:visible';
const HIDEIT = 'visibility:hidden';
export default class CustomTable extends LightningElement {
    @api columns;
    @api
    set records(value){
        this._records = value ? [...value] : [];
        if(this.isConnected) this.setupTable();
    }
    get records(){
        return this._records;
    }
    @api showCheckbox = false;
    @api showRowNumber = false;
    @api sortedBy;
    @api sortedDirection = 'desc';
    //PAGINATION VARIABLES
    @api showPagination = false;
    @api pageSizeOptions = [5,10,20,30,50,75,100];
    @api showSearchBox = false;
    @api showSearch;
    @api placeHolder = 'Search Table...';
    @api customStyle;
    set tableLayout(value){
        this._tableLayout = value ? value : 'fixed';
        //this.tableStyle = 'table-layout:'+this._tableLayout;
    }
    get tableLayout(){
        return this._tableLayout;
    }

    //LOCAL VARIABLES
    showTable = false;
    isLoading = false;
    spinnerMsg = 'Loading...';
    _records; //Clone of Original records
    tableData; //Records modified according to table data structure
    tableData2Display; //Table data structured records available to display
    pageData; //Records displayed on a page
    pageSize = 5;
    totalPages;
    pageNumber = 1;
    searchKey;
    controlPagination = SHOWIT;
    controlPrevious = HIDEIT;
    controlNext = SHOWIT;
    isAscending = false;
    isEdited = false;
    isConnected = false;
    _tableLayout = 'fixed';
    tableStyle = 'table-layout:'+this._tableLayout;

    delayTimeout;
    initialLoad = true;
    stylesLoaded = false;
    selectedTotal = 0;
    selectedPerPage = 0;
    selRowsMap = new Map();
    currentElement;
    currentWidth;
    mousePosition;
    resizerStyle;
    recsEdited = new Map();

    connectedCallback(){
        this.isConnected = true;
        this.setupTable();
    }

    disconnectedCallback() {
        this.isConnected = false;
    }

    renderedCallback(){
        if(!this.stylesLoaded){
            Promise.all([
                loadStyle(this, vkStyles)
            ]).then(() => {
                this.stylesLoaded = true;
            }).catch(error => {
                console.log('Error loading styles**'+JSON.stringify(error));
                this.stylesLoaded = false;
            });
        }

        let table = this.template.querySelector('.vk-data-table');
        if(table){
            this.resizerStyle = 'height:'+table.offsetHeight+'px';
            let cols = this.template.querySelectorAll('TH');
            cols.forEach(col=>{
                col.style.width = col.style.width ? col.style.width : col.offsetWidth+'px';
                col.style.minWidth = col.style.minWidth ? col.style.minWidth : '50px';
            });
        }
    }

    setupTable(){
        this.showTable = false;
        this.isEdited = false;
        this.totalRecords = this._records.length;
        if(this.totalRecords === 0){
            this.showPagination = false;
            return;
        }
        if(this.sortedBy) this._records = this.sortData(this._records,this.sortedBy,this.sortedDirection);

        this.setupColumns();
        this.setupPagination();
        this.setupData();
        this.showTable = true;
        this.initialLoad = false;
    }

    setupColumns(){
        let tempCols = [], i=0;
        //set col values
        this.columns.forEach(val => {
            let col = {...val};
            col.index = i++;
            col.thClass = 'slds-truncate';
            col.thClass += val.resizable ? ' vk-is-resizable' : '';
            col.style = col.width ? 'width:'+col.width+'px;' : '';
            col.style += col.minWidth ? 'min-width:'+col.minWidth+'px;' : '';
            col.style += col.maxWidth ? 'max-width:'+col.maxWidth+'px;' : '';
            if(col.sortable === true){
                col.thClass += ' vk-is-sortable';
                col.sortBy = col.sortBy ? col.sortBy : col.fieldName;
                col.sortByTitle = 'Sort By: '+col.label;
                let sortIconClass = this.sortedDirection === 'asc' ? 'vk-sort_desc' : 'vk-sort_asc';
                col.sortIconStyle = 'visibility:hidden;';
                if(col.sortBy === this.sortedBy){
                    sortIconClass = this.sortedDirection === 'asc' ? 'vk-sort_asc' : 'vk-sort_desc';
                    col.sortIconStyle = 'visibility:visible;';
                }
                col.sortIconClass = 'vk-sort-icon-div '+sortIconClass;
            }
            tempCols.push(col);
        });
        this.columns = tempCols;
    }

    setupData(){
        let recs = [], i=0;
        this._records.forEach(value => {
            let row = {}, fields = [], j=0;
            this.columns.forEach(col => {
                //set data values
                let field = {};
                field.name = col.fieldName;
                field.value = value[col.fieldName];
                field.type = col.type;
                field.disabled = col.disabled;
                field.required = col.required;
                field.options = col.options;
                field.linkLabel = col.type === 'link' || col.type === 'lookup' ? value[col.linkLabel] : col.linkLabel;
                field.imageSource = col.type === 'image-action' ? col.src : '#';
                field.target = col.target;
                field.minValue = col.minValue;
                field.maxValue = col.maxValue;
                field.minFractionDigits = col.minFractionDigits;
                field.maxFractionDigits = col.maxFractionDigits;
                field.currencyCode = col.currencyCode;

                field.iconName = col.iconName;
                field.iconSize = 'xx-small';
                field.actionName = col.actionName;
                field.iconVariant = col.iconVariant;
                field.title = col.title;
                field.readOnly = !col.editable;
                field.tdClass = col.editable ? 'vk-cell-edit' : '';
                field.index = j++;
                fields.push(field);
            });
            row.id = value.Id;
            row.index = i++;
            row.rowNumber = i;
            row.isSelected = false;
            row.mode = 'view';
            row.fields = fields;
            recs.push(row);
        });
        this.tableData = recs;
        this.tableData2Display = JSON.parse(JSON.stringify(recs));
        this.setupPages();
    }

    setupPagination(){
        if(!this.showPagination) this.pageSize = this.totalRecords;
        else{
            this.showSearchBox = true;
            this.pageSize = this.pageSizeOptions ? this.pageSizeOptions[0] : 5;
            if(this.pageSize >= this.totalRecords){
                this.pageSize = this.totalRecords;
                this.showPagination = false;
                this.showSearchBox = false;
            }
            this.totalPages = Math.ceil(this.totalRecords/this.pageSize);
        }
    }
    
    
    //START: PAGINATION
    handleRecordsPerPage(event){
        this.pageSize = event.target.value;
        this.setupPages();
    }
    handlePageNumberChange(event){
        if(event.keyCode === 13){
            this.pageNumber = event.target.value;
            this.setupPages();
        }
    }
    previousPage(){
        this.pageNumber = this.pageNumber-1;
        this.setupPages();
    }
    nextPage(){
        this.pageNumber = this.pageNumber+1;
        this.setupPages();
    }
    setupPages(){
        this.totalRecords = this.tableData2Display.length;

        this.setPaginationControls();

        let pageRecs = [];
        for(let i=(this.pageNumber-1)*this.pageSize; i<this.pageNumber*this.pageSize; i++){
            if(i === this.totalRecords) break;
            pageRecs.push(this.tableData2Display[i]);
        }
        this.setupPageData(pageRecs);
    }
    setupPageData(recs){
        this.pageData = [];
        this.selectedPerPage = 0;     
        recs.forEach(rec=>{
            let row = {...rec};
            row.rowClass = row.isSelected ? 'vk-is-selected' : '';
            this.selectedPerPage = Number(this.selectedPerPage) + 1;
            if(row.isSelected){
                this.selRowsMap.set(row.index, this._records[row.index]);                
            }else{
                this.selectedPerPage = Number(this.selectedPerPage) - 1;
                if(this.selRowsMap.has(row.index))
                    this.selRowsMap.delete(row.index);
            }
            this.selectedTotal = this.selRowsMap.size;
            this.pageData.push(row);
        });
        if(!this.initialLoad) this.manageSelectAllStyle();
    }
    setPaginationControls(){
        if(!this.pageSize) this.pageSize = this.totalRecords;
        this.totalPages = Math.ceil(this.totalRecords/this.pageSize);

        //Control Pre/Next buttons visibility by Total pages
        if(this.totalPages === 1){
            this.controlPrevious = HIDEIT;
            this.controlNext = HIDEIT;
        }else if(this.totalPages > 1){
           this.controlPrevious = SHOWIT;
           this.controlNext = SHOWIT;
        }
        //Control Pre/Next buttons visibility by Page number
        if(this.pageNumber <= 1){
            this.pageNumber = 1;
            this.controlPrevious = HIDEIT;
        }else if(this.pageNumber >= this.totalPages){
            this.pageNumber = this.totalPages;
            this.controlNext = HIDEIT;
        }
        //Control Pre/Next buttons visibility by Pagination visibility
        if(this.controlPagination === HIDEIT){
            this.controlPrevious = HIDEIT;
            this.controlNext = HIDEIT;
        }
    }
    //END: PAGINATION

    //START: ROW SELECTION
    handleRowSelection(event){
        let index = Number(event.target.id.split('-')[0]);
        let isSelected = event.target.checked;        

        this.pageData.forEach(rec => {
            if(rec.rowNumber === index+1){
                rec.isSelected = isSelected;
                this.tableData2Display[index].isSelected = isSelected;
            }
        });
        this.setupPageData(this.pageData);
        this.dispatchEvent(new CustomEvent('rowselection', {detail: Array.from(this.selRowsMap.values())}));        
    }
    handlePageRowsSelection(event){
        let isSelected = event.target.checked;

        this.pageData.forEach(rec => {
            rec.isSelected = isSelected;
            this.tableData2Display[rec.index].isSelected = isSelected;
        });
        this.setupPageData(this.pageData);
        this.dispatchEvent(new CustomEvent('rowselection', {detail: Array.from(this.selRowsMap.values())}));
    }
    handleAllRowsSelection(event){
        let isSelected = event.target.checked;

        this.tableData2Display.forEach(rec=>{
            rec.isSelected = isSelected;
            if(isSelected)
                this.selRowsMap.set(rec.index, this._records[rec.index]);
            else if(this.selRowsMap.has(rec.index))
                this.selRowsMap.delete(rec.index);
        });
        this.selectedTotal = this.selRowsMap.size;
        this.setupPages();
        this.dispatchEvent(new CustomEvent('rowselection', {detail: Array.from(this.selRowsMap.values())}));
    }
    manageSelectAllStyle(){
        //Select Rows per Page
        let pageCheckbox = this.template.querySelector('.page-checkbox');
        if(!pageCheckbox) return;        
        if(this.selectedPerPage === 0){
            pageCheckbox.checked = false;
            pageCheckbox.indeterminate = false;
        }else if(this.selectedPerPage === this.pageData.length){
            pageCheckbox.checked = true;
            pageCheckbox.indeterminate = false;
        }else{
            pageCheckbox.checked = false;
            pageCheckbox.indeterminate = true;
        }
        
        //Select All Rows
        let allCheckbox = this.template.querySelector('.select-all-checkbox');
        if(!allCheckbox) return;
        if(this.selectedTotal === 0){
            allCheckbox.checked = false;
            allCheckbox.indeterminate = false;
        }else if(this.selectedTotal === this._records.length){
            allCheckbox.checked = true;
            allCheckbox.indeterminate = false;
        }else{
            allCheckbox.checked = false;
            allCheckbox.indeterminate = true;
        }
    }
    //END: ROW SELECTION

    //START: SORTING
    handleSorting(event){
        this.isLoading = true;
        let childElm = event.target;
        let parentElm = childElm.parentNode;
        while(parentElm.nodeName != 'TH') parentElm = parentElm.parentNode;
        let sortBy = parentElm.id.split('-')[0];
        setTimeout(() => {
            let sortDirection = this.sortedDirection === 'asc' ? 'desc' : 'asc';
            this._records = this.sortData(this._records,sortBy,sortDirection);
            this.setupColumns();
            this.setupData();
            this.isLoading = false;
        }, 0);
    }
    sortData(data, sortBy, sortDirection){
        let clonedData = [...data];
        clonedData.sort(this.sortDataBy(sortBy, sortDirection === 'asc' ? 1 : -1));
        this.sortedDirection = sortDirection;
        this.sortedBy = sortBy;
        return clonedData;
    }
    sortDataBy(field, reverse, primer) {
        const key = primer
            ? function(x) { return primer(x[field]) }
            : function(x) { return x[field] };

        return function (a, b) {
            let A, B;
            if(isNaN(key(a)) === true)
                A = key(a) ? key(a).toLowerCase() : '';
            else A = key(a) ? key(a) : -Infinity;
            
            if(isNaN(key(b)) === true)
                B = key(b) ? key(b).toLowerCase() : '';
            else B = key(b) ? key(b) : -Infinity;

            return reverse * ((A > B) - (B > A));
        };
    }
    //END: SORTING

    //START: SEARCH
    handleSearch(event){
        window.clearTimeout(this.delayTimeout);
        let searchKey = ''+event.target.value;
        this.isLoading = true;
        if(searchKey){
            this.delayTimeout = setTimeout(() => {
                this.searchKey = searchKey.toLowerCase();
                let recs = this.tableData.filter(row=>this.searchRow(row,this.searchKey));
                this.tableData2Display = recs;
                this.setupPages();
                this.isLoading = false;
            }, DELAY);
        }else{
            this.tableData2Display = JSON.parse(JSON.stringify(this.tableData));
            this.setupPages();
            this.isLoading = false;
        }
    }
    searchRow(row,searchKey){
        let fields = row.fields.filter(f => {
            let fieldVal = f.type === 'link' || f.type === 'lookup' ? ''+f.linkLabel : ''+f.value;
            let fieldValue = fieldVal.toLowerCase();
            return fieldValue && fieldValue.includes(searchKey) ? true : false;
        });
        return fields.length > 0;
    }
    //END: SEARCH

    //START: COL RESIZING
    calculateWidth(event){
        this.currentElement = event.target;
        let parentElm = this.currentElement.parentNode;
        while(parentElm.tagName != 'TH') parentElm = parentElm.parentNode;
        this.currentWidth = parentElm.offsetWidth;
        this.mousePosition = event.clientX; //Get current mouse position

        //Stop text selection event so mouse move event works perfectlly.
        if(event.stopPropagation) event.stopPropagation();
        if(event.preventDefault) event.preventDefault();
        event.cancelBubble = true;
        event.returnValue = false;
    }
    setNewWidth(event){
        if(!this.currentElement) return;

        let parentElm = this.currentElement.parentNode;
        while(parentElm.tagName != 'TH') parentElm = parentElm.parentNode;
        let movedWidth = event.clientX - this.mousePosition;
        let newWidth = this.currentWidth + movedWidth;
        parentElm.style.width = newWidth+'px';
    }
    stopColumnResizing(){
        this.currentElement = undefined;
    }
    //END: COL RESIZING

    //START: ROW ACTION
    handleRowAction(event){
        let rowIndex = event.detail.rowIndex;
        let actionName = event.detail.actionName;
        let obj ={row: this._records[rowIndex], action: {name: actionName}};
        this.dispatchEvent(new CustomEvent('rowaction', {detail: obj}));
    }
    //END: ROW ACTION

    //START: CELL EDITING
    handleCellEdit(event){
        this.isEdited = true;
        let resp = event.detail;
        this.tableData2Display[resp.rowIndex].mode = 'edit';
        this.setupPages();
    }
    handleCellChange(event){
        let resp = event.detail;
        let rec = {...this._records[resp.rowIndex]};
        this._records[resp.rowIndex] = rec;
        
        if(resp.value !== this._records[resp.rowIndex][resp.name]){
            this.tableData2Display[resp.rowIndex].fields[resp.colIndex].tdClass = 'vk-cell-edit vk-cell-edited';
            this.tableData2Display[resp.rowIndex].fields[resp.colIndex].value = resp.value;
            rec[resp.name] = resp.value;
        }else{
            this.tableData2Display[resp.rowIndex].fields[resp.colIndex].tdClass = 'vk-cell-edit';
            this.tableData2Display[resp.rowIndex].fields[resp.colIndex].value = resp.value;
        }
        let changedFields = this.tableData2Display[resp.rowIndex].fields.filter(field=>field.tdClass.includes('vk-cell-edited'));
        if(changedFields.length > 0){
            this.tableData2Display[resp.rowIndex].isSelected = true;
            this.recsEdited.set(resp.rowIndex,rec);
        }else{
            this.tableData2Display[resp.rowIndex].isSelected = false;
            if(this.recsEdited.has(resp.rowIndex))
                this.recsEdited.delete(resp.rowIndex);
        }
        this.setupPages();
    }
    cancelChanges(){
        this.isEdited = false;
        this.tableData2Display = JSON.parse(JSON.stringify(this.tableData));
        this.setupPages();
    }
    handleSave(){
        let recs2Save = [];
        for(let [key,value] of this.recsEdited){
            if(this.selRowsMap.has(key))
                recs2Save.push(value);
        }
        this.dispatchEvent(new CustomEvent('save', {detail: recs2Save}));
    }
    //END: CELL EDITING
}