@isTest
private class test_PlaygroupSessionTriggerHandler {
    @isTest 
    static void getAnimalPlaygroups(){
        Playgroup_Session__c pgs = TestDataFactory.createPlaygroupSessionWithAnimals();
        Set<Id> pgIds = new Set<Id>();
        pgIds.add(pgs.Id);
        
        test.startTest();
            Animal_Playgroup__c[] aPgs = PlaygroupSessionTriggerHandler.getAnimalPlaygroups(pgIds);
        test.stopTest();
        
        System.assert(!apgs.isEmpty(), 'Should have returned a list of animal playgroups, but was empty');
    }

    @isTest 
    static void getPlaygroupLeaderContacts(){
        Playgroup_Session__c pgs = TestDataFactory.createPlaygroupSessionWithAnimals();
        Set<Id> pgIds = new Set<Id>();
        pgIds.add(pgs.Id);
        
        test.startTest();
            Playgroup_Contact__c[] pgCs = PlaygroupSessionTriggerHandler.getPlaygroupLeaderContacts(pgIds);
        test.stopTest();
        
        System.assert(!pgCs.isEmpty(), 'Should have returned a list of animal playgroups, but was empty');
    }

    @isTest 
    static void getAnimalPlaygroupsNoIds(){
        test.startTest();
            Animal_Playgroup__c[] aPgs = PlaygroupSessionTriggerHandler.getAnimalPlaygroups(null);
        test.stopTest();
        
        System.assert(apgs.isEmpty(), 'Should have returned an empty list, but was: ' + aPgs);
    }

    @isTest 
    static void getPlaygroupLeaderContactsNoIds(){
        test.startTest();
            Playgroup_Contact__c[] pgCs = PlaygroupSessionTriggerHandler.getPlaygroupLeaderContacts(null);
        test.stopTest();
        
        System.assert(pgCs.isEmpty(), 'Should have returned an empty list, but was: ' + pgCs);
    }

    @iSTest 
    static void createPlaygroupContactsSuccess(){
        Playgroup_Session__c pgs = createPlaygroupSession();
        Animal__c dog = TestDataFactory.createAnimalWithName('testDog');
        Animal_Playgroup__c[] aPgs = createAnimalPlaygroups(pgs.Id, new Animal__c[]{dog});
        Map<Id, Playgroup_Session__c> sessionMap = new Map<Id, Playgroup_Session__c>();
        sessionMap.put(pgs.Id, pgs);

        test.startTest();
            PlaygroupSessionTriggerHandler.createPlaygroupContacts(sessionMap, aPgs);
        test.stopTest();

        System.assert(![SELECT Id FROM Playgroup_Contact__c WHERE Playgroup__r.Playgroup_Session__c =: pgs.Id].isEmpty(),
        'should have returned a list of Playgroup Contacts, but was empty');
    }

    @iSTest 
    static void createPlaygroupContactsNoContacts(){
        test.startTest();
            PlaygroupSessionTriggerHandler.createPlaygroupContacts(new Map<Id, Playgroup_Session__c>(), new Animal_Playgroup__c[0]) ;
        test.stopTest();

        Playgroup_Contact__c[] pgCs = [SELECT Id FROM Playgroup_Contact__c];

        System.assert(pgCs.isEmpty(),
        'should have returned an empty list of Playgroup Contacts, but was: ' + pgCs);
    }

    @isTest 
    static void updatePlaygroupContactsSuccess(){
        Playgroup_Session__c pgs = TestDataFactory.createPlaygroupSessionWithAnimals();
        Map<Id, Playgroup_Session__c> pgsMap = new Map<Id, Playgroup_Session__c>();
        pgsMap.put(pgs.Id, pgs);
        Playgroup_Contact__c[] pgCs = [SELECT Id, Contact__c, Playgroup__r.Playgroup_Session__c FROM Playgroup_Contact__c WHERE Playgroup__r.Playgroup_Session__c =: pgs.Id];
        Contact newCon = TestDataFactory.createContact();

        pgs.Playgroup_Leader__c =  newCon.Id;

        test.startTest();
            PlaygroupSessionTriggerHandler.updatePlaygroupContacts(pgsMap, pgCs);
        test.stopTest();

        Playgroup_Contact__c[] updatedPgCs = [SELECT Id FROM Playgroup_Contact__c WHERE Contact__c =: newCon.Id];
        System.assert(!updatedPgCs.isEmpty(), 'Should have returned the playgroup contact, but was empty');
    }

