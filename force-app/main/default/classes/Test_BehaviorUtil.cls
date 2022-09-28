@isTest
private class Test_BehaviorUtil {
    @isTest
    static void getUserLocation_Success() {
        User u = [SELECT Id, Location__c FROM User WHERE Id =: userInfo.getUserId()];
        u.Location__c = 'CRC/MRC';
        update u;

        test.startTest();
            String location = BehaviorUtil.getUserLocation();
        test.stopTest();

        System.assertEquals('CRC/MRC', location);
    }

    @isTest
    static void getUserLocation_NoLocation() {
        User u = [SELECT Id, Location__c FROM User WHERE Id =: userInfo.getUserId()];
        u.Location__c = null;
        update u;

        test.startTest();
            String location = BehaviorUtil.getUserLocation();
        test.stopTest();

        System.assertEquals(null, location);
    }

    @isTest
    static void getLocationGroup_FromString() {
        String[] locations = BehaviorUtil.getLocationGroup('CRC/MRC');
        System.assert(locations.contains('CRC'));
        System.assert(locations.contains('MRC'));
        System.assert(!locations.contains('ARC'));
        System.assert(!locations.contains('CARE'));

        // locations = BehaviorUtil.getLocationGroup('MRC');
        // System.assert(locations.contains('CRC'));
        // System.assert(locations.contains('MRC'));
        // System.assert(!locations.contains('ARC'));
        // System.assert(!locations.contains('CARE'));

        locations = BehaviorUtil.getLocationGroup('ARC/CARE');
        System.assert(locations.contains('ARC'));
        System.assert(locations.contains('CARE'));
        System.assert(!locations.contains('CRC'));
        System.assert(!locations.contains('MRC'));

        locations = BehaviorUtil.getLocationGroup('ALL');
        System.assert(locations.contains('ARC'));
        System.assert(locations.contains('CARE'));
        System.assert(locations.contains('CRC'));
        System.assert(locations.contains('ARC'));

        locations = BehaviorUtil.getLocationGroup(null);
        System.assert(locations.contains('CRC'));
        System.assert(locations.contains('MRC'));
        System.assert(!locations.contains('ARC'));
        System.assert(!locations.contains('CARE'));
    }

    @isTest
    static void getLocationGroup_FromUser_CRC() {
        User u = [SELECT Id, Location__c FROM User WHERE Id =: userInfo.getUserId()];
        u.Location__c = 'CRC/MRC';
        update u;

        String[] locations = BehaviorUtil.getLocationGroup();
        System.assert(locations.contains('CRC'));
        System.assert(locations.contains('MRC'));
        System.assert(!locations.contains('ARC'));
        System.assert(!locations.contains('CARE'));
    }

    @isTest
    static void getLocationGroup_FromUser_ARCCARE() {
        User u = [SELECT Id, Location__c FROM User WHERE Id =: userInfo.getUserId()];
        u.Location__c = 'ARC/CARE';
        update u;

        String[] locations = BehaviorUtil.getLocationGroup();
        System.assert(locations.contains('ARC'));
        System.assert(locations.contains('CARE'));
        System.assert(!locations.contains('CRC'));
        System.assert(!locations.contains('MRC'));
    }

    @isTest
    static void getLocationGroup_FromUser_ALL() {
        User u = [SELECT Id, Location__c FROM User WHERE Id =: userInfo.getUserId()];
        u.Location__c = 'ALL';
        update u;

        String[] locations = BehaviorUtil.getLocationGroup();
        locations = BehaviorUtil.getLocationGroup('ALL');
        System.assert(locations.contains('ARC'));
        System.assert(locations.contains('CARE'));
        System.assert(locations.contains('CRC'));
        System.assert(locations.contains('ARC'));
    }

    @isTest
    static void getLocationGroup_FromUser_NULL() {
        User u = [SELECT Id, Location__c FROM User WHERE Id =: userInfo.getUserId()];
        u.Location__c = null;
        update u;

        String[] locations = BehaviorUtil.getLocationGroup();
        System.assert(locations.contains('CRC'));
        System.assert(locations.contains('MRC'));
        System.assert(!locations.contains('ARC'));
        System.assert(!locations.contains('CARE'));
    }

    @isTest
    static void locationGroup_FROMUser_CRC() {
        User u = [SELECT Id, Location__c FROM User WHERE Id =: userInfo.getUserId()];
        u.Location__c = 'CRC/MRC';
        update u;

        String[] locations = BehaviorUtil.locationGroup;
        System.assert(locations.contains('CRC'));
        System.assert(locations.contains('MRC'));
        System.assert(!locations.contains('ARC'));
        System.assert(!locations.contains('CARE'));
    }

    @isTest
    static void UserLocation_FROMUser_CRC() {
        User u = [SELECT Id, Location__c FROM User WHERE Id =: userInfo.getUserId()];
        u.Location__c = 'CRC/MRC';
        update u;

        String location = BehaviorUtil.userLocation;
        System.assertEquals('CRC/MRC', location);
    }

    @isTest 
    static void getAnimalRestDays_Success(){
        Task[] tasks = TestDataFactory.createBehaviorTreatmentTasks();

        test.startTest();
            String restDays = BehaviorUtil.getAnimalRestDays(tasks[0].Animal__c);
        test.stopTest();

        System.assertEquals('Tuesday, Thursday, Saturday, Monday', restDays);
    }

    @isTest 
    static void getAnimalRestDays_NoActivities(){
        Animal__c dog = TestDataFactory.createAnimal();

        test.startTest();
            String restDays = BehaviorUtil.getAnimalRestDays(dog.Id);
        test.stopTest();

        System.assertEquals('No treatments assigned this week', restDays);
    }

    @isTest 
    static void getAnimalRestDays_AnimalList_Success(){
        Task[] tasks = TestDataFactory.createBehaviorTreatmentTasks();

        test.startTest();
            Map<Id, String> restDaysMap = BehaviorUtil.getAnimalRestDays(new Id[]{tasks[0].Animal__c});
        test.stopTest();

        System.assertEquals('Tuesday, Thursday, Saturday, Monday', restDaysMap.get(tasks[0].Animal__c));
    }

    @isTest 
    static void getAnimalRestDays_AnimalList_NoTasks(){
        Animal__c dog = TestDataFactory.createAnimal();

        test.startTest();
            Map<Id, String> restDaysMap = BehaviorUtil.getAnimalRestDays(new Id[]{dog.Id});
        test.stopTest();

        System.assertEquals('No treatments assigned this week', restDaysMap.get(dog.Id));
    }

}