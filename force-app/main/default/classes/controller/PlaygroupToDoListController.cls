public with sharing class PlaygroupToDoListController {
    @AuraEnabled(cacheable=true)
    public static List<Animal__c> getPlaygroupAnimals(String location) {
        List<Animal__c> animals = [SELECT Id, Name, Animal_Name__c, Gender__c, Shelter_Location__c, Shelter_Location2__c, Playgroup_Priority_Level__c,
                                        Play_Category__c, Handler__c, Number_of_Playgroups__c, Play_Pause__c, Does_Not_Walk_on_a_Leash__c,
                                        (SELECT Id FROM Animal_Playgroups__r
                                        WHERE Playgroup_Session__r.Playgroup_Date_Time__c >= TODAY
                                            AND Playgroup_Session__r.Playgroup_Date_Time__c < TOMORROW LIMIT 1)
                                    FROM Animal__c
                                    WHERE Play_Category__c NOT IN ('Unevaluated', 'DO NOT PLAY') AND Shelter_Location2__c =: location];
        return animals;
    }

    @AuraEnabled
    public static String createPlaygroup(List<String> animals) {
        String sessionResult = '';
        Playgroup_Session__c session = new Playgroup_Session__c();
        Database.SaveResult sessionSR = Database.insert(session);
        if (sessionSR.isSuccess()) {
            sessionResult = sessionSR.getId();
            List<Animal_Playgroup__c> animalPlaygroups = new List<Animal_Playgroup__c>();
            for(String a : animals) {
                Animal_Playgroup__c animalPG = new Animal_Playgroup__c(
                    Animal__c = a,
                    Playgroup_Session__c = sessionResult
                );
                animalPlaygroups.add(animalPG);
            }
            List<Database.SaveResult> animalSR = Database.insert(animalPlaygroups);
            for(Database.SaveResult s : animalSR) {
                if (!s.isSuccess()) {
                    sessionResult = 'Error creating animal playgroups';
                    break;
                }
            }
        }
        else {
            sessionResult = 'Error creating playgroup session';
        }
        return sessionResult;
    }
}