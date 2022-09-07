@isTest
private class test_playgroupSessionLWCController {
    @isTest 
    static void getPlaygroupSession_hasSession(){
        Playgroup_Session__c session = TestDataFactory.createPlaygroupSessionWithAnimals();

        test.startTest();
            Playgroup_Session__c returnedSession = playgroupSessionLWCController.getPlaygroupSession(session.Id);
        test.stopTest();

        System.assert(returnedSession != null, 'No session was returned');
    }

    @isTest 
    static void getPlaygroupSession_noSession(){
        test.startTest();
            Playgroup_Session__c returnedSession = playgroupSessionLWCController.getPlaygroupSession(null);
        test.stopTest();

        System.assert(returnedSession == null, 'Should have returned a null value');
    }

    @isTest 
    static void animalPlaygroups_hasPlaygroups(){
        Playgroup_Session__c session = TestDataFactory.createPlaygroupSessionWithAnimals();

        test.startTest();
            Animal_Playgroup__c[] returnedPlaygroups = playgroupSessionLWCController.animalPlaygroups(session.Id);
        test.stopTest();

        System.assert(!returnedPlaygroups.isEmpty(), 'Should have returned some animal playgroups, but was empty');
    }

    @isTest 
    static void animalPlaygroups_noPlaygroups(){
        Contact c = testDataFactory.createContact();

        Playgroup_Session__c session = new Playgroup_Session__c(
            Playgroup_Location__c = 'MRC Indoor Play Yard',
            Playgroup_Leader__c = c.Id
        );
        insert session;

        test.startTest();
            Animal_Playgroup__c[] returnedPlaygroups = playgroupSessionLWCController.animalPlaygroups(session.Id);
        test.stopTest();

        System.assert(returnedPlaygroups.isEmpty(), 'List of animal playgroups should be empty, but was: ' + returnedPlaygroups);
    }

    @isTest 
    static void getPlaygroupContacts_hasContacts(){
        Contact c1 = testDataFactory.createContact();
        Contact c2 = testDataFactory.createContact();
        String contactIds = c1.Id + ',' + c2.Id;

        test.startTest();
            Contact[] returnedContacts = playgroupSessionLWCController.getPlaygroupContacts(contactIds);
        test.stopTest();

        System.assertEquals(c1.Id, returnedContacts[0].Id);
        System.assertEquals(c2.Id, returnedContacts[1].Id);
    }

    @isTest 
    static void getPlaygroupContacts_noContacts(){
        test.startTest();
            Contact[] returnedContacts = playgroupSessionLWCController.getPlaygroupContacts(null);
        test.stopTest();

        System.assertEquals(null, returnedContacts);
    }

    @isTest 
    static void addContact_success(){
        Playgroup_Session__c session = TestDataFactory.createPlaygroupSessionWithAnimals();
        Contact c = testDataFactory.createContact();
        Animal__c newAnimal = TestDataFactory.createAnimalWithName('Doggo1');

        Playgroup_Contact__c[] initialCons = [SELECT Id, Contact__c FROM Playgroup_Contact__c WHERE Playgroup__r.Playgroup_Session__c =: session.Id];

        test.startTest();
            String response = playgroupSessionLWCController.addContact(session.Id, c.Id, new Id[]{newAnimal.Id});
        test.stopTest();

        System.assertEquals('success', response);
        Playgroup_Contact__c[] cons = [SELECT Id FROM Playgroup_Contact__c WHERE Playgroup__r.Playgroup_Session__c =: session.Id];
        System.assertEquals(initialCons.size() + 1, cons.size());
    }

    @isTest 
    static void removeContact_success(){
        Playgroup_Session__c session = TestDataFactory.createPlaygroupSessionWithAnimals();
        Playgroup_Contact__c[] initialCons = [SELECT Id, Contact__c FROM Playgroup_Contact__c WHERE Playgroup__r.Playgroup_Session__c =: session.Id];
        Set<Id> conIds = new Set<Id>();
        for(Playgroup_Contact__c pc : initialCons){
            conIds.add(pc.Id);
        }
        // List<Id> conIdList = new List<Id>(conids);
        Contact c1 = testDataFactory.createContact();
        Contact c2 = testDataFactory.createContact();
        session.Contact_Ids__c = c1.Id + ',' + c2.Id + ',' + string.join(new List<Id>(conids),',');
        update session;

        test.startTest();
            String response = playgroupSessionLWCController.removeContact(session.Id, initialCons[0].Contact__c);
        test.stopTest();

        System.assertEquals('success', response);
        System.debug('c1: ' + c1.Id);
        System.debug('c2: ' + c2.Id);
        System.debug('initialCons: ' + initialCons);
        Playgroup_Contact__c[] cons = [SELECT Id, Contact__c FROM Playgroup_Contact__c WHERE Playgroup__r.Playgroup_Session__c =: session.Id];

        System.assertEquals(initialCons.size() - 1, cons.size(), 'should have returned ' + (initialCons.size() - 1) + ' playgroup contacts, instead returned: ' + cons);
    }

