@isTest
private class test_AutoScheduleTasksUtil {
    @isTest 
    static void getCalendarConfigTetst(){
        Test.startTest();
            Map<String, Calendar_Schedule_Config__mdt> configs = AutoScheduleTasksUtil.getCalendarConfig('Playgroup');
        Test.stopTest();

        System.assert(!configs.isEmpty(), 'shold have returned configs, instead was empty');
    }

    @isTest 
    static void getDateMap(){
        Map<String, Calendar_Schedule_Config__mdt> configs = AutoScheduleTasksUtil.getCalendarConfig('Playgroup');

        Test.startTest();
            Map<String, Date> dateMap = AutoScheduleTasksUtil.getDateMap(configs.values()[0]);
        Test.stopTest();

        System.assert(!dateMap.isEmpty(), 'shold have returned configs, instead was empty');
    }

    @isTest
    static void determineResourcesSuccess(){
        Animal__c anim = TestDataFactory.createAnimalWithName('anim');
        anim = [SELECT Id, Animal_Name_ID__c, Behavior_Case_Worker__r.Is_Generic_Contact__c FROM Animal__c WHERE Id =: anim.Id LIMIT 1];

        test.startTest();
            String resource = AutoScheduleTasksUtil.determineResources(anim);
        test.stopTest();

        System.assertEquals('anim (anim);unassigned', resource);
    }

    @isTest
    static void determineResourcesNoResource(){
        Animal__c anim = TestDataFactory.createAnimalWithName('anim');

        test.startTest();
            String resource = AutoScheduleTasksUtil.determineResources(anim);
        test.stopTest();

        System.assertEquals('unassigned', resource);
    }

    @isTest
    static void genericContactMapSuccess(){
        Map<String, Contact> contactMap = new Map<String, Contact>();
        User[] userList = [SELECT Id, Location__c FROM User WHERE isActive = true AND Location__c != null LIMIT 2];
        Contact[] genericContacts = new Contact[0];
        for(User u : userList){
            Contact con = new Contact(
                LastName = 'genericContact',
                Is_Generic_Contact__c = true,
                User__c = u.Id,
                Active__c = true
            );
            genericContacts.add(con);
        }

        insert genericContacts;

        test.startTest();
            contactMap = AutoScheduleTasksUtil.genericContactMap;
        test.stopTest();

        System.assert(!contactMap.isEmpty(), 'Should have returned a map of generic contacts but was empty');
    }

    @isTest
    static void genericContactMapNoContacts(){
        Map<String, Contact> contactMap = new Map<String, Contact>();
        test.startTest();
            contactMap = AutoScheduleTasksUtil.genericContactMap;
        test.stopTest();

        System.assert(contactMap.isEmpty(), 'Should have returned an empty map of generic contacts but was ' + contactMap);
    }

    @isTest
    static void getDateMapFromDaysSuccess(){
        Map<String, Date> dateMap = new Map<String, Date>();
        test.startTest();
            dateMap = AutoScheduleTasksUtil.getDateMap('Monday;Tuesday;Wednesday;Thursday;Friday;Saturday;Sunday');
        test.stopTest();

        System.assert(!dateMap.isEmpty(), 'Should have returned a map with dates, but was empty');
    }

    @isTest
    static void getDateMapFromDaysBadDay(){
        Map<String, Date> dateMap = new Map<String, Date>();
        test.startTest();
            dateMap = AutoScheduleTasksUtil.getDateMap('nodays');
        test.stopTest();

        System.assert(dateMap.isEmpty(), 'Should have returned an empty map, but was ' + dateMap);
    }
}
