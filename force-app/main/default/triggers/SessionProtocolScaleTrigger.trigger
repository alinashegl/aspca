trigger SessionProtocolScaleTrigger on Session_Protocol_Scale__c(before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Trigger_Config__c config = Trigger_Config__c.getInstance();
    if (!config.Disable_Triggers__c) {
        TriggerRequest request = new TriggerRequest(Session_Protocol_Scale__c.SObjectType);
        SessionProtocolScaleDomain domain = new SessionProtocolScaleDomain();
        domain.ProcessAction(request);
    }
}