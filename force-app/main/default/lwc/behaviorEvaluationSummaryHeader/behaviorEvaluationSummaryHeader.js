import { LightningElement, api, wire } from 'lwc';
import { getRecord, updateRecord, getFieldValue } from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/Behavior_Evaluation__c.Id';
import LOCKED_FIELD from '@salesforce/schema/Behavior_Evaluation__c.IsLocked__c';
import CREATED_DATE_FIELD from '@salesforce/schema/Behavior_Evaluation__c.CreatedDate';
import LAST_MODIFIED_DATE_FIELD from '@salesforce/schema/Behavior_Evaluation__c.LastModifiedDate';
import hasLockUnlockPermission from '@salesforce/customPermission/Lock_Unlock_Behavior_Eval';

import { publish, MessageContext } from 'lightning/messageService';
import BEHAVIOR_LOCK_CHANNEL from '@salesforce/messageChannel/BehaviorLockChannel__c';

export default class BehaviorEvaluationSummaryHeader extends LightningElement {

    lockedFieldApi = LOCKED_FIELD.fieldApiName;
    createdDateFieldApi = CREATED_DATE_FIELD.fieldApiName;
    lastModifiedDateFieldApi = LAST_MODIFIED_DATE_FIELD.fieldApiName;

    @api recordId;

    eval;
    @wire(getRecord, { recordId: '$recordId', fields: [ID_FIELD, LOCKED_FIELD, CREATED_DATE_FIELD, LAST_MODIFIED_DATE_FIELD] })
    response(result) {
        if (result.data) {
            this.eval = result;
            if (this.createdDate == this.lastModifiedDate) {
                this.tempLock = false;
            }
        }
    }

    @wire(MessageContext)
    messageContext;

    tempLock = true;
    saving = false;
    error;

    handleUnlock() {
        this.saving = true;
        window.console.log('lockChangeHandler');
        this.tempLock = false;
        const fields = {};
        fields['Id'] = this.recordId;
        fields[this.lockedFieldApi] = !this.isLocked;
        const recordUpdate = { fields };
        updateRecord(recordUpdate)
            .then(recordUpdate => {
                this.error = undefined;
                const payload = { isLocked: !this.isLocked };
                publish(this.messageContext, BEHAVIOR_LOCK_CHANNEL, payload);
            })
            .catch(error => {
                this.error = error;
            })
            .finally(() => {
                this.saving = false;
            });
    }

    handleTempUnlock() {
        this.tempLock = false;
        const payload = { isTempLocked: false };
        publish(this.messageContext, BEHAVIOR_LOCK_CHANNEL, payload);
    }

    get showEditButton() {
        return this.tempLock && !this.isLocked;
    }

    get showLockButton() {
        return this.isLocked || hasLockUnlockPermission;
    }

    get lockFields() {
        return this.isLocked || this.showEditButton;
    }

    get lockedVariant() {
        return this.isLocked ? 'destructive' : 'brand';
    }
    get lockedLabel() {
        return this.saving ?
            this.isLocked ? 'Unlocking Evaluation' : 'Locking Evaluation' :
            this.isLocked ? 'Evaluation Locked' : 'Lock Evaluation';
    }

    get disableLockButton() {
        return !hasLockUnlockPermission;
    }

    get isLocked(){
        return this.eval && this.eval.data ? getFieldValue(this.eval.data, LOCKED_FIELD) : true;
    }

    get createdDate(){
        return getFieldValue(this.eval.data, CREATED_DATE_FIELD);
    }

    get lastModifiedDate(){
        return getFieldValue(this.eval.data, LAST_MODIFIED_DATE_FIELD);
    }
}