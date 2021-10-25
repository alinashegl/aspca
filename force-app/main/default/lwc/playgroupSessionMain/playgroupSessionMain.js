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

    fields = ["Name","Email","Phone"];
    displayFields = 'Name, Email, Phone';

    @wire(getPlaygroupSessionInfo, {sessionId: '$recordId'})
    response(result){
        this.wireResponse = result;
        window.console.log('result: ', JSON.stringify(result));
        if(result.data && result.data.animalPlaygroups){
            this.animals = result.data.animalPlaygroups;
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

    get currentDateTime(){
        if(!this.recordId){
            return (new Date().toISOString());
        }
    }

    handleLookup(event){
        window.console.log('handleLookup: ', JSON.stringify ( event.detail) )
    }
}