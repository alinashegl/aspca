import { LightningElement, api, wire } from 'lwc';

import getChildList from '@salesforce/apex/TreatmentSessionLWCController.getChildList';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class TreatmentSessionChildList extends LightningElement {
    @api protocolId;
    @api objectApi;

    loading = false;
    recordList = [];
    addNewRecord = false;

    @wire(getChildList, {protocolId: '$protocolId', objectApi: '$objectApi'})
    records(result){
        this.recordList = result;
    }

    // connectedCallback(){
    //     this.loading = true;
    //     this.recordList = [];
    //     getChildList({'protocolId': this.protocolId, 'objectApi': this.objectApi})
    //     .then(result => (this.recordList = result))
    //     .catch(error => {
    //         window.console.log('connectedCallback: -------error-------------'+error);
    //         window.console.log('error: ', error);
    //     })
    //     .finally(() => {
    //         window.console.log('recordList = ', JSON.stringify(this.recordList));
    //         this.loading = false;
    //     });
    // }

    handleAddNew(){
        this.addNewRecord = true;
    }

    handleDeleteChild(event){
        window.console.log('handleDeleteChild: ', event.detail);
        this.deleteRecord(event.detail.id);
    }

    handleUpdateList(event){
        window.console.log('updating list', event.detail);
        this.addNewRecord = false;
        return refreshApex(this.recordList);
        // this.connectedCallback();
    }

    deleteRecord(recordId){
        deleteRecord(recordId)
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Record deleted',
                    variant: 'success'
                })
            );
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error deleting record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        })
        .finally(() => {
            return refreshApex(this.recordList);
            // this.connectedCallback();
        });
    }

    get tableName(){
        return this.objectApi == 'Additional_Dog_Present__c' ? 'Dogs Present' : 'Protocol Contacts';
    }
}