trigger FacilityOutcomeTrigger on Facility_Outcome__c (after insert, after update) {
    if (Trigger.isAfter) {
        
        if (Trigger.isInsert) {
            FacilityOutcomeTriggerHandler.afterInsert(Trigger.new);
        }
        
        if (Trigger.isUpdate) {
            FacilityOutcomeTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }

    FacilityOutcomeTriggerHandler.andFinally();
}