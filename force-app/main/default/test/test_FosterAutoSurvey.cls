@isTest
public class test_FosterAutoSurvey {
    @isTest
    static void sendWeeklyMonthlyEmails() {
        List<Facility_Outcome__c> fosterList = TestDataFactory.createWeeklyMonthlyFacilityOutcomes();
        Test.startTest();
        FosterAutoSurveyBatch fosterBatch = new FosterAutoSurveyBatch();
        fosterBatch.query = 'SELECT Id, Point_of_Contact__c, Start_Date__c ' +
                            'FROM Facility_OutCome__c ' +
                            'WHERE Facility_or_Outcome__c = \'Facility\' ' +
                            'AND Facility_Outcome__c = \'Foster Home\' ' +
                            'AND Point_of_Contact__c != null ' +
                            'AND Point_of_Contact__r.Email != null ' +
                            'AND Start_Date__c < TODAY ' +
                            'AND (End_Date__c = null OR End_Date__c > TODAY)';
        Database.QueryLocator ql = fosterBatch.start(null);
        fosterBatch.execute(null, fosterList);
        Integer emails = Limits.getEmailInvocations();
        Test.stopTest();
        //One email invocation with 5 emails
        System.assertEquals(0, emails);
    }

    @isTest
    static void fosterBatchScheduleTest() {
        Test.startTest();
        FosterAutoSurveyScheduler fosterEmail = new FosterAutoSurveyScheduler();
        String sch = '0 0 13 * * ?';
        String jobId = System.schedule('FosterScheduleTest', sch, fosterEmail);
        Test.stopTest();
        CronTrigger ct = [SELECT CronExpression FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals('0 0 13 * * ?', ct.CronExpression);
    }
}