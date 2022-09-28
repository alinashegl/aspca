/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class test_ServiceResponse {
    private static ServiceRequest newTestableRequest(String variant) {
        ServiceRequest req = new ServiceRequest();
        req.Name = 'Test Request '+variant;
        req.Action = 'Do the test '+variant;
        req.Parameters = null;
        return req;
    }

    @IsTest
    private static void regressionCoverage() {
        Test.startTest();
        ServiceResponse resp1 = new ServiceResponse(newTestableRequest('1'));
        ServiceResponse resp2 = new ServiceResponse(newTestableRequest('2'), RequestStatus.FAILURE);
        ServiceResponse resp3 = new ServiceResponse(newTestableRequest('3'), RequestStatus.ERROR, new ServiceResponse.CriteriaException('test'));
        ServiceResponse resp4 = new ServiceResponse(newTestableRequest('4'), RequestStatus.SUCCESS, new Account());
        Test.stopTest();
    }
}