/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

trigger sessionProtocolTrigger on Session_Protocol__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Trigger_Config__c config = Trigger_Config__c.getInstance();
    if (!config.Disable_Triggers__c) {
        TriggerRequest request = new TriggerRequest(Session_Protocol__c.SObjectType);
        SessionProtocolDomain domain = new SessionProtocolDomain();
        domain.ProcessAction(request);
    }
}