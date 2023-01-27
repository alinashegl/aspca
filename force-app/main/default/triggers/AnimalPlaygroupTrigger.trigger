trigger AnimalPlaygroupTrigger on Animal_Playgroup__c (after insert, after delete) {
    if(Trigger.isInsert){
        AnimalPlaygroupTriggerHandler.afterUpdate(Trigger.newMap);
    }

    if(Trigger.isDelete){
        AnimalPlaygroupTriggerHandler.afterDelete(Trigger.oldMap);
    }
}