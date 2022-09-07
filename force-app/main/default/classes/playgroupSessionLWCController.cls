public with sharing class playgroupSessionLWCController {
    @AuraEnabled (cacheable=true)
    public static playgroupSessionInfo getPlaygroupSessionInfo(Id sessionId){
        try {
            playgroupSessionInfo info = new playgroupSessionInfo();
            info.animalPlaygroups = animalPlaygroups(sessionId);
            info.playgroupSession = getPlaygroupSession(sessionId);
            info.playgroupContacts = getPlaygroupContacts(info.playgroupSession.Contact_Ids__c);
            return info;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @testVisible
    private static Playgroup_Session__c getPlaygroupSession (Id sessionId){
        Playgroup_Session__c[] sessions = [
            SELECT Id, Name, Playgroup_Location__c, Playgroup_Leader__c, Contact_Ids__c, Playgroup_Date_Time__c
            FROM Playgroup_Session__c 
            WHERE Id =: sessionId 
            LIMIT 1
        ];
        return sessions.isEmpty() ? null : sessions[0];
    }

    @testVisible
    private static Animal_Playgroup__c[] animalPlaygroups (Id sessionId){
        return [SELECT Id, Animal__c, Animal_Name__c FROM Animal_Playgroup__c WHERE Playgroup_Session__c =: sessionId ORDER BY Animal_Name__c ASC];
    }

    @testVisible
    private static Contact[] getPlaygroupContacts(String contactIds){
        if(contactIds != null){
            Id[] contactIdList = contactIds.split(',');
            return [SELECT Id, Name FROM Contact WHERE Id IN : contactIdList ORDER BY Name ASC];
        } else {
            return null;
        }
    }

    @AuraEnabled
    public static String addContact(Id sessionId, Id contactId, Id[] animalIdsWithNovelContact){
        try{
            Playgroup_Contact__c[] pgContacts = new Playgroup_Contact__c[0];
            for(Animal_Playgroup__c animal : animalPlaygroups(sessionId)){
                Playgroup_Contact__c pg = new Playgroup_Contact__c(
                    Playgroup__c = animal.Id,
                    Contact__c = contactId,
                    Novel_Not_Novel__c = animalIdsWithNovelContact.contains(animal.Id) ? 'Novel' : 'Familiar'
                );
                pgContacts.add(pg);
            }

            insert pgContacts;

            Playgroup_Session__c session = [SELECT Id, Contact_Ids__c FROM Playgroup_Session__c WHERE Id =: sessionId LIMIT 1];
            session.Contact_Ids__c = session.Contact_Ids__c == null ? String.valueOf(contactId) : session.Contact_Ids__c + ',' + String.valueOf(contactId);
            System.debug('session: ' + session);
            update session;

            return 'success';

        } catch(exception error) {
            throw new AuraHandledException(error.getMessage());
        }
    }

    @AuraEnabled
    public static String removeContact(Id sessionId, Id contactId){
        try{
            delete [SELECT Id FROM Playgroup_Contact__c WHERE Contact__c =: contactId AND Playgroup__r.Playgroup_Session__c =: sessionId];

            Playgroup_Session__c session = [SELECT Id, Contact_Ids__c FROM Playgroup_Session__c WHERE Id =: sessionId LIMIT 1];
            if(session.Contact_Ids__c != null){
                String[] contactList = session.Contact_Ids__c.split(',');
                Integer index = contactList.indexOf(contactId);
                if (index > -1) {
                    contactList.remove(index);
                }
                session.Contact_Ids__c = string.join(contactList, ',');
                update session;
            }
            return 'success';
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

    @AuraEnabled (cacheable=true)
    public static playgroupAnimalInfo getAnimalInfo(Id playgroupAnimalId){
        try {
            playgroupAnimalInfo info = new playgroupAnimalInfo();
            info.animal = getAnimalPlaygroupById(playgroupAnimalId);
            info.animalContacts = getAnimalContacts(playgroupAnimalId);
            return info;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static Animal_Playgroup__c getAnimalPlaygroupById(Id playgroupAnimalId){
        return [SELECT Id, Animal__c, Animal_Name__c, Play_Rating__c FROM Animal_Playgroup__c WHERE Id =: playgroupAnimalId LIMIT 1];

    }

    public static Playgroup_Contact__c[] getAnimalContacts(Id playgroupAnimalId){
        Playgroup_Contact__c[] contactList = [SELECT Id, Contact__r.Name, Novel_Not_Novel__c FROM Playgroup_Contact__c WHERE Playgroup__c =: playgroupAnimalId AND Novel_Not_Novel__c != 'PG Leader' ORDER BY Contact__r.Name ASC];
        return !contactList.isEmpty() ? contactList : null;
    }

    public class playgroupSessionInfo{
        @AuraEnabled public Playgroup_Session__c playgroupSession {get; set;}
        @AuraEnabled public Animal_Playgroup__c[] animalPlaygroups {get; set;}
        @AuraEnabled public Contact[] playgroupContacts {get; set;}
    }

    public class playgroupAnimalInfo{
        @AuraEnabled public Animal_Playgroup__c animal {get; set;}
        @AuraEnabled public Playgroup_Contact__c[] animalContacts {get; set;}
    }
}