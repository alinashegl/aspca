/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class test_DomainActionBase {
    @isTest
    private static void regressionCoverage() {
        Test.startTest();
        testDomainAction tda = new testDomainAction();
        tda.Execute(new ServiceRequest().WithParams(
                'TriggerRequest',
                new TriggerRequest(Account.getSObjectType())
                        .SetBefore(true)
                        .SetInsert(true)
                        .SetNewRecords(new List<Account>())
                        .SetNewRecordMap(new Map<Id, Account>())
        )
        );
        Test.stopTest();
    }

    @isTest
    private static void exceptionCoverage() {
        Test.startTest();
        testDomainAction tda = new testDomainAction();
        tda.Execute(new ServiceRequest().WithParams(
                '',
                new TriggerRequest(Account.getSObjectType())
                        .SetBefore(true)
                        .SetInsert(true)
                        .SetNewRecords(new List<Account>())
                        .SetNewRecordMap(new Map<Id, Account>())
        )
        );
        Test.stopTest();
    }

    private class testDomainAction extends DomainActionBase {
        public override void ProcessAction(TriggerRequest request) {
            if (request.targetSobject != Account.getSObjectType() || !request.isBefore || !request.isInsert) {
                return;
            }
            // actual data manipulation would happen here to suit the trigger's needs
        }
    }


}