/**
 * Created by barne on 4/29/2021.
 */

trigger behaviorEvaluationTrigger on Behavior_Evaluation__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    Trigger_Config__c config = Trigger_Config__c.getInstance();
    if (config != null && config.Behavior_Evaluation_Trigger_Enabled__c == true) {
        //System.debug('## Running BehaviorEvaluationTrigger ####');
        //trigger_Controller.getInstance().process(Behavior_Evaluation__c.SObjectType);
    }
}