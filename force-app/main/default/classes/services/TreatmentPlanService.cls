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
    
    private static ServiceResponse bundleAssignmentChanged(ServiceRequest request) {
        System.debug('Bundle Assignment Helper Is Executing');
        ServiceResponse response = new ServiceResponse(request);
        Treatment_Plan__c newOpp = (Treatment_Plan__c) request.Parameters.get('new');
        String newBundleId = (String) request.Parameters.get('newBundleId');
        List<Bundle_Entry__c> newEntries = [SELECT Id, Protocol__c, Treatment_Bundle__c, Name FROM Bundle_Entry__c WHERE
                Treatment_Bundle__c =: newBundleId];
        Set<Id> newProtocolIds = new Set<Id>();
        for (Bundle_Entry__c entry : newEntries) {
            newProtocolIds.add(entry.Protocol__c);
        }
        List<Plan_Protocol__c> currentLineItems = [SELECT Id, Protocol__c FROM Plan_Protocol__c WHERE Treatment_Plan__c =: newOpp.Id];
        List<Plan_Protocol__c> lineItemsToDelete = new List<Plan_Protocol__c>();
        for (Plan_Protocol__c item : currentLineItems) {
            if(newProtocolIds.contains(item.Protocol__c)) {
                lineItemsToDelete.add(item);
            }
        }
        
        List<Plan_Protocol__c> toCreate = new List<Plan_Protocol__c>();
        for (Bundle_Entry__c entry : newEntries) {
            Plan_Protocol__c item = new Plan_Protocol__c();
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
        if (lineItemsToDelete.size() > 0) {
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

        Treatment_Plan__c plan = (Treatment_Plan__c) request.Parameters.get('new');
        String newBundleId = (String) request.Parameters.get('newBundleId');
        
        List<Bundle_Entry__c> entries = [SELECT Id, Protocol__c, Treatment_Bundle__c, Name FROM Bundle_Entry__c WHERE
                Treatment_Bundle__c =: newBundleId];
        List<Plan_Protocol__c> newLineItems = new List<Plan_Protocol__c>();
        for (Bundle_Entry__c entry : entries) {
            Plan_Protocol__c item = new Plan_Protocol__c();
            item.Treatment_Plan__c = plan.Id;
            item.Protocol__c = entry.Protocol__c;
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

        Treatment_Plan__c plan = new Treatment_Plan__c();
        try {
            plan =  [SELECT id, Animal__c from Treatment_Plan__c WHERE Animal__c =: sEvaluation.Animal__c AND IsActive__c = true LIMIT 1];
            System.debug('QUERIED PLAN ==> ' + plan );
        }catch (Exception e) {
            System.debug(e);
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

    public static void deactivateAnimalPlans(Set<Id> planAnimals) {
        List<Treatment_Plan__c> activePlans = [SELECT Id, IsActive__c FROM Treatment_Plan__c WHERE Animal__c IN :planAnimals AND IsActive__c = true];
        for (Treatment_Plan__c p : activePlans) {
            p.IsActive__c = false;
        }
        update activePlans;
    }

    public static void assignBundleEnrichments(List<Treatment_Plan__c> assignedBundles) {
        Set<Id> bundleIds = new Set<Id>();
        for (Treatment_Plan__c p : assignedBundles) {
            bundleIds.add(p.AssignedTreatmentBundleId__c);
        }
        Map<Id, Treatment_Bundle__c> bundleMap = new Map<Id, Treatment_Bundle__c>([SELECT Id, Enrichment_Activities__c FROM Treatment_Bundle__c WHERE Id IN :bundleIds]);
        for (Treatment_Plan__c p : assignedBundles) {
            p.Enrichment_Activities__c = bundleMap.get(p.AssignedTreatmentBundleId__c).Enrichment_Activities__c;
        }
    }
}