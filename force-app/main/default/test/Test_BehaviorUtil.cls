@isTest
private class Test_BehaviorUtil {
    @isTest
    static void getUserLocation_Success() {
        User u = [SELECT Id, Location__c FROM User WHERE Id =: userInfo.getUserId()];
        u.Location__c = 'CRC';
        update u;

        test.startTest();
            String location = BehaviorUtil.getUserLocation();
        test.stopTest();

        System.assertEquals('CRC', location);
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
        String[] locations = BehaviorUtil.getLocationGroup('CRC');
        System.assert(locations.contains('CRC'));
        System.assert(locations.contains('MRC'));
        System.assert(!locations.contains('ARC'));
        System.assert(!locations.contains('CARE'));

        locations = BehaviorUtil.getLocationGroup('MRC');
        System.assert(locations.contains('CRC'));
        System.assert(locations.contains('MRC'));
        System.assert(!locations.contains('ARC'));
        System.assert(!locations.contains('CARE'));

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
        u.Location__c = 'CRC';
        update u;

        String[] locations = BehaviorUtil.getLocationGroup();
        System.assert(locations.contains('CRC'));
        System.assert(locations.contains('MRC'));
        System.assert(!locations.contains('ARC'));
        System.assert(!locations.contains('CARE'));
    }

    @isTest
    static void getLocationGroup_FromUser_MRC() {
        User u = [SELECT Id, Location__c FROM User WHERE Id =: userInfo.getUserId()];
        u.Location__c = 'MRC';
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
        u.Location__c = 'CRC';
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
        u.Location__c = 'CRC';
        update u;

        String location = BehaviorUtil.userLocation;
        System.assertEquals('CRC', location);
    }
}
