@isTest
private class SummaryWrapperTest {
    @isTest 
    static void SummaryWrapperTest() {
        List<SummaryWrapper> puppySummary = new List<SummaryWrapper>();

        test.startTest();
        puppySummary.add(new SummaryWrapper(1, 'testLabel'));

        test.stopTest();
        System.assertEquals(1, puppySummary[0].labelOrder);
        System.assertEquals('testLabel', puppySummary[0].labelValue);
    }

    @isTest 
    static void SummaryWrapperTestWithName() {
        List<SummaryWrapper> puppySummary = new List<SummaryWrapper>();

        test.startTest();
        puppySummary.add(new SummaryWrapper(1, 'testLabel', 'testName'));

        test.stopTest();
        System.assertEquals(1, puppySummary[0].labelOrder);
        System.assertEquals('testLabel', puppySummary[0].labelValue);
        System.assertEquals('testName', puppySummary[0].testName);
    }

    @isTest 
    static void SummaryWrapperTestWithConfig() {
        List<SummaryWrapper> puppySummary = new List<SummaryWrapper>();
        Test_Config__mdt config = new Test_Config__mdt(
            Label = 'Behavior Test',
            DeveloperName = 'Behavior_Test',
            Test_Comment_Field_Name__c = 'Name',
            Picklist_API_Name__c = 'Field__c',
            Test_Display_Order__c = '1'
        );

        test.startTest();
        puppySummary.add(new SummaryWrapper(1, 'testName', config));

        test.stopTest();
        System.assertEquals(1, puppySummary[0].labelOrder);
        System.assertEquals('testName', puppySummary[0].testName);
        System.assertEquals(config, puppySummary[0].config);
    }

    @isTest 
    static void SummaryWrapperCompare() {
        List<SummaryWrapper> puppySummary = new List<SummaryWrapper>();
        Test_Config__mdt config = new Test_Config__mdt(
            Label = 'Behavior Test',
            DeveloperName = 'Behavior_Test',
            Test_Comment_Field_Name__c = 'Name',
            Picklist_API_Name__c = 'Field__c',
            Test_Display_Order__c = '1'
        );

        puppySummary.add(new SummaryWrapper(1, 'testName', config));

        SummaryWrapper sWrap = new SummaryWrapper();

        test.startTest();
        Integer i = sWrap.compareTo(puppySummary[0]);

        test.stopTest();
        System.assertEquals(0, i);
    }
}