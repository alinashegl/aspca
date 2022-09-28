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
    static void getDateListFromConfig(){
        Map<String, Calendar_Schedule_Config__mdt> configs = AutoScheduleTasksUtil.getCalendarConfig('Playgroup');

        Test.startTest();
            Date[] dateList = AutoScheduleTasksUtil.getDateList(configs.values()[0]);
        Test.stopTest();

        System.assert(!dateList.isEmpty(), 'shold have returned configs, instead was empty');
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
        User[] userList = TestDataFactory.createUsersWithoutInserting(2);
        userList[0].Location__c = 'CRC/MRC';
        userList[0].Location__c = 'ARC/CARE';
        insert userList;

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
    static void getDateListFromDaysSuccess(){
        Date[] dateList = new Date[0];
        test.startTest();
            dateList = AutoScheduleTasksUtil.getDateList('Monday;Tuesday;Wednesday;Thursday;Friday;Saturday;Sunday');
        test.stopTest();

        System.assert(!dateList.isEmpty(), 'Should have returned a map with dates, but was empty');
    }

    @isTest
    static void getDateListFromDaysBadDay(){
        Date[] dateList = new Date[0];
        test.startTest();
            dateList = AutoScheduleTasksUtil.getDateList('nodays');
        test.stopTest();

        System.assert(dateList.isEmpty(), 'Should have returned an empty map, but was ' + dateList);
    }

    @isTest
    static void translateFrequencyEveryOtherWeek(){
        test.startTest();
            Integer minDays = AutoScheduleTasksUtil.translateFrequency('Every Other Week');
        test.stopTest();

        System.assertEquals(13, minDays);
    }

    @isTest
    static void translateFrequencyEveryThreeWeeks(){
        test.startTest();
            Integer minDays = AutoScheduleTasksUtil.translateFrequency('Every Three Weeks');
        test.stopTest();

        System.assertEquals(20, minDays);
    }

    @isTest
    static void translateFrequencyMonthly(){
        test.startTest();
            Integer minDays = AutoScheduleTasksUtil.translateFrequency('Monthly');
        test.stopTest();

        System.assertEquals(27, minDays);
    }

    @isTest
    static void translateFrequencyEveryOtherMonth(){
        test.startTest();
            Integer minDays = AutoScheduleTasksUtil.translateFrequency('Every Other Month');
        test.stopTest();

        System.assertEquals(55, minDays);
    }

    @isTest
    static void translateFrequencyDefault(){
        test.startTest();
            Integer minDays = AutoScheduleTasksUtil.translateFrequency(null);
        test.stopTest();

        System.assertEquals(0, minDays);
    }

    @isTest 
    static void dayOfWeekMap(){
        test.startTest();
            Map<String, Date> dayMap = AutoScheduleTasksUtil.dayOfWeekMap();
        test.stopTest();

        System.assert(!dayMap.isEmpty(), 'Should have returned a map of days, and dates, instead was empty');
    }
}