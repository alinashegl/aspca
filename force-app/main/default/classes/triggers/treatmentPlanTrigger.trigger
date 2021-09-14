/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

trigger treatmentPlanTrigger on Treatment_Plan__c (before insert, before update, before delete, after insert, after update, after
        delete, after undelete) {
    Trigger_Config__c config = Trigger_Config__c.getInstance();
    if (!config.Disable_Triggers__c) {
        TriggerRequest request = new TriggerRequest(Treatment_Plan__c.SObjectType);
        TreatmentPlanDomain domain = new TreatmentPlanDomain();
        domain.ProcessAction(request);
    }

}