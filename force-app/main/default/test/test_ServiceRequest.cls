/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class test_ServiceRequest {
    @IsTest
    private static void regressionCoverage() {
        Test.startTest();
        ServiceRequest req = new ServiceRequest();
        req.Name = 'Test Request';
        req.Action = 'Do the test';
        req.Parameters = null;

        ServiceRequest req2 = new ServiceRequest('1', '2');

        ServiceRequest req3 = new ServiceRequest('1', '2', new Map<String, Object>());
        Test.stopTest();
    }
}