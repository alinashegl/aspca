import { LightningElement, api, wire } from 'lwc';
import getPlaygroupSessionInfo from '@salesforce/apex/playgroupSessionLWCController.getPlaygroupSessionInfo';
import copyPlaygroup from '@salesforce/apex/playgroupSessionLWCController.copyPlaygroup';

export default class PlaygroupSessionMain extends LightningElement {
    @api recordId;
    wireResponse;
    updating = true;

    @wire(getPlaygroupSessionInfo, {sessionId: '$recordId'})
    response(result){
        this.wireResponse = result;
        this.updating = false;
    }

    handleCopyPlaygroup(){
        this.updating = true;
        copyPlaygroup({sessionId: this.recordId})
        .then((response) => {
            this.recordId = response;
        })
        .finally(() => {
            this.updating = false;
        })
    }
}