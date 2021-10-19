public with sharing class playgroupSessionLWCController {
    @AuraEnabled (cacheable=true)
    public static playgroupSessionInfo getPlaygroupSessionInfo(){
        try {
            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static playgroupSessionInfo startPlaygroupSession(Id[] animalIdsToAdd){
        try {
            // playgroupSessionInfo info = handleCopyPlaygroup(sessionId, animalIdsToIgnore);
            // if(!animalIdsToAdd.isEmpty()){
            //     info.animalPlaygroups.addAll(createNewPlaygroupAnimals(info, animalIdsToAdd));
            // }
            // return info;
            System.debug('in startPlaygroupSession with animalIds');
            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static playgroupSessionInfo startPlaygroupSession(Id sessionId, Id[] animalIdsToIgnore, Id[] animalIdsToAdd){
        try {
            System.debug('in startPlaygroupSession from copy');
            playgroupSessionInfo info = handleCopyPlaygroup(sessionId, animalIdsToIgnore);
            if(animalIdsToAdd != null && !animalIdsToAdd.isEmpty()){
                info.animalPlaygroups.addAll(createNewPlaygroupAnimals(info, animalIdsToAdd));
            }
            return info;
        } catch (Exception e) {
            System.debug('error: ' + e.getMessage());
            System.debug('line: ' + e.getStackTraceString());
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
        info.playgroupSession = createNewPlaygroupSession(sessionId);
        info.animalPlaygroups = copyAnimalPlaygroups(sessionId, info.playgroupSession.Id, animalIdstoIgnore);
        return info;
    }

    private static Animal_Playgroup__c[] copyAnimalPlaygroups(Id oldSessionId, Id newSessionId, Id[] animalIdstoIgnore){
        Animal_Playgroup__c[] copiedAnimals = new Animal_Playgroup__c[0];
        Map<Id, Playgroup_Contact__c[]> animalToContactsMap = new Map<Id, Playgroup_Contact__c[]>();
        for(Animal_Playgroup__c oldAnimal : [
            SELECT Id, Animal__c, Common_Playgroup_Note_Sections__c, Common_Playgroup_Notes__c, Play_Rating__c, Playgroup_Individual_Notes__c,
            (SELECT Id, Contact__c, Novel_Not_Novel__c, Playgroup__c FROM Playgroup_Contacts__r)
            FROM Animal_Playgroup__c 
            WHERE Playgroup_Session__c =: oldSessionId
        ]){
            if(animalIdstoIgnore != null && !animalIdstoIgnore.isEmpty() && animalIdstoIgnore.contains(oldAnimal.Animal__c)) continue;

            animalToContactsMap.put(oldAnimal.Animal__c, oldAnimal.Playgroup_Contacts__r);

            Animal_Playgroup__c newAnimal = new Animal_Playgroup__c(
                Animal__c = oldAnimal.Animal__c, 
                Common_Playgroup_Note_Sections__c = oldAnimal.Common_Playgroup_Note_Sections__c, 
                Common_Playgroup_Notes__c = oldAnimal.Common_Playgroup_Notes__c, 
                Play_Rating__c = oldAnimal.Play_Rating__c, 
                Playgroup_Individual_Notes__c = oldAnimal.Playgroup_Individual_Notes__c,
                Playgroup_Session__c = newSessionId
            );
            copiedAnimals.add(newAnimal);
        }
        insert copiedAnimals;
        createCopiedPlaygroupContacts(copiedAnimals, animalToContactsMap);
        return copiedAnimals;
    }

    private static void createCopiedPlaygroupContacts(Animal_Playgroup__c[] animalPlaygroups, Map<Id, Playgroup_Contact__c[]> animalToContactsMap){
        Playgroup_Contact__c[] pgContacts = new Playgroup_Contact__c[0];
        for(Animal_Playgroup__c animal : animalPlaygroups){
            if(animalToContactsMap.containsKey(animal.Animal__c)){
                for(Playgroup_Contact__c pgContact : animalToContactsMap.get(animal.Animal__c)){
                    pgContacts.add(
                        new Playgroup_Contact__c(
                            Contact__c = pgContact.Contact__c,
                            Novel_Not_Novel__c = pgContact.Novel_Not_Novel__c,
                            Playgroup__c = animal.Id
                        )
                    );
                }
            }
        }
        insert pgContacts;
    }

    private static Animal_Playgroup__c[] createNewPlaygroupAnimals(playgroupSessionInfo info, Id[] animalIdsToAdd){
        Animal_Playgroup__c[] newAnimals = new Animal_Playgroup__c[0];
        for(Id animalId : animalIdsToAdd){
            Animal_Playgroup__c newAnimal = new Animal_Playgroup__c(
                Animal__c = animalId,
                Playgroup_Session__c = info.playgroupSession.Id
            );
            newAnimals.add(newAnimal);
        }
        insert newAnimals;
        createNewPlaygroupContacts(newAnimals, info.playgroupSession.Playgroup_Leader__c);

        return newAnimals;
    }

    public static void createNewPlaygroupContacts(Animal_Playgroup__c[] newAnimals, Id sessionLeader){
        Playgroup_Contact__c[] pgContacts = new Playgroup_Contact__c[0];
        for(Animal_Playgroup__c animal : newAnimals){
            pgContacts.add(
                new Playgroup_Contact__c(
                    Contact__c = sessionLeader,
                    Novel_Not_Novel__c = 'Not Novel',
                    Playgroup__c = animal.Id
                )
            );
        }
        insert pgContacts;
    }

    private static void createNewPlaygroupContacts(){
            // 
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
        // @AuraEnabled public Id sessionId {get; set;}
        // @AuraEnabled public Id sessionLeader {get; set;}
        @AuraEnabled public Playgroup_Session__c playgroupSession {get; set;}
        @AuraEnabled public Animal_Playgroup__c[] animalPlaygroups {get; set;}
    }
}
