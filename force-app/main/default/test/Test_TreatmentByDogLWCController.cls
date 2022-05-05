@isTest
private class Test_TreatmentByDogLWCController {
    @isTest
    static void getUserLocation_Success() {
        User u = [SELECT Id, Location__c FROM User WHERE Id =: userInfo.getUserId()];
        u.Location__c = 'CRC';
        update u;

        System.runAs(u){
            test.startTest();
                String[] locations = TreatmentByDogLWCController.getUserLocation();
                System.assert(locations.contains('CRC'));
                System.assert(locations.contains('MRC'));
            test.stopTest();
        }
    }

    @isTest 
    static void getDogList_Success(){
        // Animal__c[] dogs = TestDataFactory.createAnimalWithName
    }
}
