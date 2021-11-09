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

    // @isTest 
    // static void createNewPlaygroupAnimals_hasAnimalsToAdd(){
    //     Playgroup_Session__c session = TestDataFactory.createPlaygroupSessionWithAnimals();
    //     Contact c1 = testDataFactory.createContact();
    //     Contact c2 = testDataFactory.createContact();
    //     session.Contact_Ids__c = c1.Id + ',' + c2.Id;
    //     update session;
        
    //     playgroupSessionLWCController.playgroupSessionInfo sessionInfo = new playgroupSessionLWCController.playgroupSessionInfo();
    //     sessionInfo.playgroupSession = session;
    //     Animal__c newAnimal = TestDataFactory.createAnimalWithName('Doggo1');

    //     test.startTest();
    //         Animal_Playgroup__c[] returnedAnimalPlaygroup = playgroupSessionLWCController.createNewPlaygroupAnimals(sessionInfo, new Id[]{newAnimal.Id});
    //     test.stopTest();

    //     System.assert(!returnedAnimalPlaygroup.isEmpty(), 'Should have returned an animal playgroup, instead returned: ' + returnedAnimalPlaygroup);
    //     System.assertEquals(session.Id, returnedAnimalPlaygroup[0].Playgroup_Session__c);
    //     System.assertEquals(newAnimal.Id, returnedAnimalPlaygroup[0].Animal__c);

    //     Playgroup_Contact__c[] pgCons = [SELECT Id, Contact__c FROM Playgroup_Contact__c WHERE Playgroup__c =: returnedAnimalPlaygroup[0].Id];
    //     System.assertEquals(2, pgCons.Size());
    // }

    @isTest 
    static void getAnimalList_hasAnimals(){
        Playgroup_Session__c session = TestDataFactory.createPlaygroupSessionWithAnimals();

        test.startTest();
            Animal_Playgroup__c[] returnedAnimalPlaygroups = playgroupSessionLWCController.getAnimalList(session.Id);
        test.stopTest();

        System.assert(!returnedAnimalPlaygroups.isEmpty(), 'Returned animal playgroups should not be empty');
    }

    @isTest 
    static void getAnimalList_noAnimals(){
        Contact c = testDataFactory.createContact();

        Playgroup_Session__c session = new Playgroup_Session__c(
            Playgroup_Location__c = 'MRC Indoor Play Yard',
            Playgroup_Leader__c = c.Id
        );
        insert session;

        test.startTest();
            Animal_Playgroup__c[] returnedAnimalPlaygroups = playgroupSessionLWCController.getAnimalList(session.Id);
        test.stopTest();

        System.assert(!returnedAnimalPlaygroups.isEmpty(), 'Returned animal playgroups should not be empty');
    }

}
