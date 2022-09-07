/**
 * 
 * Trigger Description
 *
 * @author Neha
 * @version 1.0.0
 */
trigger ProtocolTrigger on Protocol__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Trigger_Config__c config = Trigger_Config__c.getInstance();
    if (!config.Disable_Triggers__c) {
        TriggerRequest request = new TriggerRequest(Protocol__c.SObjectType);        
        ProtocolDomain objProtocolTriggerHandler = new ProtocolDomain();
       objProtocolTriggerHandler.ProcessAction(request);

    }
}