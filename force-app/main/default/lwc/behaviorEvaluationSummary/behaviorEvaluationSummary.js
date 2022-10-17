import { LightningElement, api, wire} from 'lwc';
import getConfigList from '@salesforce/apex/BehaviorEvaluationSummaryUtil.getConfigList';
import updateBehaviorEvalSummary from '@salesforce/apex/BehaviorEvaluationSummaryUtil.updateBehaviorEvalSummary';

// Import message service features required for subscribing and the message channel
import { subscribe, MessageContext } from 'lightning/messageService';
import EVAL_SUMMARY_UPDATED_CHANNEL from '@salesforce/messageChannel/EvalSummaryUpdateChannel__c';

export default class BehaviorEvaluationSummary extends LightningElement {
    @api recordId;
    configList;
    @api isLocked;

    showSpinner = false;
    error;
    errorMessage;

    disableSaveSummary = true;

    @wire(getConfigList, { recordId : '$recordId' })
    response(result) {
        if(result.data){
            this.configList = result.data.templateList;
        }
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    handleSaveSummary(){
        this.showSpinner = true;
        updateBehaviorEvalSummary({recordId : this.recordId})
        .then(()=>{
            this.disableSaveSummary = true;
        })
        .catch(error=>{
            this.error = JSON.stringify(error);
            this.errroMessage = 'Error updating summary on evaluation: ';
        })
        .finally(() =>{
            this.showSpinner = false;
        });
    }

    handleSummaryChanged(){
        this.disableSaveSummary = false;
    }

    get generalComments(){
        return "General Comments: ";
    }

    // By using the MessageContext @wire adapter, unsubscribe will be called
    // implicitly during the component descruction lifecycle.
    @wire(MessageContext)
    messageContext;

    // Encapsulate logic for LMS subscribe.
    subscribeToMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            EVAL_SUMMARY_UPDATED_CHANNEL,
            (message) => this.handleMessage(message)
        );
    }

    handleMessage(message){
        window.console.log('lwc we got here');
        this.disableSaveSummary = true;
    }
}