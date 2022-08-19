public with sharing class SessionProtocolScaleDomain extends DomainActionBase {
    public override void ProcessAction(TriggerRequest request) {
        if (request.targetSObject == Session_Protocol_Scale__c.SObjectType) {
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

    @SuppressWarnings('ApexUnresolvableReference')
    public void beforeInsert(TriggerRequest request) {
        System.debug('SESSION PROTOCOL SCALE BEFORE INSERT IS EXECUTING');
    }
    
    public void beforeUpdate (TriggerRequest request) {
        System.debug('SESSION PROTOCOL SCALE BEFORE UPDATE IS EXECUTING');
        Session_Protocol_Scale__c[] newRecords = (Session_Protocol_Scale__c[]) request.newRecords;
        Map<Id, Session_Protocol_Scale__c> oldMap = (Map<Id, Session_Protocol_Scale__c>) request.oldRecordMap;
        //need to update the overall score field on the session protocol if it was updated
        // Session_Protocol__c[] sProtocols = new Session_Protocol__c[0];
        Map<Id, Session_Protocol__c> sProtocolMap = new Map<Id, Session_Protocol__c>();
        for(Session_Protocol_Scale__c sps : newRecords){
            Session_Protocol_Scale__c oldRecord = oldMap.get(sps.Id);
            if(sps.Protocol_Scale_Name__c == 'Overall Score' && sps.Protocol_Score__c != oldRecord.Protocol_Score__c){
                System.debug('**sps: ' + sps);
                if(sProtocolMap.containsKey(sps.Session_Protocol__c)){
                    sProtocolMap.get(sps.Session_Protocol__c).Overall_Score__c = sps.Protocol_Score__c;
                } else {
                    Session_Protocol__c sProtocol = new Session_Protocol__c(
                        Id = sps.Session_Protocol__c,
                        Overall_Score__c = sps.Protocol_Score__c
                    );
                    sProtocolMap.put(sps.Session_Protocol__c, sProtocol);
                }
            }
        }

        update sProtocolMap.values();
        System.debug('sProtocolMap: ' + sProtocolMap);
    }

    public void beforeDelete (TriggerRequest request) { 
        System.debug('SESSION PROTOCOL SCALE BEFORE DELETE IS EXECUTING'); 
    }

    @SuppressWarnings('ApexUnresolvableReference')
    public void afterInsert(TriggerRequest request) {
        System.debug('SESSION PROTOCOL SCALE AFTER INSERT IS EXECUTING');
    }

    public void afterUpdate (TriggerRequest request) {
        System.debug('SESSION PROTOCOL SCALE AFTER UPDATE IS EXECUTING');
    }
    public void afterDelete (TriggerRequest request) { System.debug('SESSION PROTOCOL SCALE AFTER INSERT IS EXECUTING'); }
}