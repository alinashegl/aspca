@isTest
private class test_DaybackRest {
    Private static Final String LOCATION_ALL = 'All';
    Private static Final String LOCATION_ARC_CARE = 'ARC/CARE';
    Private static Final String LOCATION_CRC_MRC = 'CRC/MRC';

    @isTest
    static void getLocationGroupSuccessAll() {
        String[] locationGroup;
        User u = TestDataFactory.createUsersWithoutInserting(1)[0];
        u.Location__c = LOCATION_ALL;
        insert u;
        
        test.startTest();
            System.runAs(u){
                locationGroup = DaybackRest.locationGroup;
            }
        test.stopTest();

        System.assertEquals(6, locationGroup.size(), 'Becuase Location is All, should return a list of 6 groups (ARC, CARE, ARC/CARE, CRC, MRC And CRC/MRC), instead was: ' + locationGroup);
    }

    @isTest
    static void getLocationGroupSuccessARCCARE() {
        String[] locationGroup;
        User u = TestDataFactory.createUsersWithoutInserting(1)[0];
        u.Location__c = LOCATION_ARC_CARE;
        insert u;
        
        test.startTest();
            System.runAs(u){
                locationGroup = DaybackRest.locationGroup;
            }
        test.stopTest();

        System.assertEquals(3, locationGroup.size(), 'Becuase Location is ARC/CARE, should return a list of 3 groups (ARC, CARE, ARC/CARE), instead was: ' + locationGroup);
    }

    @isTest
    static void getLocationGroupSuccessMRC() {
        String[] locationGroup;
        User u = TestDataFactory.createUsersWithoutInserting(1)[0];
        u.Location__c = LOCATION_CRC_MRC;
        insert u;
        
        test.startTest();
            System.runAs(u){
                locationGroup = DaybackRest.locationGroup;
            }
        test.stopTest();

        System.assertEquals(3, locationGroup.size(), 'Becuase Location is CRC/MRC, should return a list of 3 groups (CRC, MRC And CRC/MRC), instead was: ' + locationGroup);
    }    

    @isTest 
    static void prepGenericResourcesLocationAll(){
        User u = TestDataFactory.createUsersWithoutInserting(1)[0];
        u.Location__c = LOCATION_ALL;
        insert u;

        DaybackRest.GenericResource[] genericResources = new DaybackRest.GenericResource[0];
        test.startTest();
            System.runAs(u){
                genericResources = DaybackRest.prepGenericResources();
            }
        test.stopTest();

        System.assert(!genericResources.isEmpty(), 'Should have returned generic resources, but was empty');
        //Becuase location is All, should return 3 generic resources
        System.assertEquals(3, genericResources.size());
    }

    @isTest 
    static void prepGenericResourcesLocationARCCARE(){
        User u = TestDataFactory.createUsersWithoutInserting(1)[0];
        u.Location__c = LOCATION_ARC_CARE;
        insert u;

        DaybackRest.GenericResource[] genericResources = new DaybackRest.GenericResource[0];
        test.startTest();
            System.runAs(u){
                genericResources = DaybackRest.prepGenericResources();
            }
        test.stopTest();

        System.assert(!genericResources.isEmpty(), 'Should have returned generic resources, but was empty');
        System.assertEquals(1, genericResources.size(), 'Becuase location is ARC/CARE, should only return the ARC/CARE generic resource');
    }

    @isTest 
    static void prepGenericResourcesLocationMRC(){
        User u = TestDataFactory.createUsersWithoutInserting(1)[0];
        u.Location__c = LOCATION_CRC_MRC;
        insert u;

        DaybackRest.GenericResource[] genericResources = new DaybackRest.GenericResource[0];
        test.startTest();
            System.runAs(u){
                genericResources = DaybackRest.prepGenericResources();
            }
        test.stopTest();

        System.assert(!genericResources.isEmpty(), 'Should have returned generic resources, but was empty');
        //Becuase location is MRC, should return both MRC and CRC generic resources
        System.assertEquals(2, genericResources.size());
    }

