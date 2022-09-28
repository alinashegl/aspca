/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentPlanDomain extends DomainActionBase{
    public override void ProcessAction(TriggerRequest request) {
        if (request.targetSObject == Treatment_Plan__c.SObjectType) {
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
        List<Treatment_Plan__c> newRecords = request.newRecords;

        Map<Id, Treatment_Plan__c> newRecordMap = (Map<Id, Treatment_Plan__c>) request.newRecordMap;
        List<Treatment_Bundle__c> standard = [SELECT Id, Name, IsMaster__c from Treatment_Bundle__c where IsMaster__c =
                TRUE LIMIT 1];
        Set<Id> planAnimals = new Set<Id>();
        List<Treatment_Plan__c> assignedBundles = new List<Treatment_Plan__c>();
        for (Treatment_Plan__c plan : newRecords) {
            if (standard.size() > 0) {
                plan.MasterTreatmentBundleId__c = standard[0].Id;
            }
            if (plan.AssignedTreatmentBundleId__c != null) {
                assignedBundles.add(plan);
            }
            if (plan.Animal__c != null) {
                planAnimals.add(plan.Animal__c);
            }
            plan.Problem_Behavior_Aggression_Count__c = getMSPCount('Problem_Behavior_Aggression__c', plan);
            plan.Problem_Behavior_Arousal_Count__c = getMSPCount('Problem_Behavior_Arousal__c', plan);
            plan.Problem_Behavior_Fear_Count__c = getMSPCount('Problem_Behavior_Fear__c', plan);
            plan.Problem_Behavior_Miscellaneous_Count__c = getMSPCount('Problem_Behavior_Miscellaneous__c', plan);
        }
        if (!planAnimals.isEmpty()) {
            TreatmentPlanService.deactivateAnimalPlans(planAnimals);
        }
        if (!assignedBundles.isEmpty()) {
            TreatmentPlanService.assignBundleEnrichments(assignedBundles);
        }
    }
    public static void beforeUpdate(TriggerRequest request) {
        List<Treatment_Plan__c> newRecords = request.newRecords;
        List<Treatment_Plan__c> oldRecords = request.oldRecords;

        Map<Id, Treatment_Plan__c> newRecordMap = (Map<Id, Treatment_Plan__c>) request.newRecordMap;
        Map<Id, Treatment_Plan__c> oldRecordMap = (Map<Id, Treatment_Plan__c>) request.oldRecordMap;
        Set<Id> planAnimals = new Set<Id>();
        List<Treatment_Plan__c> assignedBundles = new List<Treatment_Plan__c>();
        for (Treatment_Plan__c p : newRecords) {
            Treatment_Plan__c oldValue = oldRecordMap.get(p.Id);
            if (p.IsActive__c && !oldValue.IsActive__c) {
                if (p.Animal__c != null) {
                    planAnimals.add(p.Animal__c);
                }
            }
            if (p.AssignedTreatmentBundleId__c != null && oldValue.AssignedTreatmentBundleId__c != p.AssignedTreatmentBundleId__c) {
                assignedBundles.add(p);
            }
            p.Problem_Behavior_Aggression_Count__c = getMSPCount('Problem_Behavior_Aggression__c', p);
            p.Problem_Behavior_Arousal_Count__c = getMSPCount('Problem_Behavior_Arousal__c', p);
            p.Problem_Behavior_Fear_Count__c = getMSPCount('Problem_Behavior_Fear__c', p);
            p.Problem_Behavior_Miscellaneous_Count__c = getMSPCount('Problem_Behavior_Miscellaneous__c', p);
        }
        if (!planAnimals.isEmpty()) {
            TreatmentPlanService.deactivateAnimalPlans(planAnimals);
        }
        if (!assignedBundles.isEmpty()) {
            TreatmentPlanService.assignBundleEnrichments(assignedBundles);
        }
    }
    public void beforeDelete(TriggerRequest request) { System.debug('Before Delete is Executing'); }
    public void afterInsert(TriggerRequest request) {
        //System.debug('After Insert is Executing');
        List<Treatment_Plan__c> newRecords = request.newRecords;
        List<Treatment_Plan__c> oldRecords = request.oldRecords;

        Map<Id, Treatment_Plan__c> newRecordMap = (Map<Id, Treatment_Plan__c>) request.newRecordMap;
        Map<Id, Treatment_Plan__c> oldRecordMap = (Map<Id, Treatment_Plan__c>) request.oldRecordMap;
        List<ServiceRequest> requests = new List<ServiceRequest>();

        List<Plan_Protocol__c> lineItems = new List<Plan_Protocol__c>();
        for (Treatment_Plan__c plan : newRecordMap.values()) {
            String newVal = plan.AssignedTreatmentBundleId__c;
            System.debug(newVal);
            if ( newVal != null ){
                ServiceRequest serviceRequest = new ServiceRequest();
                serviceRequest.Name = 'New Bundle Assignment';
                serviceRequest.Action = 'newBundleAssigned';
                serviceRequest.withParams('new', plan);
                serviceRequest.withParams('newBundleId', newVal);
                requests.add(serviceRequest);
            }
        }
        if (requests.size() > 0) {
            List<ServiceResponse> responses = TreatmentPlanService.executeAll(requests);
            for (ServiceResponse response : responses) {
                System.debug(responses);
            }
        }
    }
    public static void afterUpdate(TriggerRequest request) {
        List<Treatment_Plan__c> newRecords = request.newRecords;
        List<Treatment_Plan__c> oldRecords = request.oldRecords;

        Map<Id, Treatment_Plan__c> newRecordMap = (Map<Id, Treatment_Plan__c>) request.newRecordMap;
        Map<Id, Treatment_Plan__c> oldRecordMap = (Map<Id, Treatment_Plan__c>) request.oldRecordMap;
        List<ServiceRequest> requests = new List<ServiceRequest>();
        //TreatmentPlanService service = new TreatmentPlanService();

        List<Plan_Protocol__c> lineItems = new List<Plan_Protocol__c>();
        for (Treatment_Plan__c plan : newRecordMap.values()) {
            String newVal = plan.AssignedTreatmentBundleId__c;
            System.debug(newVal);
            if ( newVal != null ){
                Treatment_Plan__c oldOpp = oldRecordMap.get(plan.Id);
                //System.debug('#### OLD OPP ====> ' + oldOpp);
                String oldVal = oldOpp.AssignedTreatmentBundleId__c;
                System.debug(oldVal);
                if (oldVal != null && oldVal != newVal) {
                    System.debug('Old Value Is NOT Null');
                    ServiceRequest serviceRequest = new ServiceRequest();
                    serviceRequest.Name = 'Bundle Assignment Change';
                    serviceRequest.Action = 'bundleAssignmentChanged';
                    serviceRequest.withParams('new', plan);
                    serviceRequest.withParams('newBundleId', newVal);
                    requests.add(serviceRequest);
                }
                if(oldVal == null){
                    ServiceRequest serviceRequest = new ServiceRequest();
                    serviceRequest.Name = 'New Bundle Assignment';
                    serviceRequest.Action = 'newBundleAssigned';
                    serviceRequest.withParams('new', plan);
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
    public void afterDelete(TriggerRequest request) { /* System.debug('After Delete is Executing'); */ }
    
    public static Decimal getMSPCount(string mspField, SObject sObj){
        Decimal count = 0;
        if(String.isNotBlank(String.valueOf(sObj.get(mspField)))){
            List<String> mspSize = String.valueOf(sObj.get(mspField)).split(';');
            count = mspSize.size();
        }
        return count;
    }
}