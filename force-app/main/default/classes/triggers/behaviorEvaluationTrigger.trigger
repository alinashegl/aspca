/**
 * Created by barne on 4/29/2021.
 */

trigger behaviorEvaluationTrigger on Behavior_Evaluation__c (before insert, before update) {
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            BehaviorEvaluationSummaryUtil.handleInsert(Trigger.new);
        }
        else if (Trigger.isUpdate) {
            BehaviorEvaluationSummaryUtil.handleUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}