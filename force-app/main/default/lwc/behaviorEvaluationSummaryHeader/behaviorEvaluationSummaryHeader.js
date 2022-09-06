import { LightningElement, api,wire } from 'lwc';
import { getRecord, updateRecord, getFieldValue } from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/Behavior_Evaluation__c.Id';
import LOCKED_FIELD from '@salesforce/schema/Behavior_Evaluation__c.IsLocked__c';
import hasLockUnlockPermission from '@salesforce/customPermission/Lock_Unlock_Behavior_Eval';

import { publish, MessageContext } from 'lightning/messageService';
import BEHAVIOR_LOCK_CHANNEL from '@salesforce/messageChannel/BehaviorLockChannel__c';

export default class BehaviorEvaluationSummaryHeader extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: [ID_FIELD, LOCKED_FIELD]})
    eval;

    @wire(MessageContext)
    messageContext;

    saving = false;
    error;

    handleClick(){
        this.saving = true;
        window.console.log('lockChangeHandler');
        const fields = {};
        fields['Id'] = this.recordId;
        fields[LOCKED_FIELD.fieldApiName] = !this.isLocked;
        const recordUpdate = {fields};
        updateRecord(recordUpdate)
        .then(recordUpdate => {
            this.error = undefined;
            const payload = { isLocked: !this.Locked};
            publish(this.messageContext, BEHAVIOR_LOCK_CHANNEL, payload);
        })
        .catch(error => {
            this.error = error;
        })
        .finally(() => {
            this.saving = false;
        });
    }

    get isLocked() {
        return getFieldValue(this.eval.data, LOCKED_FIELD);
    }

    get lockedVariant(){
        return this.isLocked? 'destructive' : 'brand';
    }
    get lockedLabel(){
        return this.saving ? 
        this.isLocked? 'Unlocking Evaluation' : 'Locking Evaluation' :    
        this.isLocked? 'Evaluation Locked' : 'Lock Evaluation';
    }

    get disableLockButton(){
        return !hasLockUnlockPermission;
    }
}