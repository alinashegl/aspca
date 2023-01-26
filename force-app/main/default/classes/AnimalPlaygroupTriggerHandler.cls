public with sharing class AnimalPlaygroupTriggerHandler {
    public static void afterUpdate(Map<Id, Animal_Playgroup__c> newMap) {

        AnimalPlaygroupUpdateQueueable updateAnimalPlaygroups = new AnimalPlaygroupUpdateQueueable(
            getSessionIds(newMap.values())
        );
        // enqueue the job for processing
        ID jobID = System.enqueueJob(updateAnimalPlaygroups);
    }

    public static void afterDelete(Map<Id, Animal_Playgroup__c> oldMap){
        AnimalPlaygroupUpdateQueueable updateAnimalPlaygroups = new AnimalPlaygroupUpdateQueueable(
            getSessionIds(oldMap.values())
        );
        // enqueue the job for processing
        ID jobID = System.enqueueJob(updateAnimalPlaygroups);
    }

    private static Set<Id> getSessionIds(Animal_Playgroup__c[] animalPlaygroups){
        Set<Id> sessionIds = new Set<Id>();
        for(Animal_Playgroup__c ap : animalPlaygroups){
            sessionIds.add(ap.Playgroup_Session__c);
        }
        return sessionIds;
    }
}