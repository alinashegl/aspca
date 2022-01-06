trigger TaskTrigger on Task (before update) {
    Trigger_Config__c config = Trigger_Config__c.getInstance();
    if (!config.Disable_Triggers__c) {
        if (trigger.isInsert && trigger.isAfter){}
        
        if (trigger.isInsert && trigger.isBefore){}

        if (trigger.isUpdate && trigger.isAfter){}
        
        if (trigger.isUpdate && trigger.isBefore){
            TaskTriggerHandler.updateHandler(Trigger.new, Trigger.oldMap);
        }
    }
}