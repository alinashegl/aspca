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
        List<Treatment_Plan__c> newRecords = request.newRecords;

        Map<Id, Treatment_Plan__c> newRecordMap = (Map<Id, Treatment_Plan__c>) request.newRecordMap;
        Treatment_Bundle__c standard = [SELECT Id, Name, IsMaster__c from Treatment_Bundle__c where IsMaster__c = TRUE];
        for (Treatment_Plan__c plan : newRecords) {
            plan.MasterTreatmentBundleId__c = standard.Id;
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
        List<Treatment_Plan__c> newRecords = request.newRecords;
        List<Treatment_Plan__c> oldRecords = request.oldRecords;

        Map<Id, Treatment_Plan__c> newRecordMap = (Map<Id, Treatment_Plan__c>) request.newRecordMap;
        Map<Id, Treatment_Plan__c> oldRecordMap = (Map<Id, Treatment_Plan__c>) request.oldRecordMap;
        List<ServiceRequest> requests = new List<ServiceRequest>();
        //TreatmentPlanService service = new TreatmentPlanService();

        List<Plan_Protocol__c> lineItems = new List<Plan_Protocol__c>();
        for (Treatment_Plan__c opportunity : newRecordMap.values()) {
            String newVal = opportunity.AssignedTreatmentBundleId__c;
            System.debug(newVal);
            if ( newVal != null ){
                Treatment_Plan__c oldOpp = oldRecordMap.get(opportunity.Id);
                //System.debug('#### OLD OPP ====> ' + oldOpp);
                String oldVal = oldOpp.AssignedTreatmentBundleId__c;
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
}