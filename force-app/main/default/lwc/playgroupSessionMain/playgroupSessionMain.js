import { LightningElement, api, wire } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor'
import getPlaygroupSessionInfo from '@salesforce/apex/playgroupSessionLWCController.getPlaygroupSessionInfo';
import startPlaygroupSession from '@salesforce/apex/playgroupSessionLWCController.startPlaygroupSession';

export default class PlaygroupSessionMain extends LightningElement {
    @api recordId;
    @api newSession = false; //if newSession = true need to create a session
    @api animalIds = [];
    wireResponse;
    showSpinner = true;
    animals = [];
    session;
    sessionPlaygroupLeader;

    customLookupFields = ["Name","Email","Title"];
    customLookupDisplayFields = 'Name, Email, Title';
    customLookupCreateNewFields = ['FirstName', 'LastName', 'Title', 'Department', 'Email'];
    formFactor = FORM_FACTOR;

    @wire(getPlaygroupSessionInfo, {sessionId: '$recordId'})
    response(result){
        this.wireResponse = result;
        window.console.log('result: ', JSON.stringify(result));
        if(result.data ){
            this.session = result.data.playgroupSession;
            this.sessionPlaygroupLeader = result.data.playgroupSession.Playgroup_Leader__c;
            if(result.data.animalPlaygroups){
                this.animals = result.data.animalPlaygroups;
                
            }
            this.showSpinner = false;
        }
    }

    handleCopyPlaygroup(){
        this.showSpinner = true;
        startPlaygroupSession({sessionId: this.recordId})
        .then((response) => {
            this.recordId = response;
        })
        .finally(() => {
            this.showSpinner = false;
        })
    }

    customLookupEvent(event){
        window.console.log('customLookupEvent: ', JSON.stringify ( event.detail));
        this.sessionPlaygroupLeader = event.detail.data.recordId;
    }

    customLookupExpandedField = false;

    handleCustomLookupExpandSearch(event){
        window.console.log('in handleCustomLookupExpandSearch: ', JSON.stringify ( event.detail.data) );
        let data = event.detail.data;
        this.customLookupExpandedField = data.expandField;
    }

    get customLookupLeaderDeviceSize(){
        if(FORM_FACTOR == 'Large'){
            return this.customLookupExpandedField ? '6' : '3';
        }
        if(FORM_FACTOR == 'Medium'){
            return this.customLookupExpandedField ? '12' : '6';
        }
    }

    get smallForm(){
        return this.formFactor == 'Small';
    }

    get currentDateTime(){
        if(!this.recordId){
            return (new Date().toISOString());
        }
    }

    get customLookupValueId(){
        if(this.sessionPlaygroupLeader){
            return this.sessionPlaygroupLeader;
        }
    }
}