    @isTest 
    static void removeContact_contactNotInContactIds(){
        Playgroup_Session__c session = TestDataFactory.createPlaygroupSessionWithAnimals();
        Playgroup_Contact__c[] initialCons = [SELECT Id, Contact__c FROM Playgroup_Contact__c WHERE Playgroup__r.Playgroup_Session__c =: session.Id];
        Contact c1 = testDataFactory.createContact();
        Contact c2 = testDataFactory.createContact();
        session.Contact_Ids__c = c1.Id + ',' + c2.Id;
        update session;

        test.startTest();
            String response = playgroupSessionLWCController.removeContact(session.Id, initialCons[0].Contact__c);
        test.stopTest();

        System.assertEquals('success', response);
        Playgroup_Contact__c[] cons = [SELECT Id, Contact__c FROM Playgroup_Contact__c WHERE Playgroup__r.Playgroup_Session__c =: session.Id];
        System.assertEquals(initialCons.size() - 1, cons.size(), 'should have returned ' + (initialCons.size()) + ' playgroup contacts, instead returned: ' + cons);
    }    

    @isTest 
    static void removeFromPlaygroup_success(){
        Playgroup_Session__c session = TestDataFactory.createPlaygroupSessionWithAnimals();
        Animal_playgroup__c[] initialAnimals = [SELECT Id FROM Animal_playgroup__c WHERE Playgroup_Session__c =: session.Id];

        test.startTest();
            String response = playgroupSessionLWCController.removeFromPlaygroup(initialAnimals[0].Id);
        test.stopTest();

        System.assertEquals('success', response);
        Animal_playgroup__c[] animals = [SELECT Id FROM Animal_playgroup__c WHERE Playgroup_Session__c =: session.Id];
        System.assert(animals.isEmpty(), 'should have returned no animal playgroups, instead returned: ' + animals);
    }

    @isTest 
    static void getAnimalContacts_hasContacts(){
        Playgroup_Session__c session = TestDataFactory.createPlaygroupSessionWithAnimals();
        Animal_playgroup__c[] animalPlaygroups = [SELECT Id FROM Animal_playgroup__c WHERE Playgroup_Session__c =: session.Id];

        test.startTest();
        Playgroup_Contact__c[] pgContacts = playgroupSessionLWCController.getAnimalContacts(animalPlaygroups[0].Id);
        test.stopTest();

        System.assert(!pgContacts.isEmpty(), 'Should have returned contacts, instead returned: ' + pgContacts);
    }

    @isTest 
    static void getAnimalContacts_noContacts(){
        Playgroup_Session__c session = TestDataFactory.createPlaygroupSessionWithAnimals();
        Playgroup_Contact__c[] initialCons = [SELECT Id, Contact__c, Playgroup__c FROM Playgroup_Contact__c WHERE Playgroup__r.Playgroup_Session__c =: session.Id];
        for(Playgroup_Contact__c pg : initialCons){
            playgroupSessionLWCController.removeContact(session.Id, pg.Contact__c);
        }

        test.startTest();
        Playgroup_Contact__c[] pgContacts = playgroupSessionLWCController.getAnimalContacts(initialCons[0].Playgroup__c);
        test.stopTest();

        System.assertEquals(null, pgContacts, 'Should have returned an emtpylist, instead returned: ' + pgContacts);
    }

    @isTest 
    static void getPlaygroupSessionInfo_hasInfo(){
        Playgroup_Session__c session = TestDataFactory.createPlaygroupSessionWithAnimals();
        Contact c1 = testDataFactory.createContact();
        Contact c2 = testDataFactory.createContact();
        session.Contact_Ids__c = c1.Id + ',' + c2.Id;
        update session;

        test.startTest();
        playgroupSessionLWCController.playgroupSessionInfo sessionInfo = playgroupSessionLWCController.getPlaygroupSessionInfo(session.Id);
        test.stopTest();

        System.assert(sessionInfo != null, 'Should have returned some info, instead: ' + sessionInfo);
        System.assert(!sessionInfo.animalPlaygroups.isEmpty(), 'Should have returned some animal playgroups, instead: ' + sessionInfo.animalPlaygroups);
        System.assert(sessionInfo.playgroupSession != null, 'Should have returned some playgroup session info, instead: ' + sessionInfo.playgroupSession);
        System.assert(!sessionInfo.playgroupContacts.isEmpty(), 'Should have returned some playgroup contacts, instead: ' + sessionInfo.playgroupContacts);
    }

    @isTest 
    static void getAnimalInfo_hasInfo(){
        Playgroup_Session__c session = TestDataFactory.createPlaygroupSessionWithAnimals();
        Contact c1 = testDataFactory.createContact();
        Contact c2 = testDataFactory.createContact();
        session.Contact_Ids__c = c1.Id + ',' + c2.Id;
        update session;

        Animal_Playgroup__c[] aPGList = [SELECT Id FROM Animal_Playgroup__c LIMIT 1];
        System.assert(!aPGList.isEmpty(), 'Should have returned a list of animal playgroups, but was empty');

        test.startTest();
        playgroupSessionLWCController.playgroupAnimalInfo info = playgroupSessionLWCController.getAnimalInfo(aPGList[0].Id);
        test.stopTest();

        System.assertNotEquals(null, info, 'Should have returned playgroup animal info, but was null');
        System.assertNotEquals(null, info.animal, 'Should have returned an Animal Playgroup record, but was null');
        System.assertNotEquals(null, info.animalContacts, 'Should have returned animal contacts, but was null');

    }

}