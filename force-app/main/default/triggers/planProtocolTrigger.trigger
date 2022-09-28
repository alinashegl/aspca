/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

trigger planProtocolTrigger on Plan_Protocol__c (before insert, before update, before delete, after insert, after update, after
        delete, after undelete) {
    Trigger_Config__c config = Trigger_Config__c.getInstance();
    if (!config.Disable_Triggers__c) {
        TriggerRequest request = new TriggerRequest(Plan_Protocol__c.SObjectType);
        PlanProtocolDomain domain = new PlanProtocolDomain();
        System.debug('Trigger request ====> ' + request);
        domain.ProcessAction(request);
    }

}