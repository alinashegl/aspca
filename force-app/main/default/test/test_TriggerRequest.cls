/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class test_TriggerRequest {
    @isTest
    private static void regressionCoverage() {
        Test.startTest();
        TriggerRequest beforeTriggerRequest = new TriggerRequest(Account.getSObjectType())
                .SetBefore(true)
                .SetAfter(false)
                .SetInsert(true)
                .SetUpdate(false)
                .SetDelete(false)
                .SetNewRecords(new List<Account>())
                .SetNewRecordMap(new Map<Id, Account>())
                .SetOldRecords(new List<Account>())
                .SetOldRecordMap(new Map<Id, Account>());
        ServiceRequest svc = new ServiceRequest().withParams(
                'TriggerRequest',
                beforeTriggerRequest
        );
        TriggerRequest afterTriggerRequest = TriggerRequest.FromSvcRequest(svc);
        //TriggerProcess tp = afterTriggerRequest.triggerProcess;

        System.assertEquals(beforeTriggerRequest.isBefore, afterTriggerRequest.isBefore);
        System.assertEquals(beforeTriggerRequest.isAfter, afterTriggerRequest.isAfter);
        System.assertEquals(beforeTriggerRequest.isInsert, afterTriggerRequest.isInsert);
        System.assertEquals(beforeTriggerRequest.isUpdate, afterTriggerRequest.isUpdate);
        System.assertEquals(beforeTriggerRequest.isDelete, afterTriggerRequest.isDelete);
        System.assertEquals(beforeTriggerRequest.newRecords, afterTriggerRequest.newRecords);
        System.assertEquals(beforeTriggerRequest.newRecordMap, afterTriggerRequest.newRecordMap);
        System.assertEquals(beforeTriggerRequest.oldRecords, afterTriggerRequest.oldRecords);
        System.assertEquals(beforeTriggerRequest.oldRecordMap, afterTriggerRequest.oldRecordMap);
        System.debug('before trigger request ===>' + beforeTriggerRequest);
        afterTriggerRequest.SetUpdate(true);
        afterTriggerRequest.SetInsert(false);
        String proc = afterTriggerRequest.process;
        afterTriggerRequest.SetUpdate(false);
        afterTriggerRequest.SetDelete(true);
        String proc2 = afterTriggerRequest.process;

        Test.stopTest();
    }
}