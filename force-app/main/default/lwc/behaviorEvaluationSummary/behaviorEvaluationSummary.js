import { LightningElement, api, wire, track} from 'lwc';
import getConfigList from '@salesforce/apex/BehaviorEvaluationSummaryUtil.getConfigList';
import updateBehaviorEvalSummary from '@salesforce/apex/BehaviorEvaluationSummaryUtil.updateBehaviorEvalSummary';

// Import message service features required for subscribing and the message channel
import { subscribe, MessageContext } from 'lightning/messageService';
import EVAL_SUMMARY_UPDATED_CHANNEL from '@salesforce/messageChannel/EvalSummaryUpdateChannel__c';

export default class BehaviorEvaluationSummary extends LightningElement {
    @api recordId;
    @track configList = [];
    @api isLocked;
    ranOnce = false;

    showSpinner = false;
    error;
    errorMessage;

    disableSaveSummary = true;

    connectedCallback(){
        if(!this.ranOnce){
            getConfigList({recordId : this.recordId})
            .then(result => {
                if(result){
                    this.configList = result.templateList;
                }
            })
            .catch(error => {
                this.error = error;
                this.errorMessage = 'Error retreiving summary list';
            }).finally(()=>{
                this.ranOnce = true;
                this.subscribeToMessageChannel();
            });
        }
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
    subscription = null;

    // Encapsulate logic for LMS subscribe.
    subscribeToMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            EVAL_SUMMARY_UPDATED_CHANNEL,
            (message) => this.handleMessage(message)
        );
    }

    handleMessage(message){
        if(message.isUpdated){
            this.disableSaveSummary = true;
        }
    }
}