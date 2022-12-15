import { LightningElement, api, wire, track } from 'lwc';
import getEvalConfig from '@salesforce/apex/BehaviorEvaluationLWCController.getEvalConfig';


export default class BehaviorEvaluationTab extends LightningElement {
    @api tab;
    @api configId;
    config;
    @track picklists = [];

    error;
    errorMessage;

    @wire(getEvalConfig, {recordId : '$configId'}) 
    response(result) {
        if(result.data){
            this.config = result.data.testConfig;
            this.picklists = result.data.pdListOfLists;
        }
        else if(result.error){
            this.errorMessage = 'Error retrieving the evaluation and tests:';
            this.error = result.error;
        }
    }
}