    @isTest 
    static void updatePlaygroupContactsEmptyParams(){
        test.startTest();
            PlaygroupSessionTriggerHandler.updatePlaygroupContacts(new Map<Id, Playgroup_Session__c>(), new Playgroup_Contact__c[0]);
        test.stopTest();

        Playgroup_Contact__c[] updatedPgCs = [SELECT Id FROM Playgroup_Contact__c];
        System.assert(updatedPgCs.isEmpty(), 'Should have returned an empty list, but was: ' + updatedPgCs);
    }

    @isTest 
    static void filterSessionsWithLeaders(){
        Playgroup_Session__c session1 = TestDataFactory.createPlaygroupSessionWithAnimals();
        Playgroup_Session__c session2 = createPlaygroupSession();
        session2.Playgroup_Leader__c = null;

        test.startTest();
            Map<Id, Playgroup_Session__c> sessionsWithLeaders = PlaygroupSessionTriggerHandler.filterSessionsWithLeaders(new Playgroup_Session__c[]{session1, session2});
        test.stopTest();

        System.assert(sessionsWithLeaders.containsKey(session1.Id), 'Map should have included session1 becuase it has a leader');
        System.assert(!sessionsWithLeaders.containsKey(session2.Id), 'Map should not have included session2 becuase it does not have a leader');
    }

    @isTest 
    static void prepUpdatedSessionMap(){
        Playgroup_Session__c sessionRemoveLeader = createPlaygroupSession();
        Playgroup_Session__c sessionAddLeader = createPlaygroupSession();
        sessionAddLeader.Playgroup_Leader__c = TestDataFactory.createContact().Id;
        Playgroup_Session__c sessionUpdateLeader = createPlaygroupSession();

        //set up the 'old' data
        Map<Id, Playgroup_Session__c> oldSessionMap = new Map<Id, Playgroup_Session__c>();
        oldSessionMap.put(sessionRemoveLeader.Id, new Playgroup_Session__c(
            Id = sessionRemoveLeader.Id,
            Playgroup_Leader__c = sessionRemoveLeader.Playgroup_Leader__c
            )
        );

        oldSessionMap.put(sessionAddLeader.Id, new Playgroup_Session__c(
            Id = sessionAddLeader.Id,
            Playgroup_Leader__c = null
            )
        );

        oldSessionMap.put(sessionUpdateLeader.Id, new Playgroup_Session__c(
            Id = sessionUpdateLeader.Id,
            Playgroup_Leader__c = TestDataFactory.createContact().Id
            )
        );

        sessionRemoveLeader.Playgroup_Leader__c = null;
        test.startTest();
            Map<String, Map<Id, Playgroup_Session__c>> updatedSessionMap = PlaygroupSessionTriggerHandler.prepUpdatedSessionMap(
                new Playgroup_Session__c[]{sessionRemoveLeader, sessionAddLeader, sessionUpdateLeader},
                oldSessionMap
            );
        test.stopTest();

        System.assert(updatedSessionMap.get('removed').containsKey(sessionRemoveLeader.Id));
        System.assert(updatedSessionMap.get('updated').containsKey(sessionUpdateLeader.Id));
        System.assert(updatedSessionMap.get('added').containsKey(sessionAddLeader.Id));
        
    }

    @isTest 
    static void handlePlaygroupLeaderUpdatedAddLeader(){
        Playgroup_Session__c pgs = TestDataFactory.createPlaygroupSessionWithAnimals();
        Playgroup_Session__c oldPgs = new Playgroup_Session__c(
            Id = pgs.Id,
            Playgroup_Leader__c = null
        );

        //need to delete the playgroup contacts created in the dataFactory
        delete [SELECT Id FROM Playgroup_Contact__c];

        test.startTest();
            PlaygroupSessionTriggerHandler.handlePlaygroupLeaderUpdated(new Playgroup_Session__c[]{pgs}, new Map<Id, Playgroup_Session__c>{pgs.Id => oldPgs});
        test.stopTest();

        Playgroup_Contact__c[] pgCList = [SELECT Id FROM Playgroup_Contact__c WHERE Playgroup__r.Playgroup_Session__c =: pgs.Id];
        System.assert(!pgCList.isEmpty(), 'should have returned newly created pg contacts, but was empty');
    }

