@isTest
private class test_LocationFilterController {
    @isTest
    static void getAnimalLocationsFromStringSuccess() {
        User u = [SELECT Id, Location__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        u.Location__c = 'All';
        update u;

        Test.startTest();
        Map<String, Object> locations = LocationFilterController.getAnimalLocations('ForTests', null);
        Test.stopTest();

        System.assertEquals(false, locations.isEmpty(), 'should have returned a map, but was empty');
        System.assertEquals(false, locations.get('locations') == null, 'should have returned a list of locations, but was empty');
    }

    @isTest
    static void getAnimalLocationsFromJSONSuccess() {
        User u = [SELECT Id, Location__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        u.Location__c = 'CRC/MRC';
        update u;

        Test.startTest();
        Map<String, Object> locations = LocationFilterController.getAnimalLocations('ForTests', null);
        Test.stopTest();

        System.assertEquals(false, locations.isEmpty(), 'should have returned a map, but was empty');
        System.assertEquals(false, locations.get('locations') == null, 'should have returned a list of locations, but was empty');
    }

    @isTest
    static void getAnimalLocationsInvalidType() {
        User u = [SELECT Id, Location__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        u.Location__c = 'All';
        update u;

        Test.startTest();
        Map<String, Object> locations = LocationFilterController.getAnimalLocations('NoAppType', null);
        Test.stopTest();

        System.assertEquals(null, locations.get('locations'), 'should have returned an empty map, but was: ' + locations);
    }
}
