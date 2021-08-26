/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentPlanService {
    public static List<ServiceResponse> executeAll(List<ServiceRequest> requests) {
        List<ServiceResponse> responses = new List<ServiceResponse>();
        for (ServiceRequest request : requests) {
            responses.add(process(request));
        }
        return responses;
    }

    public static ServiceResponse process(ServiceRequest req) {
        switch on req.Action {
            when 'validateTreatmentPlan' {
                return handleValidity(req);
            } when 'bundleAssignmentChanged' {
                return bundleAssignmentChanged(req);
            } when 'newBundleAssigned' {
                return newBundleAssigned(req);
            }when else {
                return null;
            }
        }
    }

    private static ServiceResponse handleValidity(ServiceRequest request) {
        System.debug('Handle Validity of Treatment Plan Is Executing');
        ServiceResponse response = new ServiceResponse(request);
        return response;
    }
    //TODO: Correct Duplication of Records when bundle assignment is changed.
    private static ServiceResponse bundleAssignmentChanged(ServiceRequest request) {
        System.debug('Bundle Assignment Helper Is Executing');
        ServiceResponse response = new ServiceResponse(request);
        Opportunity newOpp = (Opportunity) request.Parameters.get('new');
        Opportunity oldOpp = (Opportunity) request.Parameters.get('old');

        Pricebook2 standard = [SELECT Id, Name, IsStandard FROM Pricebook2 WHERE IsStandard = TRUE];
        List<PricebookEntry> standardEntries = [SELECT Id, Product2Id, Pricebook2Id, Name
                                                FROM PricebookEntry
                                                WHERE Pricebook2Id =: standard.Id];
        Map<Id, PricebookEntry> standardEntryMap = new Map<Id, PricebookEntry>(standardEntries);
        Map<Id, Id> standardMap = new Map<Id, Id>();
        for (PricebookEntry entry : standardEntries) {
            standardMap.put(entry.Product2Id, entry.Id);
        }
        String oldBundleId = (String) request.Parameters.get('oldBundleId');
        String newBundleId = (String) request.Parameters.get('newBundleId');
        Pricebook2 oldBundle = [SELECT Id FROM Pricebook2 WHERE Id =: oldBundleId];
        Pricebook2 newBundle = [SELECT Id FROM Pricebook2 WHERE Id =: newBundleId];
        List<PricebookEntry> oldEntries = [SELECT Id, Product2Id, Pricebook2Id, Name  FROM PricebookEntry WHERE
                Pricebook2Id =: oldBundle.Id];
        List<PricebookEntry> newEntries = [SELECT Id, Product2Id, Pricebook2Id, Name FROM PricebookEntry WHERE
                Pricebook2Id =: newBundle.Id];
        Set<Id> oldProtocolIds = new Set<Id>();
        for (PricebookEntry entry : oldEntries) { oldProtocolIds.add(entry.Product2Id); }
        Set<Id> newProtocolId = new Set<Id>();
        for (PricebookEntry entry : newEntries) { newProtocolId.add(entry.Product2Id); }
        Map<Id, OpportunityLineItem> currentLineItems = getPlanProtocol(newOpp.Id);
        Map<Id, OpportunityLineItem> oldLineItems = getPlanProtocol(oldOpp.Id);

        Set<Id> netNewVals = new Set<Id>();
        for (Id n : newProtocolId) {
            if (!oldProtocolIds.contains(n)) {
                netNewVals.add(n);
            }
        }
        Set<Id> toDelete = new Set<Id>();
        for (Id n : oldProtocolIds) {
            if(!newProtocolId.contains(n)) {
                toDelete.add(n);
            }
        }
        List<OpportunityLineItem> lineItemsToDelete = new List<OpportunityLineItem>();
        Set<OpportunityLineItem> deDuplicate = new Set<OpportunityLineItem>();
        for (OpportunityLineItem item : currentLineItems.values()) {
            if (toDelete.contains(item.Product2Id)) {
                deDuplicate.add(item);
            }
        }
        List<OpportunityLineItem> lineItemsToCreate = new List<OpportunityLineItem>();
        for (PricebookEntry entry : standardEntries) {
            if (netNewVals.contains(entry.Product2Id)) {
                OpportunityLineItem item = new OpportunityLineItem();
                String key = standardMap.get(entry.Product2Id);
                PricebookEntry sEntry = standardEntryMap.get(key);
                item.OpportunityId = newOpp.Id;
                item.Product2Id = entry.Product2Id;
                item.PricebookEntryId = sEntry.Id;
                item.Quantity = 1;
                item.UnitPrice = 0.0;
                lineItemsToCreate.add(item);
            }
        }

        for (Integer n = 0 ; n < currentLineItems.size() ; n++) {
            OpportunityLineItem item = currentLineItems.values().get(n);
            OpportunityLineItem item2 = currentLineItems.values().get(currentLineItems.size() - 1);
            if (item.Name == item2.Name) {
                deDuplicate.add(item);
                currentLineItems.remove(item.Id);
            }
        }
        for (Integer n = 0 ; n < oldLineItems.size() ; n++) {
            OpportunityLineItem item = oldLineItems.values().get(n);
            OpportunityLineItem item2 = oldLineItems.values().get(currentLineItems.size() - 1);
            if (item.Name == item2.Name) {
                deDuplicate.add(item);
                oldLineItems.remove(item.Id);
            }
        }
        for (OpportunityLineItem item : lineItemsToDelete) {
            deDuplicate.add(item);
        }

        lineItemsToDelete.addAll(deDuplicate);
        Map<String, Object> Data = new Map<String, Object>();
        Map<String, Object> ERR = new Map<String, Object>();
        Data.put('Inserted', lineItemsToCreate);
        Data.put('Deleted', lineItemsToDelete);
        response.Data = Data;
        TriggerRequest triggerRequest = new TriggerRequest(OpportunityLineItem.getSObjectType())
                .SetAfter(true)
                .SetUpdate(true)
                .SetNewRecords(lineItemsToCreate)
                .SetOldRecords(new List<OpportunityLineItem>());
        ServiceRequest serviceRequest = new ServiceRequest().withParams('TriggerRequest',triggerRequest);
        PlanProtocolDomain domain = new PlanProtocolDomain();
        ServiceResponse rep = domain.Execute(serviceRequest);

        delete lineItemsToDelete;

        return response;
    }
    private static ServiceResponse newBundleAssigned(ServiceRequest request) {
        ServiceResponse response = new ServiceResponse(request);
        Opportunity opportunity = (Opportunity) request.Parameters.get('new');
        String newBundleId = (String) request.Parameters.get('newBundleId');

        Pricebook2 standard = [SELECT Id, Name, IsStandard FROM Pricebook2 WHERE IsStandard = TRUE];
        List<PricebookEntry> standardEntries = [SELECT Id, Product2Id, Pricebook2Id, Name FROM PricebookEntry WHERE Pricebook2Id =: standard.Id];
        Map<Id, PricebookEntry> standardEntryMap = new Map<Id, PricebookEntry>(standardEntries);
        Map<Id, Id> standardMap = new Map<Id, Id>();
        for (PricebookEntry entry : standardEntries) {
            standardMap.put(entry.Product2Id, entry.Id);
        }
        Pricebook2 book = [SELECT Id from Pricebook2 WHERE Id =: newBundleId];
        List<PricebookEntry> entries = [SELECT Id, Product2Id, Pricebook2Id, Name FROM PricebookEntry WHERE
                Pricebook2Id =: book.Id];
        List<OpportunityLineItem> newLineItems = new List<OpportunityLineItem>();
        for (PricebookEntry entry : entries) {
            String key = standardMap.get(entry.Product2Id);
            PricebookEntry sEntry = standardEntryMap.get(key);
            OpportunityLineItem item = new OpportunityLineItem();
            item.OpportunityId = opportunity.Id;
            item.Product2Id = key;
            item.PricebookEntryId = sEntry.Id;
            item.UnitPrice = 0.0;
            newLineItems.add(item);
        }
        TriggerRequest triggerRequest = new TriggerRequest(OpportunityLineItem.getSObjectType())
                .SetBefore(true)
                .SetUpdate(true)
                .SetNewRecords(newLineItems)
                .SetOldRecords(new List<OpportunityLineItem>());
        ServiceRequest serviceRequest = new ServiceRequest().withParams('TriggerRequest',triggerRequest);
        PlanProtocolDomain domain = new PlanProtocolDomain();
        ServiceResponse rep = domain.Execute(serviceRequest);
        rep.Data = triggerRequest.newRecords;

        return rep;
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