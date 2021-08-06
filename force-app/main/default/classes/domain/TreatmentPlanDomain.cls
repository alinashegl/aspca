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
        TreatmentBundleSelector bundleSelector = new TreatmentBundleSelector();
        List<Opportunity> newRecords = request.newRecords;
        List<Opportunity> oldRecords = request.oldRecords;

        Map<Id, Opportunity> newRecordMap = (Map<Id, Opportunity>) request.newRecordMap;
        Map<Id, Opportunity> oldRecordMap = (Map<Id, Opportunity>) request.oldRecordMap;
        Map<Id, OpportunityLineItem> oldLineItems = new Map<Id, OpportunityLineItem>();

        for (Opportunity opportunity : newRecordMap.values()) {
            if (!opportunity.Assigned_Treatment_Bundle__c.equals(null)) {
                Opportunity oldOpp = oldRecordMap.get(opportunity.Id);
                Map<Id, Product2> bundle = (Map<Id, Product2>) bundleSelector.GetById((Set<Id>) opportunity.Assigned_Treatment_Bundle__c);
                Map<Id, OpportunityLineItem> oldLineItems = getPlanProtocol(oldOpp.Id);
                Map<Id, OpportunityLineItem> newLineItems = getPlanProtocol(opportunity.Id);
            }
        }
    }
    public void afterDelete(TriggerRequest request) {
        System.debug('After Delete is Executing');
    }

    private static Map<Id, OpportunityLineItem> getPlanProtocol(Id opp) {
        PlanProtocolSelector selector = new PlanProtocolSelector();

        List<OpportunityLineItem> lineItems = selector.GetByOpp(opp);
        Map<Id, OpportunityLineItem> idOpportunityLineItemMap  = new Map<Id, OpportunityLineItem>();
        idOpportunityLineItemMap.putAll(lineItems);
        return idOpportunityLineItemMap;
    }
    private static Map<Id, Product2> GetProtocolsByLineItem(List<OpportunityLineItem> val) {
        ProtocolSelector selector = new ProtocolSelector();
        Map<Id, Product2> protocolmap = new Map<Id, Product2>();
        Set<Id> keys = new Set<Id>();
        for (OpportunityLineItem item : val) {
            keys.add(item.Product2Id);
        }
        List<Product2> product2s = selector.GetById(keys);
        protocolmap.putAll(product2s);
        return protocolmap;
    }

    private static Opportunity protocolChecker(Opportunity object, Map<Id, OpportunityLineItem> oldMap, Map<Id, OpportunityLineItem>
            newMap, Map<Id, Product2> bundleMap) {
        try {
            Integer count = bundleMap.size();
            Integer index = 0;

        }catch (Exception e) {
            System.debug(e);
        }
    }
}