/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

trigger treatmentSessionTrigger on Treatment_Session__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Trigger_Config__c config = Trigger_Config__c.getInstance();
    if (!config.Disable_Triggers__c) {
        TriggerRequest request = new TriggerRequest(Treatment_Session__c.SObjectType);
        TreatmentSessionDomain domain = new TreatmentSessionDomain();
        domain.ProcessAction(request);
       RollUpCountHandler rollup = new RollUpCountHandler();
       rollup.ProcessAction(request);
    }
}