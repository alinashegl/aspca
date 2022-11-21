@isTest
private class Test_TreatmentByDogLWCController {
    @isTest
    static void getUserLocation_Success() {
        User u = [SELECT Id, Location__c FROM User WHERE Id =: userInfo.getUserId()];
        u.Location__c = 'CRC/MRC';
        update u;

        System.runAs(u){
            test.startTest();
                String[] locations = TreatmentByDogLWCController.getUserLocation();
                System.assert(locations.contains('CRC'));
                System.assert(locations.contains('CRC-MRC'));
            test.stopTest();
        }
    }

    @isTest 
    static void getDogList_Success(){
        User u = [SELECT Id, Location__c FROM User WHERE Id =: userInfo.getUserId()];
        u.Location__c = 'CRC/MRC';
        update u;

        Animal__c willow = TestDataFactory.createAnimalWithName('willow');
        Animal__c fido = TestDataFactory.createAnimalWithName('fido');

        test.startTest();
            TreatmentByDogLWCController.DogWrapper[] dogs = TreatmentByDogLWCController.getDogList(new String[]{'CRC','CRC-MRC'});
        test.stopTest();

        System.assertEquals(2, dogs.size());
    }

    @isTest 
    static void getDogList_NoDogs(){
        Animal__c willow = TestDataFactory.createAnimalWithName('willow');
        Animal__c fido = TestDataFactory.createAnimalWithName('fido');

        test.startTest();
            TreatmentByDogLWCController.DogWrapper[] dogs = TreatmentByDogLWCController.getDogList(new String[]{'ARC'});
        test.stopTest();

        System.assertEquals(0, dogs.size());
    }

    @isTest 
    static void getDogInfoById_Success(){
        Session_Protocol__c[] protocols = TestDataFactory.createSessionProtocols();
        for(Session_Protocol__c protocol : protocols){
            protocol.Overall_Score__c = '1. Beginning/Acquisition';
        }

        update protocols;

        Animal__c willlow = [SELECT Id FROM Animal__c LIMIT 1];

        TestDataFactory.createMedicationTask(willlow.Id);

        test.startTest();
            TreatmentByDogLWCController.DogInfoWrapper dog = TreatmentByDogLWCController.getDogInfo(willlow.Id);
        test.stopTest();

        System.assertNotEquals(null, dog);
    }

    @isTest 
    static void getDogInfoByIdList_Success(){
        Animal__c willow = TestDataFactory.createAnimalWithName('willow');
        Animal__c fido = TestDataFactory.createAnimalWithName('fido');

        test.startTest();
            TreatmentByDogLWCController.DogInfoWrapper[] dogs = TreatmentByDogLWCController.getDogInfo(new Id[]{willow.Id, fido.Id});
        test.stopTest();

        System.assertEquals(2, dogs.size());
    }

    @isTest 
    static void getDogInfoByIdList_NoDogs(){
        Animal__c willow = TestDataFactory.createAnimalWithName('willow');
        Animal__c fido = TestDataFactory.createAnimalWithName('fido');

        test.startTest();
            TreatmentByDogLWCController.DogInfoWrapper[] dogs = TreatmentByDogLWCController.getDogInfo(new Id[0]);
        test.stopTest();

        System.assertEquals(0, dogs.size());
    }

    @isTest 
    static void getDogMedications_Success(){
        Animal__c willow = TestDataFactory.createAnimalWithName('willow');
        Task willowTask = TestDataFactory.createMedicationTask(willow.Id);
        Medication_Drug__c md1 = new Medication_Drug__c(
            Id = willowTask.Medication__c,
            Behavior_Medication__c = true
        );

        Animal__c fido = TestDataFactory.createAnimalWithName('fido');
        Task fidoTask = TestDataFactory.createMedicationTask(fido.Id);
        Medication_Drug__c md2 = new Medication_Drug__c(
            Id = fidoTask.Medication__c,
            Behavior_Medication__c = true
        );

        update new Medication_Drug__c[]{md1, md2};

        test.startTest();
            Map<Id, Set<String>> dogMedicationMap = TreatmentByDogLWCController.getDogMedications(new Id[]{willow.Id, fido.Id});
        test.stopTest();

        System.assertNotEquals(null, dogMedicationMap);
        System.assertEquals(2, dogMedicationMap.size());
    }

    @isTest 
    static void getDogMedications_NoMedications(){
        Animal__c willow = TestDataFactory.createAnimalWithName('willow');
        Animal__c fido = TestDataFactory.createAnimalWithName('fido');

        test.startTest();
            Map<Id, Set<String>> dogMedicationMap = TreatmentByDogLWCController.getDogMedications(new Id[]{willow.Id, fido.Id});
        test.stopTest();

        System.assert(dogMedicationMap.isEmpty(), 'expected empty map, but was: ' + dogMedicationMap);
    }

    @isTest 
    static void getDogMedications_NoDogs(){
        test.startTest();
            Map<Id, Set<String>> dogMedicationMap = TreatmentByDogLWCController.getDogMedications(new Id[]{});
        test.stopTest();

        System.assert(dogMedicationMap.isEmpty(), 'expected empty map, but was: ' + dogMedicationMap);
    }

    @isTest 
    static void getDogTreatmentsByIds_Success(){
        Session_Protocol__c[] protocols = TestDataFactory.createSessionProtocols();
        for(Session_Protocol__c protocol : protocols){
            protocol.Overall_Score__c = '1. Beginning/Acquisition';
        }

        update protocols;

        Animal__c dog = [SELECT Id FROM Animal__c LIMIT 1];

        test.startTest();
            Map<Id, Map<String, TreatmentByDogLWCController.TxProtocolWrapper>> dogTreatmentsMap = TreatmentByDogLWCController.getDogTreatments(new Id[]{dog.Id});
        test.stopTest();

        System.assert(!dogTreatmentsMap.isEmpty(), 'Should have returned a map, but was empty');
    }

    @isTest 
    static void getDogTreatmentsByIds_NoDogs(){
        Session_Protocol__c[] protocols = TestDataFactory.createSessionProtocols();
        for(Session_Protocol__c protocol : protocols){
            protocol.Overall_Score__c = '1. Beginning/Acquisition';
        }

        update protocols;

        Animal__c dog = [SELECT Id FROM Animal__c LIMIT 1];

        test.startTest();
            Map<Id, Map<String, TreatmentByDogLWCController.TxProtocolWrapper>> dogTreatmentsMap = TreatmentByDogLWCController.getDogTreatments(new Id[0]);
        test.stopTest();

        System.assert(dogTreatmentsMap.isEmpty(), 'Should have returned an empty map, but was: ' + dogTreatmentsMap);
    }
}