    @isTest 
    static void handlePlaygroupLeaderUpdatedRemoveLeader(){
        Playgroup_Session__c oldPgs = TestDataFactory.createPlaygroupSessionWithAnimals();
        Playgroup_Session__c pgs = new Playgroup_Session__c(
            Id = oldPgs.Id,
            Playgroup_Leader__c = null
        );

        System.assert(![SELECT Id FROM Playgroup_Contact__c WHERE Playgroup__r.Playgroup_Session__c =: pgs.Id AND Novel_Not_Novel__c = 'PG Leader'].isEmpty());

        test.startTest();
            PlaygroupSessionTriggerHandler.handlePlaygroupLeaderUpdated(new Playgroup_Session__c[]{pgs}, new Map<Id, Playgroup_Session__c>{pgs.Id => oldPgs});
        test.stopTest();

        Playgroup_Contact__c[] pgCList = [SELECT Id FROM Playgroup_Contact__c WHERE Playgroup__r.Playgroup_Session__c =: pgs.Id AND Novel_Not_Novel__c = 'PG Leader'];
        System.assert(pgCList.isEmpty(), 'should have returned an empty list becuase the playgroupContacts should have been deleted, but was: ' + pgCList);
    }

    @isTest 
    static void handlePlaygroupLeaderUpdatedUpdateLeader(){
        Playgroup_Session__c oldPgs = TestDataFactory.createPlaygroupSessionWithAnimals();
        System.debug('oldPgs: ' + oldPgs);
        Contact con = TestDataFactory.createContact();
        Playgroup_Session__c pgs = new Playgroup_Session__c(
            Id = oldPgs.Id,
            Playgroup_Leader__c = con.Id
        );

        Playgroup_Contact__c[] pgCList = [SELECT Id, Contact__c FROM Playgroup_Contact__c WHERE Playgroup__r.Playgroup_Session__c =: pgs.Id AND Novel_Not_Novel__c = 'PG Leader'];
        System.debug('pgCList: ' + pgCList);
        System.assert(pgClist.size() == 1);
        System.assertEquals(oldPgs.Playgroup_Leader__c, pgClist[0].Contact__c);

        test.startTest();
            PlaygroupSessionTriggerHandler.handlePlaygroupLeaderUpdated(new Playgroup_Session__c[]{pgs}, new Map<Id, Playgroup_Session__c>{pgs.Id => oldPgs});
        test.stopTest();

        Playgroup_Contact__c[] pgCListUpdated = [SELECT Id, Contact__c FROM Playgroup_Contact__c WHERE Playgroup__r.Playgroup_Session__c =: pgs.Id AND Novel_Not_Novel__c = 'PG Leader'];
        System.assert(pgCListUpdated.size() == 1);
        System.assertEquals(con.Id, pgCListUpdated[0].Contact__c);
    }

    @isTest 
    static void getAnimalSessionNoteToPlaygroup(){
        Playgroup_Session__c pgs = TestDataFactory.createPlaygroupSessionWithAnimals();

        test.startTest();
        pgs.Playgroup_Notes__c = 'test';
        update pgs;
        test.stopTest();

        for(Animal_Playgroup__c ap : [SELECT Id, Playgroup_Session_Notes__c FROM Animal_Playgroup__c WHERE Playgroup_Session__c = :pgs.Id]){
            System.assertEquals(
                'test', 
                ap.Playgroup_Session_Notes__c, 
                'Playgroup_Session_Notes__c for each Animal_Playgroup__c should be test, but was: ' + ap.Playgroup_Session_Notes__c);
        }        
    }

    private static Playgroup_Session__c createPlaygroupSession(){
        Contact con = TestDataFactory.createContact();
        Playgroup_Session__c playgroup = new Playgroup_Session__c(
            Playgroup_Leader__c = con.Id
        );
        insert playgroup;
        return playgroup;
    }

    private static Animal_Playgroup__c[] createAnimalPlaygroups(Id sessionid, Animal__c[] animals){
        Animal_Playgroup__c[] aPgList = new Animal_Playgroup__c[0];
        for(Animal__c anim : animals){
            aPgList.add(new Animal_Playgroup__c(
                Playgroup_Session__c = sessionId,
                Animal__c = anim.Id,
                Common_Playgroup_Note_Sections__c = 'Greeting',
                Common_Playgroup_Notes__c = 'Airhorn',
                Play_Rating__c = 'Green',
                Playgroup_Individual_Notes__c = 'Individual note'
            ));
        }
        insert aPgList;
        return aPgList;
    }
}