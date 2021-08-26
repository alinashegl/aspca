/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class test_DomainCoverage {
    @isTest
    private static void regressionCoverage() {
        Test.startTest();
        // build trigger request
        TriggerRequest testTriggerRequest = new TriggerRequest(Account.getSObjectType())
                .SetBefore(true)
                .SetInsert(true)
                .SetNewRecords(new List<Account>())
                .SetNewRecordMap(new Map<Id, Account>());

        // call SObjectDomain
        new SObjectDomain(testTriggerRequest).ExecuteTriggerActions();
        Test.stopTest();
    }

    private class testDomainActionOne extends DomainActionBase {
        public override void ProcessAction(TriggerRequest request) {
            if (request.targetSobject != Account.getSObjectType() || !request.isBefore || !request.isInsert) { return; }
            // actual data manipulation would happen here to suit the trigger's needs
        }
    }

    private class testDomainActionTwo extends DomainActionBase {
        public override void ProcessAction(TriggerRequest request) {
            if (request.targetSobject != Account.getSObjectType() || !request.isBefore || !request.isInsert) { return; }
            // actual data manipulation would happen here to suit the trigger's needs
        }
    }
}