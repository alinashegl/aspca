/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentPlanDomain extends DomainActionBase{
    public override void ProcessAction(TriggerRequest request) {
        if (request.targetSObject == Opportunity.SObjectType) {
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

    public void beforeInsert(TriggerRequest request) {
        System.debug('Before Insert is Executing');
        List<Opportunity> newRecords = request.newRecords;

        Map<Id, Opportunity> newRecordMap = (Map<Id, Opportunity>) request.newRecordMap;

        for (Opportunity plan : newRecords) {
            Animal__c animal = [SELECT Id, Case__c, Discharged_to_Agency__c  FROM Animal__c WHERE Id =: plan.Animal__c];
            plan.AccountId = animal.Discharged_to_Agency__c != null ? animal.Discharged_to_Agency__c : null;
            if (plan.AccountId == null) { System.debug('No AGENCY FOUND'); }
        }

        //if (newRecords != null) { update newRecords; }

        //if (newRecordMap != null) { update newRecordMap.values(); }

    }
    public void beforeUpdate(TriggerRequest request) {

        System.debug('Before Update is Executing');
        List<Opportunity> newRecords = request.newRecords;
        List<Opportunity> oldRecords = request.oldRecords;

        Map<Id, Opportunity> newRecordMap = (Map<Id, Opportunity>) request.newRecordMap;
        Map<Id, Opportunity> oldRecordMap = (Map<Id, Opportunity>) request.oldRecordMap;

        if (oldRecords != null) {

        }
        if (newRecords != null) {
            update newRecords;
        }
        if (oldRecordMap != null) {

        }
        if(newRecordMap != null) {
            update newRecordMap.values();
        }


    }
    public void beforeDelete(TriggerRequest request) {
        System.debug('Before Delete is Executing');
    }
    public void afterInsert(TriggerRequest request) {
        System.debug('After Insert is Executing');
    }
    public void afterUpdate(TriggerRequest request) {
        System.debug('After Update is Executing');
        List<Opportunity> newRecords = request.newRecords;
        List<Opportunity> oldRecords = request.oldRecords;

        Map<Id, Opportunity> newRecordMap = (Map<Id, Opportunity>) request.newRecordMap;
        Map<Id, Opportunity> oldRecordMap = (Map<Id, Opportunity>) request.oldRecordMap;
        Map<Id, OpportunityLineItem> oldLineItems = new Map<Id, OpportunityLineItem>();
        if (oldRecords != null) { }
        if (newRecords != null) {   }
        if (oldRecordMap != null) { }
        if(newRecordMap != null) { }
    }
    public void afterDelete(TriggerRequest request) {
        System.debug('After Delete is Executing');
    }

    private static Map<Id, OpportunityLineItem> getPlanProtocol(Id opp) {
        PlanProtocolSelector selector = new PlanProtocolSelector();

        List<OpportunityLineItem> lineItems = selector.GetByOpp(opp);
        Map<Id, OpportunityLineItem> idOpportunityLineItemMap  = new Map<Id, OpportunityLineItem>();
        for (OpportunityLineItem item : lineItems) {
            idOpportunityLineItemMap.put(item.Id, item);
        }
        return idOpportunityLineItemMap;
    }
}