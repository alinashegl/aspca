@isTest
private class Test_ObservationController {
    @isTest
    static void getObservations_hasObservations(){
        Observation__c[] observations = TestDataFactory.createObservations();

        test.startTest();
            Observation__c[] returnedObservations = ObservationController.getObservations(observations[0].Animal__c, 'Happy Tail');
        test.stopTest();

        System.assertEquals(1, returnedObservations.size());
    }

    @isTest
    static void getObservations_noObservations(){
        Animal__c animal = TestDataFactory.createAnimal();

        test.startTest();
            Observation__c[] returnedObservations = ObservationController.getObservations(animal.Id, 'Happy Tail');
        test.stopTest();

        System.assertEquals(null, returnedObservations);
    }
}
