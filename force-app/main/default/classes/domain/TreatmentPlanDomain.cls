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
            Pricebook2 standard = [SELECT Id, Name, IsStandard from Pricebook2 where IsStandard = TRUE];
            plan.Pricebook2Id = standard.Id;
        }

        //if (newRecords != null) { update newRecords; }

        //if (newRecordMap != null) { update newRecordMap.values(); }

    }
    public static void beforeUpdate(TriggerRequest request) {

        //System.debug(' Treatment Plan Before Update is Executing');


    }
    public void beforeDelete(TriggerRequest request) {
        //System.debug('Before Delete is Executing');
    }
    public void afterInsert(TriggerRequest request) {
        //System.debug('After Insert is Executing');
    }
    public static void afterUpdate(TriggerRequest request) {
        List<Opportunity> newRecords = request.newRecords;
        List<Opportunity> oldRecords = request.oldRecords;

        Map<Id, Opportunity> newRecordMap = (Map<Id, Opportunity>) request.newRecordMap;
        Map<Id, Opportunity> oldRecordMap = (Map<Id, Opportunity>) request.oldRecordMap;
        List<ServiceRequest> requests = new List<ServiceRequest>();
        //TreatmentPlanService service = new TreatmentPlanService();

        List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
        for (Opportunity opportunity : newRecordMap.values()) {
            String newVal = opportunity.Assigned_Treatment_Bundle__c;
            System.debug(newVal);
            if ( newVal != null ){
                Opportunity oldOpp = oldRecordMap.get(opportunity.Id);
                //System.debug('#### OLD OPP ====> ' + oldOpp);
                String oldVal = oldOpp.Assigned_Treatment_Bundle__c;
                System.debug(oldVal);
                if (oldVal != null && oldVal != newVal) {
                    System.debug('Old Value Is NOT Null');
                    ServiceRequest serviceRequest = new ServiceRequest();
                    serviceRequest.Name = 'Bundle Assignment Change';
                    serviceRequest.Action = 'bundleAssignmentChanged';
                    serviceRequest.withParams('old', oldOpp);
                    serviceRequest.withParams('oldBundleId', oldVal);
                    serviceRequest.withParams('new', opportunity);
                    serviceRequest.withParams('newBundleId', newVal);
                    //System.debug('Sending Request for: ' + opportunity.Name + ' ====> ' + serviceRequest);
                    requests.add(serviceRequest);
                }
                if(oldVal == null){
                    ServiceRequest serviceRequest = new ServiceRequest();
                    serviceRequest.Name = 'New Bundle Assignment';
                    serviceRequest.Action = 'newBundleAssigned';
                    serviceRequest.withParams('old', oldOpp);
                    serviceRequest.withParams('new', opportunity);
                    serviceRequest.withParams('newBundleId', newVal);
                    requests.add(serviceRequest);

                }
            }
        }
        if (requests.size() > 0) {
            List<ServiceResponse> responses = TreatmentPlanService.executeAll(requests);
            for (ServiceResponse response : responses) {
                System.debug(responses);
            }
        }

        //System.debug('After Update is Executing');
    }
    public void afterDelete(TriggerRequest request) {
        //System.debug('After Delete is Executing');
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
}