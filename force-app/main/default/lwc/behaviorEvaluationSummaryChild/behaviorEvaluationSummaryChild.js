import { LightningElement, api } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import SUMMARY_TEST_COMMENTS_FIELD from '@salesforce/schema/Behavior_Evaluation_Summary__c.Summary_Comments__c';

export default class BehaviorEvaluationSummaryChild extends LightningElement {
    summaryTestCommentsFieldAPI = SUMMARY_TEST_COMMENTS_FIELD.fieldApiName; 

    @api record;
    error;
    errorMessage;
    summaryText = '';
    textAreaFloor = 80;

    _isLocked;
    @api
    get isLocked() {
        return this._isLocked;
    }
    set isLocked(value) {
        this._isLocked = value;
    }

    connectedCallback(){
        if(this.record){
            this.summaryText = this.record.summaryComments != undefined ? this.record.summaryComments : '';
        }
    }

    handleCommentUpdate(event) {
        let comments = event.target.value;
        if(this.summaryText != comments){
            this.summaryText = comments;
            comments = comments.replace(this.record.testName + ':', '').trim();

            const fields = {};
            fields[this.summaryTestCommentsFieldAPI] = comments;
            fields['Id'] = this.record.testId;
            const recordInput = { fields };

            window.console.log('recordInput: ', JSON.stringify(recordInput));

            updateRecord(recordInput)
            .then(() => {
                window.console.log('success');
            })
            .catch(error => {
                window.console.log('error: ', error.body.message);
                this.errorMessage = 'Error updating comments:';
                this.error = error;
            })
            .finally(() => {
                this.dispatchEvent(new CustomEvent('summarychanged'));
            });
        }
    }

    get textToDisplay(){
        return this.isLocked ? this.lockedDisplay : this.unlockedDisplay;
    }

    get lockedDisplay() {
        return this.record.testName + ': ' + this.unlockedDisplay;
    }

    get unlockedDisplay() {
        return this.summaryText;
    }

    get useTextArea(){
        return this.summaryText.length > this.textAreaFloor;
    }

}