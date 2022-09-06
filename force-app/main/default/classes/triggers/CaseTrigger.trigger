trigger CaseTrigger on Case (after insert, after update, before insert, before update) {
    
    if (trigger.isInsert && Trigger.isAfter){
        CaseTriggerHandler.insertHandler();
      }
    
    if (trigger.isUpdate && Trigger.isAfter){
		CaseTriggerHandler.updateHandler(Trigger.new, Trigger.oldMap);
    }
    
//    if(Trigger.isInsert && Trigger.isBefore){
//        ANH.AutoNumberHelper.OnBeforeInsert(Trigger.new);
//    }
        
}