/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class test_RecordIdController {
    @IsTest
    static void regressionCoverage() {
        List<Session_Protocol__c> protocols = TestDataFactory.createSessionProtocols();

        Session_Protocol__c var = protocols[0];
        Id key = var.TreatmentSessionId__c;

        ServiceResponse response = RecordIDCmpController.renderView(key);
        System.debug(response);
    }
}