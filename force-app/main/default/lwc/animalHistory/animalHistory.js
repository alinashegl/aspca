import { LightningElement, wire, api, track} from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getRecords from "@salesforce/apex/LogHistory.getAnimalHistory";

const columns = [{
	"label": "Animal",
	"fieldName": "recordUrl",
	"type": "url",
	"typeAttributes": {
		"label": {
			"fieldName": "RecordName__c"
		},
		"target": "_blank"
	}
    }, {
        "fieldName": "FieldName__c",
        "label": "Field Name",
        "type": "text",
        "sortable": "true"
    }, {
        "fieldName": "OldValue__c",
        "label": "Old Value",
        "type": "text"
    }, {
        "fieldName": "NewValue__c",
        "label": "New Value",
        "type": "text"
    }, {
        "fieldName": "createdBy",
        "label": "Modified By",
        "type": "text",
        "sortable": "true"
    }, {
        "fieldName": "CreatedDate",
        "label": "Last Modified",
        "type": "date",
        "typeAttributes": {
            "day": "numeric",
            "month": "numeric",
            "year": "numeric",
            "hour": "2-digit",
            "minute": "2-digit",
            "second": "2-digit",
            "hour12": "true"
        },
        "sortable": "true"
    }];

export default class AnimalHistory extends LightningElement {
    @track value;
    @track error;
    @track data;
    @api sortedDirection = 'asc';
    @api sortedBy = 'CreatedDate';
    @api searchKey = '';
    @api filterDateValue = '';
    @api recordId;
    result;
    
    @track page = 1; 
    @track items = []; 
    @track data = []; 
    @track columns; 
    @track startingRecord = 1;
    @track endingRecord = 0; 
    @track pageSize = 5; 
    @track totalRecountCount = 0;
    @track totalPage = 0;
  
    filterOptions = [
        {label : "All", value: ""},
        {label : "Designated Handler Reason", value: "Designated Handler Reason"},
        {label : "Handling Instructions", value: "Handling Instructions"},
        {label : "Play Style Notes", value: "Play Style Notes"},
        {label : "Shelter Color Coding", value: "Shelter Color Coding"},
        {label : "Current Behavior Grade", value: "Current Behavior Grade"},
        {label : "Grade Change Reason", value: "Grade Change Reason"}
    ];
    @wire(getRecords, {recordId : '$recordId', searchKey: '$searchKey', dateFilter: '$filterDateValue', sortBy: '$sortedBy', sortDirection: '$sortedDirection'})
    wiredData({ error, data }) {
        if (data) {
            let newData = data.map((item) => 
                Object.assign({}, item, {
                    recordUrl:`/${item.ObjectId__c}`,
                    createdBy: item.CreatedBy.Name
                })
            )
            this.items = newData;
            
            this.totalRecountCount = data.length; 
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
            
            this.data = this.items.slice(0,this.pageSize); 
            this.endingRecord = this.pageSize;
            this.columns = columns;
            this.error = undefined;

        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }

    //clicking on previous button this method will be called
    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1; //decrease page by 1
            this.displayRecordPerPage(this.page);
        }
    }

    //clicking on next button this method will be called
    nextHandler() {
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; //increase page by 1
            this.displayRecordPerPage(this.page);            
        }             
    }

    //this method displays records page by page
    displayRecordPerPage(page){

        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 

        this.data = this.items.slice(this.startingRecord, this.endingRecord);

        this.startingRecord = this.startingRecord + 1;
    }    
    
    sortColumns( event ) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        return refreshApex(this.result);
        
    }
  
    handleKeyChange( event ) {
        this.searchKey = event.target.value;
        return refreshApex(this.result);
    }

    handleFilterDateChange(event){
        this.filterDateValue = "";
        let filterDate = event.target.value;
        if(filterDate){
            let maxDate = (new Date(filterDate)).toISOString().split('T')[0];
            this.filterDateValue = `(CreatedDate > ${filterDate}T00:00:00Z AND CreatedDate < ${maxDate}T23:59:59Z)`;
        }
        return refreshApex(this.result);
    }

}