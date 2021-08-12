/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentPlanService {
    public void executeAll(List<ServiceRequest> requests) {
        for (ServiceRequest request : requests) {
            process(request);
            ServiceResponse response = new ServiceResponse(request);
            System.debug('executed request + ' + request);
        }

    }
    public void process(ServiceRequest req) {
        switch on req.Action {
            when 'validateTreatmentPlan' {
                handleValidity(req);
            } when 'bundleAssignmentChanged' {
                bundleAssignmentChanged(req);
            }
        }
    }

    private static ServiceResponse handleValidity(ServiceRequest request) {
        System.debug('Handle Validity of Treatment Plan Is Executing');
        ServiceResponse response = new ServiceResponse(request);
        return response;
    }

    private static ServiceResponse bundleAssignmentChanged(ServiceRequest request) {
        System.debug('Bundle Assignment Helper Is Executing');
        ServiceResponse response = new ServiceResponse(request);
        Opportunity newOpp = (Opportunity) request.Parameters.get('new');
        Opportunity oldOpp = (Opportunity) request.Parameters.get('old');

        Pricebook2 book = [SELECT id, name from Pricebook2 where id =: newOpp.Assigned_Treatment_Bundle__c];
        List<PricebookEntry> entries = [SELECT Id, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Pricebook2Id =:
                book.Id];
        Pricebook2 standard = [SELECT Id, Name, IsStandard from Pricebook2 WHERE IsStandard = TRUE];
        Set<Id> keyset = new Set<Id>();
        for (PricebookEntry entry : entries) {
            keyset.add(entry.Id);
        }
        if (!getPlanProtocol(newOpp.Id).isEmpty()) {
            Map<Id, OpportunityLineItem> newLineItems = getPlanProtocol(newOpp.Id);
            Map<Id, OpportunityLineItem> protocolsNotInBundle = new Map<Id, OpportunityLineItem>();
            for (OpportunityLineItem item : newLineItems.values()) {
                if (!keyset.contains(item.PricebookEntryId)) {
                    protocolsNotInBundle.put(item.Id, item);
                }
                System.debug(item.PricebookEntryId);
            }
            if (!protocolsNotInBundle.isEmpty()) {
                for (OpportunityLineItem item : protocolsNotInBundle.values()) {
                    newLineItems.remove(item.Id);
                }
            }
            TriggerRequest triggerRequest = new TriggerRequest(OpportunityLineItem.getSObjectType())
                    .SetBefore(true)
                    .SetDelete(true)
                    .SetNewRecords(protocolsNotInBundle.values());
            ServiceRequest req = new ServiceRequest().withParams('TriggerRequest', triggerRequest);
            PlanProtocolDomain domain = new PlanProtocolDomain();
            ServiceResponse resp = domain.Execute(req);
            resp.Data = triggerRequest.newRecords;

            TriggerRequest request2 = new TriggerRequest(OpportunityLineItem.getSObjectType())
                    .SetBefore(true)
                    .SetInsert(true)
                    .SetNewRecords(newLineItems.values());
            ServiceRequest req2 = new ServiceRequest().withParams('TriggerRequest', request2);
            ServiceResponse resp2 = domain.Execute(req2);
            resp2.Data = request2.newRecords;
            System.debug('PLAN PROTOCOL REQUEST ===> ' + resp2);


            return resp;

        }else {
            List<OpportunityLineItem> nLineItems = new List<OpportunityLineItem>();
            Map<Id, Id> standardMap = new Map<Id, Id>();
            List<PricebookEntry> sEntries = [SELECT Id, Product2Id, Pricebook2Id FROM PricebookEntry
            WHERE Pricebook2Id =: standard.Id];
            for (PricebookEntry entry : sEntries) {
                standardMap.put(entry.Product2Id, entry.Id);
            }
            for (PricebookEntry entry : entries) {
                System.debug(entry);
                OpportunityLineItem item = new OpportunityLineItem();
                item.OpportunityId = newOpp.Id;
                item.PricebookEntryId = standardMap.get(entry.Product2Id);
                item.Product2Id = entry.Product2Id;
                item.UnitPrice = 0.0;
                item.Discount = 0.0;
                item.Quantity = 1.0;
                System.debug('ITEM =====> ' + item.PricebookEntryId);
                nLineItems.add(item);
            }
            TriggerRequest iRequest = new TriggerRequest(OpportunityLineItem.getSObjectType())
                .SetBefore(true)
                .SetInsert(true)
                .SetNewRecords(nLineItems);
            ServiceRequest req = new ServiceRequest().withParams('TriggerRequest', iRequest);
            PlanProtocolDomain domain = new PlanProtocolDomain();
            ServiceResponse resp = domain.Execute(req);
            resp.Data = iRequest.newRecords;
            System.debug('PLAN PROTOCOL REQUEST ===> ' + resp);
            return resp;

        }
    }
    private static Map<Id, OpportunityLineItem> getPlanProtocol(Id opp) {
        PlanProtocolSelector selector = new PlanProtocolSelector();

        List<OpportunityLineItem> lineItems = selector.GetByOpp(opp);
        if (lineItems.isEmpty()) {System.debug('NO LINE ITEMS FOUND'); return new Map<Id, OpportunityLineItem>(); }
        else {
            Map<Id, OpportunityLineItem> idOpportunityLineItemMap  = new Map<Id, OpportunityLineItem>();
            idOpportunityLineItemMap.putAll(lineItems);
            return idOpportunityLineItemMap;
        }

    }


}