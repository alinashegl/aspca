/**
 * Created by barne on 4/29/2021.
 */

trigger behaviorEvaluationTrigger on Behavior_Evaluation__c (before insert, after insert, before update,after update) {
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            BehaviorEvaluationSummaryUtil.handleInsert(Trigger.new);
        }
        else if (Trigger.isUpdate) {
            BehaviorEvaluationSummaryUtil.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            BehaviorEvaluationSummaryUtil.handleAfterInsert(Trigger.new);
        } 
        else if(Trigger.isUpdate){
            BehaviorEvaluationSummaryUtil.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}