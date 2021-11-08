public with sharing class playgroupSessionLWCController {
    @AuraEnabled (cacheable=true)
    public static playgroupSessionInfo getPlaygroupSessionInfo(Id sessionId){
        try {
            playgroupSessionInfo info = new playgroupSessionInfo();
            info.animalPlaygroups = animalPlaygroups(sessionId);
            info.playgroupSession = getPlaygroupSession(sessionId);
            info.playgroupContacts = getPlaygroupContacts(info.animalPlaygroups[0].Id);
            return info;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static Playgroup_Session__c getPlaygroupSession (Id sessionId){
        Playgroup_Session__c[] sessions = [
            SELECT Id, Name, Playgroup_Location__c, Playgroup_Leader__c
            FROM Playgroup_Session__c 
            WHERE Id =: sessionId 
            LIMIT 1
        ];
        return sessions.isEmpty() ? null : sessions[0];
    }

    private static Animal_Playgroup__c[] animalPlaygroups (Id sessionId){
        return [SELECT Id, Animal__c, Animal_Name__c FROM Animal_Playgroup__c WHERE Playgroup_Session__c =: sessionId];
    }

    private static Playgroup_Contact__c[] getPlaygroupContacts(Id animalPlaygroupId){
        return [SELECT Id, Contact__c, Contact__r.Name FROM Playgroup_Contact__c WHERE Playgroup__c =: animalPlaygroupId];
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

    @AuraEnabled
    public static Animal_Playgroup__c[] getAnimalList(Id sessionId){

        return [SELECT Id, Animal_Name__c, Animal__c FROM Animal_Playgroup__c WHERE Playgroup_Session__c =: sessionId];
    }

    @AuraEnabled
    public static String addContact(Id sessionId, Id contactId, Id[] animalIdsWithNovelContact){
        try{
            Playgroup_Contact__c[] pgContacts = new Playgroup_Contact__c[0];
            for(Animal_Playgroup__c animal : getAnimalList(sessionId)){
                Playgroup_Contact__c pg = new Playgroup_Contact__c(
                    Playgroup__c = animal.Id,
                    Contact__c = contactId,
                    Novel_Not_Novel__c = animalIdsWithNovelContact.contains(animal.Id) ? 'Novel' : 'Familiar'
                );
                pgContacts.add(pg);
            }

            insert pgContacts;
            return 'Success';

        } catch(exception error) {
            throw new AuraHandledException(error.getMessage());
        }
    }

    @AuraEnabled
    public static String removeContact(Id sessionId, Id contactId){
        try{
            delete [SELECT Id FROM Playgroup_Contact__c WHERE Contact__c =: contactId AND Playgroup__r.Playgroup_Session__c =: sessionId];
            return 'Success';
        } catch (exception error){
            throw new AuraHandledException(error.getMessage());
        }
    }

    @AuraEnabled
    public static string removeFromPlaygroup(Id animalPlagroupId){
        try {
            Animal_playgroup__c aPg = [SELECT Id, (SELECT Id FROM Playgroup_Contacts__r) FROM Animal_Playgroup__c WHERE Id =: animalPlagroupId LIMIT 1];
            if(aPg != null){
                if(!apg.Playgroup_Contacts__r.isEmpty() ){
                    delete aPg.Playgroup_Contacts__r;
                }
                delete aPg;
            }
            return 'success';
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

    public static void createNewPlaygroupContacts(Animal_Playgroup__c[] newAnimals, Id sessionLeader){
        Playgroup_Contact__c[] pgContacts = new Playgroup_Contact__c[0];
        for(Animal_Playgroup__c animal : newAnimals){
            pgContacts.add(
                new Playgroup_Contact__c(
                    Contact__c = sessionLeader,
                    Novel_Not_Novel__c = 'Familiar',
                    Playgroup__c = animal.Id
                )
            );
        }
        insert pgContacts;
    }

    private static void createNewPlaygroupContacts(){
            // 
    } 

    public class playgroupSessionInfo{
        @AuraEnabled public Playgroup_Session__c playgroupSession {get; set;}
        @AuraEnabled public Animal_Playgroup__c[] animalPlaygroups {get; set;}
        @AuraEnabled public Playgroup_Contact__c[] playgroupContacts {get; set;}
    }
}


// @AuraEnabled
//     public static Id copyPlaygroupSession(Id sessionId, Id[] animalsToAdd){
//         try {
//             Id newSessionId = handleCopyPlaygroupSession(sessionId);
//             createNewAnimalPlaygroups(sessionId, newSessionId, animalsToAdd);
//             return newSessionId;

//         } catch (Exception e) {
//             System.debug('error: ' + e.getMessage());
//             System.debug('line: ' + e.getStackTraceString());
//             throw new AuraHandledException(e.getMessage());
//         }
//     }

//     private static Id handleCopyPlaygroupSession(Id SessionId){
//         Playgroup_Session__c originalSession = getPlaygroupSession(sessionId);
//         Playgroup_Session__c newSession = new Playgroup_Session__c(
//             Playgroup_Leader__c = originalSession.Playgroup_Leader__c,
//             Playgroup_Location__c = originalSession.Playgroup_Location__c,
//             Playgroup_Date_Time__c = dateTime.now()
//         );
//         insert newSession;
//         return newSession.Id;
//     }

//     private static Playgroup_Session__c getPlaygroupSession (Id sessionId){
//         Playgroup_Session__c[] sessions = [
//             SELECT Id, Playgroup_Location__c, Playgroup_Leader__c
//             FROM Playgroup_Session__c 
//             WHERE Id =: sessionId 
//             LIMIT 1
//         ];
//         return sessions.isEmpty() ? null : sessions[0];
//     }

//     private static void createNewAnimalPlaygroups(Id oldSessionId, Id newSessionId, Id[] animalsToAdd){
//         Animal_Playgroup__c[] newAnimalPlaygroups = new Animal_Playgroup__c[0];

//         Animal_Playgroup__c[] oldAnimalPlaygroups = [
//             SELECT Id, Animal__c, Common_Playgroup_Note_Sections__c, Common_Playgroup_Notes__c, Play_Rating__c, Playgroup_Individual_Notes__c,
//             (SELECT Id, Contact__c, Novel_Not_Novel__c, Playgroup__c FROM Playgroup_Contacts__r)
//             FROM Animal_Playgroup__c 
//             WHERE Playgroup_Session__c =: oldSessionId
//             AND Animal__c IN: animalsToAdd
//         ];

//         Map<Id, Animal_Playgroup__c> animalPlaygroupMap = new Map<Id, Animal_Playgroup__c>();
//         for(Animal_Playgroup__c oldAnimal : oldAnimalPlaygroups){
//             animalPlaygroupMap.put(oldAnimal.Animal__c, oldAnimal);
//         }

//         for(Id animalToAdd : animalsToAdd){
//             if(animalPlaygroupMap.containsKey(animalToAdd)){
//                 Animal_Playgroup__c oldAnimal = animalPlaygroupMap.get(animalToAdd);
//                 Animal_Playgroup__c newAnimal = new Animal_Playgroup__c(
//                     Animal__c = oldAnimal.Animal__c, 
//                     Common_Playgroup_Note_Sections__c = oldAnimal.Common_Playgroup_Note_Sections__c, 
//                     Common_Playgroup_Notes__c = oldAnimal.Common_Playgroup_Notes__c, 
//                     Play_Rating__c = oldAnimal.Play_Rating__c, 
//                     Playgroup_Individual_Notes__c = oldAnimal.Playgroup_Individual_Notes__c,
//                     Playgroup_Session__c = newSessionId
//                 );
//                 newAnimalPlaygroups.add(newAnimal);
//             }
//             else {
//                 Animal_Playgroup__c newAnimal = new Animal_Playgroup__c(
//                     Animal__c = animalToAdd,
//                     Playgroup_Session__c = newSessionId
//                 );
//                 newAnimalPlaygroups.add(newAnimal);
//             }
//         }

//         insert newAnimalPlaygroups;
//         createPlaygroupContacts(newAnimalPlaygroups, animalPlaygroupMap);
//     }

//     private static void createPlaygroupContacts(Animal_Playgroup__c[] animalPlaygroups, Map<Id, Animal_Playgroup__c> animalPlaygroupMap){
//         Playgroup_Contact__c[] pgContacts = new Playgroup_Contact__c[0];
//         for(Animal_Playgroup__c animal : animalPlaygroups){
//             if(animalPlaygroupMap.containsKey(animal.Animal__c)){
//                 for(Playgroup_Contact__c pgContact : animalPlaygroupMap.get(animal.Animal__c).Playgroup_Contacts__r){
//                     pgContacts.add(
//                         new Playgroup_Contact__c(
//                             Contact__c = pgContact.Contact__c,
//                             Novel_Not_Novel__c = pgContact.Novel_Not_Novel__c,
//                             Playgroup__c = animal.Id
//                         )
//                     );
//                 }
//             }
//         }
//         insert pgContacts;
//     }
