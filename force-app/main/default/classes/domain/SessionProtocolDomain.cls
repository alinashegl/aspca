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

    @SuppressWarnings('ApexUnresolvableReference')
    public void beforeInsert(TriggerRequest request) {
        /*
        System.debug('SESSION PROTOCOL BEFORE INSERT IS EXECUTING');

        Map<Id, Session_Protocol__c> newRecordMap = (Map<Id, Session_Protocol__c>) request.newRecordMap;
        Set<Id> idsToQuery = new Set<Id>();
        for (Session_Protocol__c sessionProtocol : newRecordMap.values()) {
            idsToQuery.add(sessionProtocol.TreatmentSessionId__c);
        }
        TreatmentSessionSelector sessionSelector = new TreatmentSessionSelector();
        Map<Id, Treatment_Session__c> treatmentSessionMap =  new Map<Id, Treatment_Session__c>();
        List<Treatment_Session__c> sesslist = sessionSelector.queryById(idsToQuery);
        treatmentSessionMap.putAll(sesslist);

        for (Session_Protocol__c protocol : newRecordMap.values()) {
            Treatment_Session__c session = treatmentSessionMap.get(protocol.TreatmentSessionId__c);

            if (session.Preferred_Motivators__c != null) {
                protocol.Preferred_Motivators__c = session.Preferred_Motivators__c;
            }
        }
         */
    }
    public void beforeUpdate (TriggerRequest request) {
        System.debug('SESSION PROTOCOL BEFORE UPDATE IS EXECUTING');
        Map<Id, Session_Protocol__c> newRecordMap = (Map<Id, Session_Protocol__c>) request.newRecordMap;
        Map<Id, Session_Protocol__c> oldRecordMap = (Map<Id, Session_Protocol__c>) request.oldRecordMap;

        List<Session_Protocol__c> sessionProtocolsForProcessing = new List<Session_Protocol__c>();
        for (Session_Protocol__c protocol : newRecordMap.values()) {
            Session_Protocol__c oldProtocol = oldRecordMap.get(protocol.Id);
            if(protocol.IsSkipped__c == true) {
                protocol.Preferred_Motivators__c = '';
                protocol.Arousal_Best__c = 'None';
                protocol.Arousal_Worst__c = 'None';
                protocol.Fear_Best__c = 'None';
                protocol.Fear_Worst__c = 'None';
                protocol.Social_Best__c = 'None';
                protocol.Aggressive_Worst__c = 'None';
                protocol.Overall_Score__c = 'None';
            }
            if (protocol.Add_to_Plan__c == true) {

                if (oldProtocol.Add_to_Plan__c == false) {
                    sessionProtocolsForProcessing.add(protocol);
                }
            }
            if(protocol.IsRemoved__c == true) {
                if (oldProtocol.IsRemoved__c == false) {
                    sessionProtocolsForProcessing.add(protocol);
                }
            }
        }
        ServiceRequest serviceRequest = new ServiceRequest();
        if (sessionProtocolsForProcessing.size() > 1 ) {

            serviceRequest.Action = 'beforeUpdateHandler';
            serviceRequest.withParams('protocols', sessionProtocolsForProcessing);

            ServiceResponse serviceResponse = SessionProtocolService.processReq(serviceRequest);
            System.debug(serviceResponse);
        }


    }
    public void beforeDelete (TriggerRequest request) { System.debug('SESSION PROTOCOL BEFORE DELETE IS EXECUTING'); }
    public void afterInsert (TriggerRequest request) { System.debug('SESSION PROTOCOL AFTER INSERT IS EXECUTING'); }
    public void afterUpdate (TriggerRequest request) {
        System.debug('SESSION PROTOCOL AFTER INSERT IS EXECUTING');
        Map<Id, Session_Protocol__c> newRecordMap = (Map<Id, Session_Protocol__c>) request.newRecordMap;

    }
    public void afterDelete (TriggerRequest request) { System.debug('SESSION PROTOCOL AFTER INSERT IS EXECUTING'); }

}