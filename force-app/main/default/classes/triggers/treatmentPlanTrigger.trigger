/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

trigger treatmentPlanTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after
        delete, after undelete) {
    Trigger_Config__c config = Trigger_Config__c.getInstance();
    if (!config.Disable_Triggers__c) {
        ServiceRequest request = new ServiceRequest();
        request.Action = 'triggerservice';
        if (Trigger.isBefore && Trigger.isInsert) {
            request.Name = 'BeforeInsert';
            request.Parameters.put('newRecords', Trigger.newMap);
        }else if (Trigger.isBefore && Trigger.isUpdate) {
            request.Name = 'BeforeUpdate';
            request.Parameters.put('newRecords', Trigger.newMap);
            request.Parameters.put('oldRecords', Trigger.oldMap);
        }

        TreatmentPlanService service = new TreatmentPlanService();
        service.process(request);
    }

}