trigger TaskTrigger on Task (after insert, after update, before insert, before update) {
     
    if (trigger.isInsert && trigger.isAfter){
        TaskTriggerHandler.afterInsertHandler(Trigger.New); 
    }
    
    if (trigger.isInsert && trigger.isBefore){
        
    }
    
    if (trigger.isUpdate && trigger.isAfter){
    }
    
    if (trigger.isUpdate && trigger.isBefore){
    }
        
}