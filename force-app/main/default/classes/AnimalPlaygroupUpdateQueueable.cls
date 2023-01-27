public with sharing class AnimalPlaygroupUpdateQueueable implements Queueable{
    private Set<Id> pgSessionIds;

    public AnimalPlaygroupUpdateQueueable(Set<Id> pgSessionIds) {
        this.pgSessionIds = pgSessionIds;

    }
    public void execute(QueueableContext context) {
        Playgroup_Session__c[] sessions = [
            SELECT Id,
            (SELECT Id, Animal_Name__c, Other_Dogs__c FROM Animal_Playgroups__r)
            FROM Playgroup_Session__c
            WHERE Id IN :pgSessionIds
        ];

        Animal_Playgroup__c[] apsToUpdate = new Animal_Playgroup__c[0];
        for(Playgroup_Session__c session : sessions){
            String[] animalNameList = new String[0];
            for(Animal_Playgroup__c ap : session.Animal_Playgroups__r){
                animalNameList.add(ap.Animal_Name__c);
            }

            for(Animal_Playgroup__c ap : session.Animal_Playgroups__r){
                String[] tempNameList = animalNameList.clone();

                Integer index = tempNameList.indexOf(ap.Animal_Name__c);
                tempNameList.remove(index);
                ap.Other_Dogs__c = String.join(tempNameList, ',');
                apsToUpdate.add(ap);
            }
        }

        update apsToUpdate;
    }
}