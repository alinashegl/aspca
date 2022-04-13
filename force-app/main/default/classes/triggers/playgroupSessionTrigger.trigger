trigger playgroupSessionTrigger on Playgroup_Session__c (after insert, after update, before insert, before update) {
    
    Trigger_Config__c config = Trigger_Config__c.getInstance();
    if (!config.Disable_Triggers__c) {
        if (trigger.isInsert && trigger.isAfter){
            PlaygroupSessionTriggerHandler.insertHandler(Trigger.new); 
        }
        
        if (trigger.isInsert && trigger.isBefore){}
        
        if (trigger.isUpdate && trigger.isAfter){
            PlaygroupSessionTriggerHandler.updateHandler(Trigger.new, Trigger.oldMap);
            PlaygroupSessionTriggerHandler.UpdateNoteToAnimal(Trigger.newMap, Trigger.oldMap);
        }
        
        if (trigger.isUpdate && trigger.isBefore){}
    }
}