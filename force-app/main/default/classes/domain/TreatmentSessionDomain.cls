/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentSessionDomain extends DomainActionBase {
    public override void ProcessAction(TriggerRequest request) {
        if (request.targetSObject == Treatment_Session__c.SObjectType) {
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
        System.debug('TREATMENT SESSION BEFORE INSERT IS EXECUTING');
    }


    public void beforeUpdate (TriggerRequest request)  {System.debug('TREATMENT SESSION BEFORE INSERT IS EXECUTING'); }
    public void beforeDelete (TriggerRequest request)  {System.debug('TREATMENT SESSION BEFORE INSERT IS EXECUTING'); }
    public void afterInsert (TriggerRequest request) {
        System.debug('TREATMENT SESSION AFTER INSERT IS EXECUTING');
        List<ServiceRequest> requestToSend = new List<ServiceRequest>();
        List<Treatment_Session__c> newRecords =  request.newRecords;
        TreatmentPlanSelector planSelector = new TreatmentPlanSelector();
        Set<Id> idsToQuery = new Set<Id>();
        for (Treatment_Session__c session : newRecords) {
            idsToQuery.add(session.Treatment_Plan__c);
        }
        Map<Id, Treatment_Plan__c> treatmentPlanMap = new Map<Id, Treatment_Plan__c>(planSelector.GetById(idsToQuery));
        for(Treatment_Session__c sess : newRecords) {
            Treatment_Plan__c plan = treatmentPlanMap.get(sess.Treatment_Plan__c);
            ServiceRequest serviceRequest = new ServiceRequest();
            serviceRequest.Name = 'Create New Session Protocols';
            serviceRequest.Action = 'beforeInsertHandler';
            serviceRequest.withParams('plan', plan);
            serviceRequest.withParams('session', sess);
            requestToSend.add(serviceRequest);
        }
        List<ServiceResponse> responses = SessionProtocolService.processRequest(requestToSend);
        for (ServiceResponse response : responses) {
            System.debug(response);
        }
    }

    @SuppressWarnings('ApexUnresolvableReference')
    public void afterUpdate(TriggerRequest request) { System.debug('TREATMENT SESSION BEFORE INSERT IS EXECUTING'); }
    public void afterDelete (TriggerRequest request)  {System.debug('TREATMENT SESSION BEFORE INSERT IS EXECUTING'); }

}