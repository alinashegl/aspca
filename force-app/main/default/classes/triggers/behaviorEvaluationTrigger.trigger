/**
 * Created by barne on 4/29/2021.
 */

trigger behaviorEvaluationTrigger on Behavior_Evaluation__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    Trigger_Config__c config = Trigger_Config__c.getInstance();
    if ( config.Disable_Triggers__c == false) {
        TriggerRequest request = new TriggerRequest(Behavior_Evaluation__c.SObjectType);
        TreatmentPlanDomain domain = new TreatmentPlanDomain();
        domain.ProcessAction(request);
    }
}