import { LightningElement, api, wire } from 'lwc';
import getEvalConfig from '@salesforce/apex/BehaviorEvaluationLWCController.getEvalConfig';


export default class BehaviorEvaluationTab extends LightningElement {
    @api tab;
    config;

    error;
    errorMessage;

    @wire(getEvalConfig, {recordId : '$tab.id'}) 
    response(result) {
        if(result.data){
            this.config = result.data;
        }
        else if(result.error){
            this.errorMessage = 'Error retrieving the evaluation and tests:';
            this.error = result.error;
        }
    }
}