    @isTest 
    static void prepGenericResourcesLocationCRC(){
        User u = TestDataFactory.createUsersWithoutInserting(1)[0];
        u.Location__c = LOCATION_CRC_MRC;
        insert u;

        DaybackRest.GenericResource[] genericResources = new DaybackRest.GenericResource[0];
        test.startTest();
            System.runAs(u){
                genericResources = DaybackRest.prepGenericResources();
            }
        test.stopTest();

        System.assert(!genericResources.isEmpty(), 'Should have returned generic resources, but was empty');
        //Becuase location is CRC, should return both MRC and CRC generic resources
        System.assertEquals(2, genericResources.size());
    }

    @isTest 
    static void prepContactResourcesNoContacts(){
        DaybackRest.ResourceInfo[] infos = new DaybackRest.ResourceInfo[0];
        test.startTest();
            infos = DaybackRest.prepContactResources();
        test.stopTest();

        System.assert(infos.isEmpty(), 'should have been empty, but returned ' + infos);
    }

    @isTest 
    static void prepContactResourcesARCCARESuccess(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User[] userList = new User[0];

        //need to use runAs to avoid mixed DML error
        System.runAs (thisUser) {
            userList = prepUsersForTests();
            userList[0].Location__c = LOCATION_ARC_CARE;
            System.debug('userList: ' + userList);
            insert userList;

            assignPermissionSetsToUser(userList[0].Id, new String[]{'Behavior_Team', 'ARC_CARE_Admin'});
            insertContacts(userList);
        }

        DaybackRest.ResourceInfo[] infos = new DaybackRest.ResourceInfo[0];

        test.startTest();
            System.runAs(userList[0]){
                infos =  DaybackRest.prepContactResources();
            }
        test.stopTest();

        System.assert(!infos.isEmpty(), 'Should have returned contacts instead was empty');
        //Should have 4 becuase only 4 ARC/CARE contacts were created
        System.assertEquals(
            4, 
            infos.size(), 
            'Should have returned 4 contacts becuase only 4 ARC/CARE contacts were created, instead was: ' + infos.size());
        
    }

    @isTest 
    static void prepContactResourcesARCCARENoContacts(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User[] userList = new User[0];

        //need to use runAs to avoid mixed DML error
        System.runAs (thisUser) {
            userList = prepUsersForTests();
            userList[3].Location__c = LOCATION_ALL;
            System.debug('userList: ' + userList);
            insert userList;

            assignPermissionSetsToUser(userList[3].Id, new String[]{'Behavior_Team', 'ARC_CARE_Admin'});
        }

        DaybackRest.ResourceInfo[] infos = new DaybackRest.ResourceInfo[0];

        test.startTest();
            System.runAs(userList[3]){
                infos =  DaybackRest.prepContactResources();
            }
        test.stopTest();

        System.assert(infos.isEmpty(), 'Should have returned an empty list, but was: ' + infos);
    }

    @isTest 
    static void prepContactResourcesCRCMRCSuccess(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User[] userList = new User[0];

        //need to use runAs to avoid mixed DML error
        System.runAs (thisUser) {
            userList = prepUsersForTests();
            userList[3].Location__c = LOCATION_CRC_MRC;
            System.debug('userList: ' + userList);
            insert userList;

            assignPermissionSetsToUser(userList[3].Id, new String[]{'Behavior_Team', 'CRC_Manager'});
            insertContacts(userList);
        }

        DaybackRest.ResourceInfo[] infos = new DaybackRest.ResourceInfo[0];

        test.startTest();
            System.runAs(userList[3]){
                infos =  DaybackRest.prepContactResources();
            }
        test.stopTest();

        System.assert(!infos.isEmpty(), 'Should have returned contacts instead was empty');
        System.assertEquals(3, infos.size(), 'Should have returned 3 MRC/CRC contacts');
    }

