public with sharing class PlaygroupSessionTriggerHandler {
    public static void insertHandler(Playgroup_Session__c[] newSessions){
        //if playgroup leader is populated, need to create a playgroup contact for each of the child animal playgroups
        handlePlaygroupleaderPopulated(newSessions);

    }

    public static void updateHandler(Playgroup_Session__c[] updatedSessions, Map<Id, Playgroup_Session__c> oldSessionMap){
        //if playgroup leader is has changed, need to update, create, edit the playgroup contact for each of the child animal playgroups
        handlePlaygroupLeaderUpdated(updatedSessions, oldSessionMap);
    }
    
    //Neha :#376 Card
    public static void UpdateNoteToAnimal(Map<Id, Playgroup_Session__c> newDataMap,Map<Id, Playgroup_Session__c> olDataMap){
        List<Animal_Playgroup__c> animalToUpdate = new List<Animal_Playgroup__c>();
        Set<Id> psIdSet = new Set<Id>();
        for(Playgroup_Session__c ps : newDataMap.values()){
            if(ps.Playgroup_Notes__c != olDataMap.get(ps.id).Playgroup_Notes__c) {
                psIdSet.add(ps.Id);
            }
        }

        if(!psIdSet.isEmpty()){
            for(Animal_Playgroup__c animal : [SELECT Id,Playgroup_Session_Notes__c, Playgroup_Session__c FROM Animal_Playgroup__c WHERE Playgroup_Session__c IN : psIdSet] ){
                animal.Playgroup_Session_Notes__c = newDataMap.get(animal.Playgroup_Session__c)?.Playgroup_Notes__c;
                animalToUpdate.add(animal);
            }
            Update animalToUpdate;
        }
    }

    private static void handlePlaygroupleaderPopulated(Playgroup_Session__c[] sessions){
        //need to filter out the sessions without leaders
        Map<Id, Playgroup_Session__c> sessionsWithLeaders = filterSessionsWithLeaders(sessions);

        //query for the animal playgroups associated with the sessions
        Animal_Playgroup__c[] animalPlaygroups = getAnimalPlaygroups(sessionsWithLeaders.keySet());

        //prep and insert the playgroup contacts
        createPlaygroupContacts(sessionsWithLeaders, animalPlaygroups);
    }

    public static void handlePlaygroupLeaderUpdated(Playgroup_Session__c[] updatedSessions, Map<Id, Playgroup_Session__c> oldSessionMap){
        //need to create a map of sessions that need contacts created, updated or deleted
        Map<String, Map<Id, Playgroup_Session__c>> playgroupSessionActionMap = prepUPdatedSessionMap(updatedSessions, oldSessionMap);

        //create the new playgroup contacts
        if(!playgroupSessionActionMap.get('added')?.keySet().isEmpty()){
            Animal_Playgroup__c[] animalPlaygroupsToAddLeader = getAnimalPlaygroups(playgroupSessionActionMap.get('added')?.keySet());
            createPlaygroupContacts(playgroupSessionActionMap.get('added'), animalPlaygroupsToAddLeader);
        }

        //delete the playgroup contacts where the leader has been deleted
        if(!playgroupSessionActionMap.get('removed')?.keySet().isEmpty()){
            Playgroup_Contact__c[] playgroupContactsToDelete = getPlaygroupLeaderContacts(playgroupSessionActionMap.get('removed')?.keySet());
            delete playgroupContactsToDelete;
        }

        //modify the existing playgroup leader with the updated contact
        if(!playgroupSessionActionMap.get('updated')?.keySet().isEmpty()){
            Playgroup_Contact__c[] playgroupContactsToUpdate = getPlaygroupLeaderContacts(playgroupSessionActionMap.get('updated')?.keySet());
            updatePlaygroupContacts(playgroupSessionActionMap.get('updated'), playgroupContactsToUpdate);
        }


    }

    @testVisible
    private static Map<String, Map<Id, Playgroup_Session__c>> prepUpdatedSessionMap(Playgroup_Session__c[] sessions, Map<Id, Playgroup_Session__c> oldSessionMap){
        Map<String, Map<Id, Playgroup_Session__c>> sessionActionMap = new Map<String, Map<Id, Playgroup_Session__c>>{
            'removed' => new Map<Id, Playgroup_Session__c>(),
            'updated' => new Map<Id, Playgroup_Session__c>(),
            'added' => new Map<Id, Playgroup_Session__c>()
        };

        for(Playgroup_Session__c session : sessions){
            Playgroup_Session__c oldSession = oldSessionMap.get(session.Id);
            //if the playgroup leader hasn't changed we can move on to the next session
            if(session.Playgroup_Leader__c == oldSession.Playgroup_Leader__c) continue;
            if(session.Playgroup_Leader__c == null){
                sessionActionMap.get('removed').put(session.Id, session);
            }
            else if(oldSession.Playgroup_Leader__c == null){
                sessionActionMap.get('added').put(session.Id, session);
            }
            else {
                sessionActionMap.get('updated').put(session.Id, session);
            }
        }

        return sessionActionMap;
    }

    @testVisible
    private static Map<Id, Playgroup_Session__c> filterSessionsWithLeaders(Playgroup_Session__c[] sessions){
        Map<Id, Playgroup_Session__c> sessionsWithLeaders = new Map<Id, Playgroup_Session__c>();

        for(Playgroup_Session__c session: sessions){
            if(session.Playgroup_Leader__c != null){
                sessionsWithLeaders.put(session.Id, session);
            }
        }
        return sessionsWithLeaders;
    }

    @testVisible
    private static Animal_Playgroup__c[] getAnimalPlaygroups(Set<Id> sessionIds){
        return [SELECT Id, Playgroup_Session__c FROM Animal_Playgroup__c WHERE Playgroup_Session__c IN: sessionIds];
    }

    @testVisible
    private static Playgroup_Contact__c[] getPlaygroupLeaderContacts(Set<Id> sessionIds){
        return [SELECT Id, Contact__c, Playgroup__r.Playgroup_Session__c FROM Playgroup_Contact__c WHERE Playgroup__r.Playgroup_Session__c IN: sessionIds AND Novel_Not_Novel__c = 'PG Leader'];
    }

    @testVisible
    private static void createPlaygroupContacts(Map<Id, Playgroup_Session__c> sessionMap, Animal_Playgroup__c[] animalPlaygroups){
        Playgroup_Contact__c[] newContacts = new Playgroup_Contact__c[0];

        if(!sessionMap.isEmpty() && !animalPlaygroups.isEmpty()){
            for(Animal_Playgroup__c animal : animalPlaygroups){
                if(sessionMap.containsKey(animal.Playgroup_Session__c)){
                    Playgroup_Session__c session = sessionMap.get(animal.Playgroup_Session__c);
                    Playgroup_Contact__c contact = new Playgroup_Contact__c(
                        Novel_Not_Novel__c = 'PG Leader',
                        Contact__c = session.Playgroup_Leader__c,
                        Playgroup__c = animal.Id
                    );
                    newContacts.add(contact);
                }
            }

            insert newContacts;
        }
    }

    @testVisible
    private static void updatePlaygroupContacts(Map<Id, Playgroup_Session__c> sessionMap, Playgroup_Contact__c[] pgContacts){
        for(Playgroup_Contact__c contact : pgContacts){
            if(sessionMap.containsKey(contact.Playgroup__r.Playgroup_Session__c)){
                Playgroup_Session__c session = sessionMap.get(contact.Playgroup__r.Playgroup_Session__c);
                contact.Contact__c = session.Playgroup_Leader__c;
            }
        }

        update pgContacts;
    }
}