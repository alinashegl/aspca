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
    
}