    @isTest 
    static void prepContactResourcesCRCMRCNoContacts(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User[] userList = new User[0];

        //need to use runAs to avoid mixed DML error
        System.runAs (thisUser) {
            userList = prepUsersForTests();
            userList[3].Location__c = LOCATION_CRC_MRC;
            System.debug('userList: ' + userList);
            insert userList;

            assignPermissionSetsToUser(userList[3].Id, new String[]{'Behavior_Team', 'CRC_Manager'});
        }

        DaybackRest.ResourceInfo[] infos = new DaybackRest.ResourceInfo[0];

        test.startTest();
            System.runAs(userList[3]){
                infos =  DaybackRest.prepContactResources();
            }
        test.stopTest();

        System.assert(infos.isEmpty(), 'Should have returned an empty list, instead was: ' + infos);
    }

    // @isTest 
    // static void prepContactResourcesCRCSuccess(){
    //     User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
    //     User[] userList = new User[0];

    //     //need to use runAs to avoid mixed DML error
    //     System.runAs (thisUser) {
    //         userList = prepUsersForTests();
    //         userList[3].Location__c = LOCATION_CRC_MRC;
    //         System.debug('userList: ' + userList);
    //         insert userList;

    //         assignPermissionSetsToUser(userList[3].Id, new String[]{'Behavior_Team', 'CRC_Manager'});
    //         insertContacts(userList);
    //     }

    //     DaybackRest.ResourceInfo[] infos = new DaybackRest.ResourceInfo[0];

    //     test.startTest();
    //         System.runAs(userList[3]){
    //             infos =  DaybackRest.prepContactResources();
    //         }
    //     test.stopTest();

    //     System.assert(!infos.isEmpty(), 'Should have returned contacts instead was empty');
    //     //Should have 5 becuase 3 MRC and 2 CRC contacts were created, both should be returned
    //     System.assertEquals(5, infos.size());
        
    // }

    // @isTest 
    // static void prepContactResourcesCRCNoContacts(){
    //     User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
    //     User[] userList = new User[0];

    //     //need to use runAs to avoid mixed DML error
    //     System.runAs (thisUser) {
    //         userList = prepUsersForTests();
    //         userList[3].Location__c = LOCATION_CRC_MRC;
    //         System.debug('userList: ' + userList);
    //         insert userList;

    //         assignPermissionSetsToUser(userList[3].Id, new String[]{'Behavior_Team', 'CRC_Manager'});
    //     }

    //     DaybackRest.ResourceInfo[] infos = new DaybackRest.ResourceInfo[0];

    //     test.startTest();
    //         System.runAs(userList[3]){
    //             infos =  DaybackRest.prepContactResources();
    //         }
    //     test.stopTest();

    //     System.assert(infos.isEmpty(), 'Should have returned an empty list, instead was: ' + infos);
    // }

    @isTest 
    static void getAnimalListAllSuccess(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User newUser;
        DaybackRest.ResourceInfo[] animalResources = new DaybackRest.ResourceInfo[0];

        //need to use runAs to avoid mixed DML error
        System.runAs (thisUser) {
            insertAnimals();            
            newUser = TestDataFactory.createUsersWithoutInserting(1)[0];
            newUser.Location__c = LOCATION_ALL;
            insert newUser;
            assignPermissionSetsToUser(newUser.Id, new String[]{'Behavior_Team', 'CRC_Manager'});
        }
        
        test.startTest();
            System.runAs(newUser){
                animalResources = DaybackRest.getAnimalList();
            }
        test.stopTest();

        System.assert(!animalResources.isEmpty(), 'Should have returned a list of animlas instead was empty');
        //becuase location is All, should have returned all 8 animals
        System.assertEquals(8, animalResources.size(), 'Becuase location is All, should have returned all 8 animals, but returned: ' + animalResources.size());
    }

