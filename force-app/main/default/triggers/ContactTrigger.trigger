trigger ContactTrigger on Contact (after insert, after update) {
    ContactTriggerHandler handlerClass = new ContactTriggerHandler();
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            handlerClass.afterInsertMethod(Trigger.New, Trigger.newMap);
        }
        if(Trigger.isUpdate){
            handlerClass.afterUpdateMethod(Trigger.New, Trigger.oldMap);
        }
    }
}