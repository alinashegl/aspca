/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class SessionProtocolDomain extends DomainActionBase {
    public override void ProcessAction(TriggerRequest request) {
        if (request.targetSObject == Session_Protocol__c.SObjectType) {
            String triggerAction = request.action + request.process;

            switch on triggerAction {
                when 'BeforeInsert' { beforeInsert(request); }
                when 'BeforeUpdate' { beforeUpdate(request); }
                when 'BeforeDelete' { beforeDelete(request);}
                when 'AfterInsert' { afterInsert(request);}
                when 'AfterUpdate' { afterUpdate(request);}
                when 'AfterDelete' { afterDelete(request);}
            }
        }
        return;
    }

    public void beforeInsert (TriggerRequest request) {System.debug('SESSION PROTOCOL BEFORE INSERT IS EXECUTING'); }
    public void beforeUpdate (TriggerRequest request) {
        System.debug('SESSION PROTOCOL BEFORE UPDATE IS EXECUTING');
        Map<Id, Session_Protocol__c> newRecordMap = (Map<Id, Session_Protocol__c>) request.newRecordMap;

        for (Session_Protocol__c protocol : newRecordMap.values()) {
            if(protocol.IsSkipped__c == true) {
                protocol.Preferred_Motivators__c = '';
                protocol.Arousal_Best__c = 'None';
                protocol.Arousal_Worst__c = 'None';
                protocol.Fear_Best__c = 'None';
                protocol.Fear_Worst__c = 'None';
                protocol.Social_Best__c = 'None';
                protocol.Aggressive_Worst__c = 'None';
            }
        }
    }
    public void beforeDelete (TriggerRequest request) { System.debug('SESSION PROTOCOL BEFORE DELETE IS EXECUTING'); }
    public void afterInsert (TriggerRequest request) { System.debug('SESSION PROTOCOL AFTER INSERT IS EXECUTING'); }
    public void afterUpdate (TriggerRequest request) { System.debug('SESSION PROTOCOL AFTER INSERT IS EXECUTING'); }
    public void afterDelete (TriggerRequest request) { System.debug('SESSION PROTOCOL AFTER INSERT IS EXECUTING'); }

}