    @isTest 
    static void getAnimalListARCCARESuccess(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User newUser;
        DaybackRest.ResourceInfo[] animalResources = new DaybackRest.ResourceInfo[0];

        //need to use runAs to avoid mixed DML error
        System.runAs (thisUser) {
            insertAnimals();            
            newUser = TestDataFactory.createUsersWithoutInserting(1)[0];
            newUser.Location__c = LOCATION_ALL;
            insert newUser;
            assignPermissionSetsToUser(newUser.Id, new String[]{'Behavior_Team', 'ARC_CARE_Admin'});
        }
        
        test.startTest();
            System.runAs(newUser){
                animalResources = DaybackRest.getAnimalList();
            }
        test.stopTest();

        System.assert(!animalResources.isEmpty(), 'Should have returned a list of animlas instead was empty');
        //becuase location is All, should have returned the 2 ARC dogs and the 2 CARE dogs
        System.assertEquals(8, animalResources.size(), 'Becuase location is All, should have returned all 8 dogs, but instead returned: ' + animalResources.size());
    }

    @isTest 
    static void getAnimalListCRCSuccess(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User newUser;
        DaybackRest.ResourceInfo[] animalResources = new DaybackRest.ResourceInfo[0];

        //need to use runAs to avoid mixed DML error
        System.runAs (thisUser) {
            insertAnimals();            
            newUser = TestDataFactory.createUsersWithoutInserting(1)[0];
            newUser.Location__c = LOCATION_CRC_MRC;
            insert newUser;
            assignPermissionSetsToUser(newUser.Id, new String[]{'Behavior_Team', 'CRC_Manager'});
        }
        
        test.startTest();
            System.runAs(newUser){
                animalResources = DaybackRest.getAnimalList();
            }
        test.stopTest();

        System.assert(!animalResources.isEmpty(), 'Should have returned a list of animlas instead was empty');
        //becuase location is All, should have returned the 2 CRC dogs and the 2 MRC dogs
        System.assertEquals(4, animalResources.size());
    }

    @isTest 
    static void getAnimalListNoAnimals(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User newUser;
        DaybackRest.ResourceInfo[] animalResources = new DaybackRest.ResourceInfo[0];

        //need to use runAs to avoid mixed DML error
        System.runAs (thisUser) {
            newUser = TestDataFactory.createUsersWithoutInserting(1)[0];
            newUser.Location__c = LOCATION_CRC_MRC;
            insert newUser;
            assignPermissionSetsToUser(newUser.Id, new String[]{'Behavior_Team', 'CRC_Manager'});
        }
        
        test.startTest();
            System.runAs(newUser){
                animalResources = DaybackRest.getAnimalList();
            }
        test.stopTest();

        System.assert(animalResources.isEmpty(), 'Should have returned an empty list, but was: ' + animalResources);
    }


    //we've tested the individual methods, now testing the whole thing together
    @isTest 
    static void getResourcesCRCSuccess(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User[] userList = new User[0];

        //need to use runAs to avoid mixed DML error
        System.runAs (thisUser) {
            userList = prepUsersForTests();
            userList[3].Location__c = LOCATION_CRC_MRC;
            System.debug('userList: ' + userList);
            insert userList;

            assignPermissionSetsToUser(userList[3].Id, new String[]{'Behavior_Team', 'CRC_Manager'});
            insertContacts(userList);
        }

        DaybackRest.DaybackResponse response = new DaybackRest.DaybackResponse();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/resources';
        req.addParameter('sfObject', 'default');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        test.startTest();
            System.runAs(userList[3]){
                response =  DaybackRest.getResources();
            }
        test.stopTest();

        System.assert(response != null, 'Should have returned contacts instead was empty');
        System.assert(!response.resources.isEmpty(), 'Should have returned contacts instead was empty');
        System.assert(!response.folderInfos.isEmpty(), 'Should have returned folder info instead was empty');
        System.assert(!response.folders.isEmpty(), 'Should have returned a list of folders instead was empty');
        System.assert(!response.genResources.isEmpty(), 'Should have returned a list of generic resources instead was empty');
        System.assertEquals('default', response.sfObject);

        //Should have 5 becuase 3 MRC and 2 CRC contacts were created, both should be returned
        // System.assertEquals(5, infos.size());
        
    }

