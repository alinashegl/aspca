trigger TaskTrigger on Task (after insert, after update, before update, before insert) {
    Trigger_Config__c config = Trigger_Config__c.getInstance();
    if (!config.Disable_Triggers__c) {
        if (trigger.isInsert && trigger.isAfter){
            TaskTriggerHandler.afterInsertHandler(Trigger.New); 
        }
        
        if (trigger.isInsert && trigger.isBefore){
            TaskTriggerHandler.onInsertHandler(Trigger.new);
        }

        if (trigger.isUpdate && trigger.isAfter){}
        
        if (trigger.isUpdate && trigger.isBefore){
            TaskTriggerHandler.updateHandler(Trigger.new, Trigger.oldMap);
        }
    }
}