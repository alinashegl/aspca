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
            }when 'assignPlan' {
                return assignPlan(req);
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
    //TODO: Correct Duplication of Records when bundle assignment is changed. This was originally done using the
    // PricebookEntry object, and the move to new sObjects created this bug. Should be able to fix it from here
    private static ServiceResponse bundleAssignmentChanged(ServiceRequest request) {
        System.debug('Bundle Assignment Helper Is Executing');
        ServiceResponse response = new ServiceResponse(request);
        Treatment_Plan__c newOpp = (Treatment_Plan__c) request.Parameters.get('new');
        Treatment_Plan__c oldOpp = (Treatment_Plan__c) request.Parameters.get('old');

        Treatment_Bundle__c standard = [SELECT Id, Name,  IsMaster__c FROM Treatment_Bundle__c WHERE IsMaster__c = TRUE];
        List<Bundle_Entry__c> standardEntries = [SELECT Id, Treatment_Bundle__c, Protocol__c, Name
                                                FROM Bundle_Entry__c
                                                WHERE Treatment_Bundle__c =: standard.Id];
        Map<Id, Bundle_Entry__c> standardEntryMap = new Map<Id, Bundle_Entry__c>(standardEntries);
        Map<Id, Id> standardMap = new Map<Id, Id>();
        for (Bundle_Entry__c entry : standardEntries) {
            standardMap.put(entry.Protocol__c, entry.Id);
        }
        String oldBundleId = (String) request.Parameters.get('oldBundleId');
        String newBundleId = (String) request.Parameters.get('newBundleId');
        Treatment_Bundle__c oldBundle = [SELECT Id FROM Treatment_Bundle__c WHERE Id =: oldBundleId];
        Treatment_Bundle__c newBundle = [SELECT Id FROM Treatment_Bundle__c WHERE Id =: newBundleId];
        List<Bundle_Entry__c> oldEntries = [SELECT Id, Protocol__c, Treatment_Bundle__c, Name  FROM Bundle_Entry__c WHERE
                Treatment_Bundle__c =: oldBundle.Id];
        List<Bundle_Entry__c> newEntries = [SELECT Id, Protocol__c, Treatment_Bundle__c, Name FROM Bundle_Entry__c WHERE
                Treatment_Bundle__c =: newBundle.Id];
        Map<Id, Bundle_Entry__c> newProtocols = new Map<Id, Bundle_Entry__c>();
        for (Bundle_Entry__c entry : newEntries) {
            newProtocols.put(entry.Protocol__c, entry);
        }
        Map<Id, Plan_Protocol__c> currentLineItems = getPlanProtocol(newOpp.Id);
        List<Plan_Protocol__c> lineItemsToDelete = new List<Plan_Protocol__c>();
        for (Plan_Protocol__c item : currentLineItems.values()) {
            if(newProtocols.keySet().contains(item.Protocol__c) != false) {
                lineItemsToDelete.add(item);
            }
        }
        Set<Bundle_Entry__c> entrySet = new Set<Bundle_Entry__c>();
        for (Plan_Protocol__c item : currentLineItems.values()) {
            for (Bundle_Entry__c entry : newProtocols.values()) {
                if (entry.Protocol__c != item.Protocol__c) {
                    entrySet.add(entry);
                }
            }
        }
        List<Plan_Protocol__c> toCreate = new List<Plan_Protocol__c>();
        for (Bundle_Entry__c entry : entrySet) {
            Plan_Protocol__c item = new Plan_Protocol__c();
            Bundle_Entry__c bundleEntry = standardEntryMap.get(entry.Protocol__c);
            //item.Bundle_Entry__c = bundleEntry.Id;
            item.Treatment_Plan__c = newOpp.Id;
            item.Protocol__c = entry.Protocol__c;
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

        Treatment_Plan__c opportunity = (Treatment_Plan__c) request.Parameters.get('new');
        String newBundleId = (String) request.Parameters.get('newBundleId');

        Treatment_Bundle__c standard = [SELECT Id, Name,  IsMaster__c FROM Treatment_Bundle__c WHERE IsMaster__c =
                TRUE LIMIT 1 ];
        List<Bundle_Entry__c> standardEntries = [SELECT Id, Treatment_Bundle__c, Protocol__c, Name
        FROM Bundle_Entry__c
        WHERE Treatment_Bundle__c =: standard.Id];
        Map<Id, Bundle_Entry__c> standardEntryMap = new Map<Id, Bundle_Entry__c>(standardEntries);
        Map<Id, Id> standardMap = new Map<Id, Id>();
        for (Bundle_Entry__c entry : standardEntries) {
            standardMap.put(entry.Protocol__c, entry.Id);
        }
        Treatment_Bundle__c book = [SELECT Id from Treatment_Bundle__c WHERE Id =: newBundleId];
        List<Bundle_Entry__c> entries = [SELECT Id, Protocol__c, Treatment_Bundle__c, Name FROM Bundle_Entry__c WHERE
                Treatment_Bundle__c =: book.Id];
        List<Plan_Protocol__c> newLineItems = new List<Plan_Protocol__c>();
        for (Bundle_Entry__c entry : entries) {
            String key = standardMap.get(entry.Protocol__c);
            Bundle_Entry__c sEntry = standardEntryMap.get(key);
            Plan_Protocol__c item = new Plan_Protocol__c();
            item.Treatment_Plan__c = opportunity.Id;
            item.Protocol__c = entry.Protocol__c;
            //item.Bundle_Entry__c = sEntry.Id;
            newLineItems.add(item);
        }
        insert newLineItems;
        ServiceResponse response = new ServiceResponse(request);


        return response;
    }

    private static ServiceResponse assignPlan(ServiceRequest request) {

        Set<Id> keysetIds = new Set<Id>();
        keysetIds.add((String) request.Parameters.get('recordId'));
        BehaviorEvaluationsSelector selector = new BehaviorEvaluationsSelector();
        Behavior_Evaluation__c sEvaluation = selector.GetById(keysetIds)[0];
        //TreatmentPlanSelector planSelector = new TreatmentPlanSelector();
        //TODO: Card 320 - Change Query to LIMIT to one record

        Treatment_Plan__c plan = new Treatment_Plan__c();
        if(!Test.isRunningTest()) {
            try {
                plan =  [SELECT id, Animal__c from Treatment_Plan__c WHERE Animal__c =: sEvaluation.Animal__c LIMIT  1];
                System.debug('QUERIED PLAN ==> ' + plan );
            }catch (Exception e) {
                System.debug(e);
                plan = null;
            }

        }else {
            plan = null;
        }

        ServiceResponse response = new ServiceResponse(request);
        if(plan == null) {
            response.Data = 'NO PLAN FOUND';
        }else {
            response.Data = 'SUCCESS';
        }
        return response;
    }
    private static Map<Id, Plan_Protocol__c> getPlanProtocol(Id opp) {
        PlanProtocolSelector selector = new PlanProtocolSelector();

        List<Plan_Protocol__c> lineItems = selector.GetByOpp(opp);
        if (lineItems.isEmpty()) {System.debug('NO LINE ITEMS FOUND'); return new Map<Id, Plan_Protocol__c>(); }
        else {
            Map<Id, Plan_Protocol__c> idOpportunityLineItemMap  = new Map<Id, Plan_Protocol__c>();
            idOpportunityLineItemMap.putAll(lineItems);
            return idOpportunityLineItemMap;
        }

    }


}