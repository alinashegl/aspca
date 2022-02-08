@isTest
private class test_BehaviorSchedulable {
    @isTest 
    static void scheduleBehaviorJobs(){
        test.startTest();
            BehaviorSchedulable schedule = new BehaviorSchedulable();
            String sch = '20 30 8 10 2 ?';
            String jobID = system.schedule('Behavior Jobs', sch, schedule);
        test.stopTest();

        CronTrigger ct = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobID];
        System.assert(ct != null, 'Should have scheduled a job but did not');
    }
}