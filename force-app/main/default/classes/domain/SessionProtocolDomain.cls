/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 * Tests: test_SessionProtocolDomain, Test_SessionProtocolDomain
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
        System.debug('SESSION PROTOCOL BEFORE INSERT IS EXECUTING');
        Session_Protocol__c[] newProtocols = (Session_Protocol__c[]) request.newRecords;
        Session_Protocol__c[] sessionProtocolsForProcessing = new Session_Protocol__c[0];
        for(Session_Protocol__c sp : newProtocols){
            if(sp.Add_to_Plan__c == true){
                sessionProtocolsForProcessing.add(sp);
            }
        }
        ServiceRequest serviceRequest = new ServiceRequest();
        if (!sessionProtocolsForProcessing.isEmpty()) {

            System.debug('sessionProtocolsForProcessing: ' + sessionProtocolsForProcessing);

            serviceRequest.Action = 'beforeInsertHandler';
            serviceRequest.withParams('protocols', sessionProtocolsForProcessing);

            ServiceResponse serviceResponse = SessionProtocolService.processReq(serviceRequest);
            System.debug(serviceResponse);
        }
    }
    
    public void beforeUpdate (TriggerRequest request) {
        System.debug('SESSION PROTOCOL BEFORE UPDATE IS EXECUTING');
        Map<Id, Session_Protocol__c> newRecordMap = (Map<Id, Session_Protocol__c>) request.newRecordMap;
        Map<Id, Session_Protocol__c> oldRecordMap = (Map<Id, Session_Protocol__c>) request.oldRecordMap;

        List<Session_Protocol__c> sessionProtocolsForProcessing = new List<Session_Protocol__c>();
        Set<Id>skippedProtocolIds = new Set<Id>();
        for (Session_Protocol__c protocol : newRecordMap.values()) {
            Session_Protocol__c oldProtocol = oldRecordMap.get(protocol.Id);
            if(protocol.IsSkipped__c == true) {
                protocol.Preferred_Motivators__c = null;
                protocol.Overall_Score__c = null;
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

            if(protocol.IsRemoved__c == false) {
                if (oldProtocol.IsRemoved__c == true) {
                    sessionProtocolsForProcessing.add(protocol);
                }
            }            
        }
        ServiceRequest serviceRequest = new ServiceRequest();
        if (!sessionProtocolsForProcessing.isEmpty()) {

            System.debug('sessionProtocolsForProcessing: ' + sessionProtocolsForProcessing);

            serviceRequest.Action = 'beforeUpdateHandler';
            serviceRequest.withParams('protocols', sessionProtocolsForProcessing);

            ServiceResponse serviceResponse = SessionProtocolService.processReq(serviceRequest);
            System.debug(serviceResponse);
        }
    }

    public void beforeDelete (TriggerRequest request) { System.debug('SESSION PROTOCOL BEFORE DELETE IS EXECUTING'); }

    @SuppressWarnings('ApexUnresolvableReference')
    public void afterInsert(TriggerRequest request) {
        System.debug('SESSION PROTOCOL AFTER INSERT IS EXECUTING');
        Session_Protocol__c[] newProtocols = (Session_Protocol__c[]) request.newRecords;
        Session_Protocol__c[] sessionProtocolsForProcessing = new Session_Protocol__c[0];
        for(Session_Protocol__c sp : newProtocols){
            sessionProtocolsForProcessing.add(sp);
        }
        ServiceRequest serviceRequest = new ServiceRequest();
        if (!sessionProtocolsForProcessing.isEmpty()) {

            System.debug('sessionProtocolsForProcessing: ' + sessionProtocolsForProcessing);

            serviceRequest.Action = 'afterInsertHandler';
            serviceRequest.withParams('protocols', sessionProtocolsForProcessing);

            ServiceResponse serviceResponse = SessionProtocolService.processReq(serviceRequest);
            System.debug(serviceResponse);
        }

    }

    public void afterUpdate (TriggerRequest request) {
        System.debug('SESSION PROTOCOL AFTER UPDATE IS EXECUTING');
        Map<Id, Session_Protocol__c> newRecordMap = (Map<Id, Session_Protocol__c>) request.newRecordMap;
        Map<Id, Session_Protocol__c> oldRecordMap = (Map<Id, Session_Protocol__c>) request.oldRecordMap;

        List<Session_Protocol__c> sessionProtocolsForProcessing = new List<Session_Protocol__c>();
        Set<Id>skippedProtocolIds = new Set<Id>();
        for (Session_Protocol__c protocol : newRecordMap.values()) {
            Session_Protocol__c oldProtocol = oldRecordMap.get(protocol.Id);
            if(protocol.IsSkipped__c == true && oldProtocol.IsSkipped__c == false) {
                sessionProtocolsForProcessing.add(protocol);
            }
        }

        ServiceRequest serviceRequest = new ServiceRequest();
        if (!sessionProtocolsForProcessing.isEmpty()) {

            System.debug('sessionProtocolsForProcessing: ' + sessionProtocolsForProcessing);

            serviceRequest.Action = 'afterUpdateHandler';
            serviceRequest.withParams('protocols', sessionProtocolsForProcessing);

            ServiceResponse serviceResponse = SessionProtocolService.processReq(serviceRequest);
            System.debug(serviceResponse);
        }
    }
    
    public void afterDelete (TriggerRequest request) { System.debug('SESSION PROTOCOL AFTER INSERT IS EXECUTING'); }

}