    private static User[] prepUsersForTests(){
        User[] tempList = TestDataFactory.createUsersWithoutInserting(4);
        tempList[0].Location__c = LOCATION_ARC_CARE;
        tempList[1].Location__c = LOCATION_CRC_MRC;
        tempList[2].Location__c = LOCATION_ALL;

        return new User[]{tempList[0],tempList[1],tempList[2],tempList[3]};
    }

    private static void insertAnimals(){
        Animal__c[] toInsert = new Animal__c[0];
        String location;
        Case c = TestDataFactory.createCase();

        //ARC Animals
        location = 'ARC';
        for(integer i = 0; i < 2; i ++){
            toInsert.add(new Animal__c(
                Current_Location__c = location,
                Current_Recent_Shelter_Location__c = location,
                Type_of_Animal__c = 'Dog',
                Animal_Name__c = location + i,
                Case__c = c.Id
            ));
        }

        //CARE Animals
        location = 'CARE';
        for(integer i = 0; i < 2; i ++){
            toInsert.add(new Animal__c(
                Current_Location__c = location,
                Current_Recent_Shelter_Location__c = location,
                Type_of_Animal__c = 'Dog',
                Animal_Name__c = location + i,
                Case__c = c.Id
            ));
        }

        //MRC Animals
        location = 'MRC';
        for(integer i = 0; i < 2; i ++){
            toInsert.add(new Animal__c(
                Current_Location__c = location,
                Current_Recent_Shelter_Location__c = location,
                Type_of_Animal__c = 'Dog',
                Animal_Name__c = location + i,
                Case__c = c.Id
            ));
        }

        //CRC Animals
        location = 'CRC';
        for(integer i = 0; i < 2; i ++){
            toInsert.add(new Animal__c(
                Current_Location__c = location,
                Current_Recent_Shelter_Location__c = location,
                Type_of_Animal__c = 'Dog',
                Animal_Name__c = location + i,
                Case__c = c.Id
            ));
        }

        insert toInsert;

        System.debug('animals: ' + [SELECT Id, Animal_Name_Id__c, Current_Recent_Shelter_Location__c FROM Animal__c]);
    }

    private static void insertContacts(User[] uList){
        Contact[] cons = new Contact[0];

        //ARC/CARE Contacts
        for(integer i = 0; i < 4; i++){
            String lastName = 'ARCCAREContact' + i;
            cons.add(new Contact(
                LastName = lastName,
                Contact_Type__c = 'Behavior Case Worker',
                Active__c = true,
                User__c = uList[0].Id,
                Email = LastName + '@aspcaTest.com'
            ));
        }

        //CRC/MRC Contacts
        for(integer i = 0; i < 3; i++){
            String lastName = 'MRCContact' + i;
            cons.add(new Contact(
                LastName = lastName,
                Contact_Type__c = 'Behavior Case Worker',
                Active__c = true,
                User__c = uList[1].Id,
                Email = LastName + '@aspcaTest.com'
            ));
        }

        //All Contacts
        for(integer i = 0; i < 2; i++){
            String lastName = 'AllContact' + i;
            cons.add(new Contact(
                LastName = lastName,
                Contact_Type__c = 'Behavior Case Worker',
                Active__c = true,
                User__c = uList[2].Id,
                Email = LastName + '@aspcaTest.com'
            ));
        }

        insert cons;
    }

    private static void assignPermissionSetsToUser(Id userId, String[] permSetNames){
        PermissionSet[] pSets = [SELECT Id, Name, Label FROM PermissionSet WHERE Name IN: permSetNames AND IsOwnedByProfile = FALSE];
        PermissionSetAssignment[] assignments = new PermissionSetAssignment[0];

        for(PermissionSet pSet : pSets){
            PermissionSetAssignment assignment = new PermissionSetAssignment(
                PermissionSetId = pSet.Id,
                AssigneeId = userId
            );
            assignments.add(assignment);
        }
        insert assignments;

    }
}