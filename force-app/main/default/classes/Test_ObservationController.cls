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

    @isTest 
    static void getUserLocationMRC(){
        User u = TestDataFactory.createUsersWithoutInserting(1)[0];
        u.Location__c = 'CRC/MRC';
        insert u;

        Boolean isArcCare = true;
        test.startTest();
            system.runAs(u){
                isArcCare = ObservationController.getUserLocation();
            }
        test.stopTest();

        System.assertEquals(false, isArcCare);
    }

    @isTest 
    static void getUserLocationARC(){
        User u = TestDataFactory.createUsersWithoutInserting(1)[0];
        u.Location__c = 'ARC/CARE';
        insert u;

        Boolean isArcCare = false;
        test.startTest();
            system.runAs(u){
                isArcCare = ObservationController.getUserLocation();
            }
        test.stopTest();

        System.assertEquals(true, isArcCare);
    }
}