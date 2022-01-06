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

        System.assertEquals('anim (anim);', resource);
    }

    @isTest
    static void determineResourcesNoResource(){
        Animal__c anim = TestDataFactory.createAnimalWithName('anim');

        test.startTest();
            String resource = AutoScheduleTasksUtil.determineResources(anim);
        test.stopTest();

        System.assertEquals('', resource);
    }
}
