@isTest
private class test_DailyCareSchedulable {
    @isTest 
    static void scheduleDailyCareJob(){
        test.startTest();
            DailyCareSchedulable schedule = new DailyCareSchedulable();
            String sch = '20 30 8 10 2 ?';
            String jobID = system.schedule('Daily Care Jobs', sch, schedule);
        test.stopTest();

        CronTrigger ct = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobID];
        System.assert(ct != null, 'Should have scheduled a job but did not');
    }
}