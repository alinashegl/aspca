@isTest
private class test_AnimalLocationFilterUtil {
    @isTest
    static void testUtilWithMap() {
        Test.startTest();
        AnimalLocationFilterUtil util = new AnimalLocationFilterUtil(prepLocationsFilter(true, true, 'CRC,CRC-MRC'));
        Test.stopTest();

        System.assertEquals(true, util.useFilter, 'Should have returned true');
        System.assertEquals(false, util.locationList.isEmpty(), 'Should have returned a list of CRC, CRC-MRC, but was: ' + util.locationList);
    }

    @isTest
    static void testUtilWithString() {
        Test.startTest();
        AnimalLocationFilterUtil util = new AnimalLocationFilterUtil(JSON.serialize(prepLocationsFilter(true, true, 'CRC,CRC-MRC')));
        Test.stopTest();

        System.assertEquals(true, util.useFilter, 'Should have returned true');
        System.assertEquals(false, util.locationList.isEmpty(), 'Should have returned a list of CRC, CRC-MRC, but was: ' + util.locationList);
    }

    @isTest
    static void testUtilWithEmptyMap() {
        Test.startTest();
        AnimalLocationFilterUtil util = new AnimalLocationFilterUtil(new Map<String,Object>());
        Test.stopTest();

        System.assertEquals(null, util.useFilter, 'Should have returned null');
        System.assertEquals(null, util.locationList, 'Should have returned an empty list');
    }

    @isTest
    static void testUtilWithEmptyString() {
        Test.startTest();
        AnimalLocationFilterUtil util = new AnimalLocationFilterUtil('');
        Test.stopTest();

        System.assertEquals(null, util.useFilter, 'Should have returned null');
        System.assertEquals(null, util.locationList, 'Should have returned an empty list');
    }

    private static Map<String, Object> prepLocationsFilter(Boolean hasConfig, Boolean showAll, String locations){
        Map<String, Object> locationsFilterMap = new Map<String, Object>{
            'hasConfigWithLocations' => (Object) hasConfig,
            'showAllLocations' => (Object) showAll,
            'locations' => (Object) locations
        };

        // return JSON.serialize(locationsFilterMap);
        return locationsFilterMap;
    }
}
