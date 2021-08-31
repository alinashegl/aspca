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
        Map<Id, PricebookEntry> newProtocols = new Map<Id, PricebookEntry>();
        for (PricebookEntry entry : newEntries) {
            newProtocols.put(entry.Product2Id, entry);
        }
        Map<Id, OpportunityLineItem> currentLineItems = getPlanProtocol(newOpp.Id);
        List<OpportunityLineItem> lineItemsToDelete = new List<OpportunityLineItem>();
        for (OpportunityLineItem item : currentLineItems.values()) {
            if(newProtocols.keySet().contains(item.Product2Id) != false) {
                lineItemsToDelete.add(item);
            }
        }
        Set<PricebookEntry> entrySet = new Set<PricebookEntry>();
        for (OpportunityLineItem item : currentLineItems.values()) {
            for (PricebookEntry entry : newProtocols.values()) {
                if (entry.Product2Id != item.Product2Id) {
                    entrySet.add(entry);
                }
            }
        }
        List<OpportunityLineItem> toCreate = new List<OpportunityLineItem>();
        for (PricebookEntry entry : entrySet) {
            OpportunityLineItem item = new OpportunityLineItem();
            item.PricebookEntry = standardEntryMap.get(entry.Product2Id);
            item.OpportunityId = newOpp.Id;
            item.Product2Id = entry.Product2Id;
            item.UnitPrice = 0.0;
            toCreate.add(item);
        }
        if (toCreate.size() > 0) {
            try {
                insert toCreate;
            }catch(Exception e) {
                System.debug(e);
            }
        }
        if (lineItemsToDelete.size() > 1) {
            try {
                delete lineItemsToDelete;
            }catch (Exception e) {
                System.debug(e);
            }

        }
        Map<String, Object> Data = new Map<String, Object>();
        Data.put('Created', toCreate);
        Data.put('Deleted', lineItemsToDelete);
        response.Data = Data;
        return response;
    }
    private static ServiceResponse newBundleAssigned(ServiceRequest request) {
        System.debug('NEW BUNDLE ASSIGNMENT IS EXECUTING');
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