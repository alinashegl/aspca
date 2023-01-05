@isTest private class Test_TreatmentsByDogPDFController {
    @isTest 
    static void getDogList_Success(){
        User u = [SELECT Id, Location__c FROM User WHERE Id =: userInfo.getUserId()];
        u.Location__c = 'CRC/MRC';
        update u;

        Animal__c willow = TestDataFactory.createAnimalWithName('willow');
        Animal__c fido = TestDataFactory.createAnimalWithName('fido');
        TestDataFactory.createBehaviorMedicationTask(willow.Id);

        test.startTest();
        TreatmentsByDogPDFController.DogInfoWrapper[] dogs = TreatmentsByDogPDFController.getDogInfo(
            new Id[]{willow.Id, fido.Id}, 
            true
        );
        test.stopTest();

        System.assertEquals(2, dogs.size());
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
            Map<Id, Map<String, TreatmentsByDogPDFController.TxProtocolWrapper>> dogTreatmentsMap = TreatmentsByDogPDFController.getDogTreatments(new Id[]{dog.Id});
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
            Map<Id, Map<String, TreatmentsByDogPDFController.TxProtocolWrapper>> dogTreatmentsMap = TreatmentsByDogPDFController.getDogTreatments(new Id[0]);
        test.stopTest();

        System.assert(dogTreatmentsMap.isEmpty(), 'Should have returned an empty map, but was: ' + dogTreatmentsMap);
    }
}
