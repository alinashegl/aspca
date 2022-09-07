public with sharing class PlaygroupToDoListController {
    static String[] locationsToExclude = new String[]{
        'Board and Train',
        'Boarding',
        'Field Temp Shelter',
        'Foster Home',
        'Partner Hospital',
        'Response Partner'
    };
    @AuraEnabled(cacheable=true)
    public static List<Animal__c> getPlaygroupAnimals(String location) {
        List<Animal__c> animals = [
            SELECT Id, Name, Animal_Name__c, Gender__c, Shelter_Location__c, Playgroup_Priority_Level__c, Play_Style_Notes__c,
            Play_Category__c, Shelter_Color_Coding__c, Number_of_Playgroups__c, Does_Not_Walk_on_a_Leash__c, Does_Not_Walk_on_a_Leash_Notes__c,
            (SELECT Id FROM Medical_Conditions__r
                WHERE Medical_Condition__c = 'Babesia'
                AND Date_Diagnosed__c <= TODAY
                AND (Date_Resolved__c = null OR Date_Resolved__c > TODAY) LIMIT 1),
            (SELECT Id FROM Play_Pauses__r
                WHERE Type__c = 'Medical'
                AND Play_Pause_Reason__c = 'In Heat'
                AND Start_Date__c <= TODAY
                AND (End_Date__c = null OR End_Date__c > TODAY) LIMIT 1),
            (SELECT Id FROM Animal_Playgroups__r
                WHERE Playgroup_Session__r.Playgroup_Date_Time__c >= TODAY
                AND Playgroup_Session__r.Playgroup_Date_Time__c < TOMORROW LIMIT 1)
            FROM Animal__c
            WHERE Active_Animal__c = true
            AND Type_of_Animal__c = 'Dog'
            AND Current_Location__c NOT IN :locationsToExclude
            AND Play_Category__c NOT IN ('Unevaluated', 'DO NOT PLAY', '')
            AND Id NOT IN (SELECT Animal__c FROM Play_Pause__c WHERE Type__c = 'Behavioral' AND Start_Date__c <= TODAY AND (End_Date__c = null OR End_Date__c >= TODAY))
            AND Location_Filter__c = true
            ORDER BY Id
        ];
        return animals;
    }
    //Neha
    @AuraEnabled(cacheable=true)
    public static Id getReportId(){
        Report[] reports =  [SELECT Id FROM Report where DeveloperName ='Playgroups_Last_2_Days'];
        return reports != null && !reports.isEmpty() ? reports[0].Id : null;
    }

    @AuraEnabled
    public static String createPlaygroup(List<String> animals) {
        String sessionResult = '';
        Playgroup_Session__c session = new Playgroup_Session__c();
        Database.SaveResult sessionSR = Database.insert(session, false);
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
            List<Database.SaveResult> animalSR = Database.insert(animalPlaygroups, false);
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

    @AuraEnabled
    public static Id copyPlaygroupSession(Id sessionId, Id[] animalsToAdd){
        try {
            Id newSessionId = handleCopyPlaygroupSession(sessionId);
            createNewAnimalPlaygroupsFromCopy(sessionId, newSessionId, animalsToAdd);
            return newSessionId;

        } catch (Exception e) {
            System.debug('error: ' + e.getMessage());
            System.debug('line: ' + e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Id editPlaygroup(Id sessionId, Id[] animalsToAdd){
        try {

            handleDeleteAnimalPlaygroups(sessionId, animalsToAdd);

            createNewAnimalPlaygroupsFromEdit(sessionId, animalsToAdd);
            return sessionId;

        } catch (Exception e) {
            System.debug('error: ' + e.getMessage());
            System.debug('line: ' + e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled 
    public static String getUserLocation(){
        try {
            return [SELECT Location__c FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].Location__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static void handleDeleteAnimalPlaygroups(Id sessionId, Id[] animalsToAdd){
        //first delete the playgroup contacts
        delete [SELECT Id FROM Playgroup_Contact__c WHERE Playgroup__r.Playgroup_Session__c =: sessionId AND Playgroup__r.Animal__c NOT IN: animalsToAdd ];
        //now delete the animal playgroups
        delete [SELECT Id FROM Animal_Playgroup__c WHERE Playgroup_Session__c =: sessionId AND Animal__c NOT IN : animalsToAdd];
    }

    private static Id handleCopyPlaygroupSession(Id SessionId){
        Playgroup_Session__c originalSession = getPlaygroupSession(sessionId);
        Playgroup_Session__c newSession = new Playgroup_Session__c(
            Playgroup_Leader__c = originalSession.Playgroup_Leader__c,
            Playgroup_Location__c = originalSession.Playgroup_Location__c,
            Playgroup_Date_Time__c = dateTime.now(),
            Population__c = originalSession.Population__c,
            Contact_Ids__c = originalSession.Contact_Ids__c
        );
        insert newSession;
        return newSession.Id;
    }

    private static Playgroup_Session__c getPlaygroupSession (Id sessionId){
        Playgroup_Session__c[] sessions = [
            SELECT Id, Playgroup_Location__c, Playgroup_Leader__c, Contact_Ids__c, Population__c
            FROM Playgroup_Session__c 
            WHERE Id =: sessionId 
            LIMIT 1
        ];
        return sessions.isEmpty() ? null : sessions[0];
    }

    private static void createNewAnimalPlaygroupsFromEdit(Id sessionId, Id[] animalsToAdd){
        Animal_Playgroup__c[] newAnimalPlaygroups = new Animal_Playgroup__c[0];
        Map<Id, Animal_Playgroup__c> existingAnimalPlaygroupMap = getAnimalPlaygroupsForCurrentSession(sessionId, animalsToAdd);
        for(Id animalToAdd : animalsToAdd){
            if(!existingAnimalPlaygroupMap.containsKey(animalToAdd)){
                Animal_Playgroup__c newAnimal = new Animal_Playgroup__c(
                    Animal__c = animalToAdd,
                    Playgroup_Session__c = sessionId
                );
                newAnimalPlaygroups.add(newAnimal);
            }
        }

        insert newAnimalPlaygroups;
        createPlaygroupContacts(newAnimalPlaygroups, null, sessionId);
    }

    private static void createNewAnimalPlaygroupsFromCopy(Id oldSessionId, Id newSessionId, Id[] animalsToAdd){
        Animal_Playgroup__c[] newAnimalPlaygroups = new Animal_Playgroup__c[0];

        Map<Id, Animal_Playgroup__c> oldAnimalPlaygroupMap = getAnimalPlaygroupsForCurrentSession(oldSessionId, animalsToAdd);

        for(Id animalToAdd : animalsToAdd){
            if(oldAnimalPlaygroupMap.containsKey(animalToAdd)){
                Animal_Playgroup__c oldAnimal = oldAnimalPlaygroupMap.get(animalToAdd);
                Animal_Playgroup__c newAnimal = new Animal_Playgroup__c(
                    Animal__c = oldAnimal.Animal__c, 
                    Play_Rating__c = 'Green', 
                    Playgroup_Individual_Notes__c = oldAnimal.Playgroup_Individual_Notes__c,
                    Playgroup_Session__c = newSessionId
                );
                newAnimalPlaygroups.add(newAnimal);
            }
            else {
                Animal_Playgroup__c newAnimal = new Animal_Playgroup__c(
                    Animal__c = animalToAdd,
                    Playgroup_Session__c = newSessionId
                );
                newAnimalPlaygroups.add(newAnimal);
            }
        }

        insert newAnimalPlaygroups;
        createPlaygroupContacts(newAnimalPlaygroups, oldAnimalPlaygroupMap, newSessionId);
    }

    private static Map<Id, Animal_Playgroup__c> getAnimalPlaygroupsForCurrentSession(Id sessionId, Id[] animalsToAdd){
        Animal_Playgroup__c[] animalPlaygroups = [
            SELECT Id, Animal__c, Common_Playgroup_Note_Sections__c, Common_Playgroup_Notes__c, Playgroup_Individual_Notes__c,
            (SELECT Id, Contact__c, Novel_Not_Novel__c, Playgroup__c FROM Playgroup_Contacts__r)
            FROM Animal_Playgroup__c 
            WHERE Playgroup_Session__c =: sessionId
            AND Animal__c IN: animalsToAdd
        ];

        Map<Id, Animal_Playgroup__c> animalPlaygroupMap = new Map<Id, Animal_Playgroup__c>();
        for(Animal_Playgroup__c animal : animalPlaygroups){
            animalPlaygroupMap.put(animal.Animal__c, animal);
        }

        return animalPlaygroupMap;
    }

    private static void createPlaygroupContacts(Animal_Playgroup__c[] animalPlaygroups, Map<Id, Animal_Playgroup__c> oldAnimalPlaygroupMap, Id newSessionId){
        Playgroup_Session__c session = [SELECT Id, Contact_Ids__c FROM Playgroup_Session__c WHERE Id =: newSessionId LIMIT 1];
        if(session.Contact_Ids__c != null){
            String[] contactList = session.Contact_Ids__c.split(',');
            Playgroup_Contact__c[] pgContacts = new Playgroup_Contact__c[0];
            for(Animal_Playgroup__c animal : animalPlaygroups){
                if(oldAnimalPlaygroupMap != null && oldAnimalPlaygroupMap.containsKey(animal.Animal__c)){
                    for(Playgroup_Contact__c pgContact : oldAnimalPlaygroupMap.get(animal.Animal__c).Playgroup_Contacts__r){
                        pgContacts.add(
                            new Playgroup_Contact__c(
                                Contact__c = pgContact.Contact__c,
                                Novel_Not_Novel__c = pgContact.Novel_Not_Novel__c,
                                Playgroup__c = animal.Id
                            )
                        );
                    }
                }
                else {
                    for(String con : contactList){
                        pgContacts.add(
                            new Playgroup_Contact__c(
                                Contact__c = con,
                                Novel_Not_Novel__c = 'Familiar',
                                Playgroup__c = animal.Id
                            )
                        );
                    }
                }
            }
            insert pgContacts;
        }
    }
}