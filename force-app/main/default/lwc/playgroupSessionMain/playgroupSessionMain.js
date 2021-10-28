import { LightningElement, api, wire } from 'lwc';
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

    customLookupFields = ["Name","Email","External_Id__c"];
    customLookupDisplayFields = 'Name, Email, External_Id__c';

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

    handleCustomLookupExpandSearch(event){
        window.console.log('in handleCustomLookupExpandSearch: ', JSON.stringify ( event.detail.data) );
        let data = event.detail.data;
        let dataId = data.elementId;
        this.template.querySelector('[data-id="' + dataId + '"]').className =
            data.expandField ? 'slds-col slds-size_1-of-1' : data.initialColSize;
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