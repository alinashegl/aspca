public with sharing class playgroupSessionLWCController {
    @AuraEnabled (cacheable=true)
    public static playgroupSessionInfo getPlaygroupSessionInfo(){
        try {
            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // @AuraEnabled
    // public static playgroupSessionInfo copyPlaygroup(Id sessionId){
    //     try {            
    //         return handleCopyPlaygroup(sessionId);
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }

    @AuraEnabled
    public static playgroupSessionInfo startPlaygroupSession(Id sessionId, Id[] animalIdsToIgnore, Id[] animalIdsToAdd){
        try {
            playgroupSessionInfo info = handleCopyPlaygroup(sessionId, animalIdsToIgnore);
            if(!animalIdsToAdd.isEmpty()){
                info.animalPlaygroups.addAll(createNewPlaygroupAnimals(info.sessionId, animalIdsToAdd));
            }
            return info;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string endPlaygroup(){
        try {
            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static playgroupSessionInfo handleCopyPlaygroup(Id sessionId, Id[] animalIdstoIgnore){
        playgroupSessionInfo info = new playgroupSessionInfo();
        info.sessionId = createNewPlaygroupSession(sessionId).Id;
        info.animalPlaygroups = copyAnimalPlaygroups(sessionId, info.sessionId, animalIdstoIgnore);
        return info;
    }

    private static Animal_Playgroup__c[] copyAnimalPlaygroups(Id oldSessionId, Id newSessionId, Id[] animalIdstoIgnore){
        Animal_Playgroup__c[] copiedAnimals = new Animal_Playgroup__c[0];
        for(Animal_Playgroup__c oldAnimal : [
            SELECT Id, Animal__c, Common_Playgroup_Note_Sections__c, Common_Playgroup_Notes__c, Play_Rating__c, Playgroup_Individual_Notes__c
            FROM Animal_Playgroup__c 
            WHERE Playgroup_Session__c =: oldSessionId
        ]){
            if(animalIdstoIgnore.contains(oldAnimal.Animal__c)) continue;

            Animal_Playgroup__c newAnimal = new Animal_Playgroup__c(
                Animal__c = oldAnimal.Animal__c, 
                Common_Playgroup_Note_Sections__c = oldAnimal.Common_Playgroup_Note_Sections__c, 
                Common_Playgroup_Notes__c = oldAnimal.Common_Playgroup_Notes__c, 
                Play_Rating__c = oldAnimal.Play_Rating__c, 
                Playgroup_Individual_Notes__c = oldAnimal.Playgroup_Individual_Notes__c
            );
            copiedAnimals.add(newAnimal);
        }
        insert copiedAnimals;
        return copiedAnimals;
    }

    private static Animal_Playgroup__c[] createNewPlaygroupAnimals(Id sessionId, Id[] animalIdsToAdd){
        Animal_Playgroup__c[] newAnimals = new Animal_Playgroup__c[0];
        for(Id animalId : animalIdsToAdd){
            Animal_Playgroup__c newAnimal = new Animal_Playgroup__c(
                Animal__c = animalId
            );
            newAnimals.add(newAnimal);
        }
        insert newAnimals;
        return newAnimals;
    }

    private static void createNewPlaygroupContacts(){
            // (SELECT Id, Contact__c, Novel_Not_Novel__c FROM Playgroup_Contacts)
    }

    private static Playgroup_Session__c createNewPlaygroupSession(Id SessionId){
        Playgroup_Session__c originalSession = getPlaygroupSession(sessionId);
        Playgroup_Session__c newSession = new Playgroup_Session__c(
            Playgroup_Leader__c = originalSession.Playgroup_Leader__c,
            Playgroup_Location__c = originalSession.Playgroup_Location__c,
            Playgroup_Date_Time__c = dateTime.now()
        );
        insert newSession;
        return newSession;
    }

    private static Playgroup_Session__c getPlaygroupSession (Id sessionId){
        Playgroup_Session__c[] sessions = [
            SELECT Id, Playgroup_Location__c, Playgroup_Leader__c
            FROM Playgroup_Session__c 
            WHERE Id =: sessionId 
            LIMIT 1
        ];
        return sessions.isEmpty() ? null : sessions[0];
    }    

    public class playgroupSessionInfo{
        @AuraEnabled public Id sessionId {get; set;}
        @AuraEnabled public Animal_Playgroup__c[] animalPlaygroups {get; set;}
    }
}
