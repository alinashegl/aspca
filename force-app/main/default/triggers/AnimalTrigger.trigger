trigger AnimalTrigger on Animal__c (after insert, after update, before insert, before update) {
    
     
    if (trigger.isInsert && trigger.isAfter){
        AnimalTriggerHandler.insertHandler(); 
    }
    
    if (trigger.isInsert && trigger.isBefore){
        //AnimalTriggerHandler.insertHandlerBefore();
        //ANH.AutoNumberHelper.OnBeforeInsert(Trigger.new);

    }
    
    if (trigger.isUpdate && trigger.isAfter){
        AnimalTriggerHandler.updateHandler(Trigger.new, Trigger.oldMap);
        }
    
    if (trigger.isUpdate && trigger.isBefore){
        AnimalTriggerHandler.onBeforeUpdateHandler(Trigger.new, Trigger.oldMap);
//        ANH.AutoNumberHelper.OnBeforeUpdate(Trigger.new,Trigger.OldMap);
        AnimalTriggerHandler.beforeFieldUpdateHandler(Trigger.new,Trigger.OldMap);
    }
        
}
//    if (trigger.isDelete){
        
//    }