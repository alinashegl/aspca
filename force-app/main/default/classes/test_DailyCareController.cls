@isTest
private class test_DailyCareController {
    @isTest 
    static void getDailyCareSuccess() {
        Daily_Care__c dc = TestDataFactory.createDailyCare();

        test.startTest();
            Daily_Care__c newDc = DailyCareController.getDailyCare();
        test.stopTest();

        System.assertEquals(dc.Id, newDc.Id);
    }

    @isTest
    static void getDailyCareNoDailyCare(){
        test.startTest();
            Daily_Care__c newDc = DailyCareController.getDailyCare();
        test.stopTest();

        System.assertEquals(null, newDc);
    }

    @isTest
    static void getDailyCareNotNeeded(){
        Daily_Care__c dc = TestDataFactory.createDailyCare();
        dc.Date__c = date.today().addDays(1);
        update dc;
        
        test.startTest();
            Daily_Care__c newDc = DailyCareController.getDailyCare();
        test.stopTest();

        System.assertEquals(null, newDc);
    }
}
