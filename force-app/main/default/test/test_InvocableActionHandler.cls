/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class test_InvocableActionHandler {
    @IsTest
    static void validateSessionCoverage() {
        InvocableActionHandler.InvocableActionRequest request = new InvocableActionHandler.InvocableActionRequest();



        List<Session_Protocol__c> sessionProtocols = TestDataFactory.createSessionProtocols();
        Treatment_Session__c session = new Treatment_Session__c();
        Session_Protocol__c protocol = sessionProtocols[0];
        session.Id = protocol.TreatmentSessionId__c;

        request.recordId = session.Id;
        request.targetSObject = 'Quote';
        request.action = 'validateSession';
        request.name = 'Test';

        List<InvocableActionHandler.InvocableActionRequest> requests = new List<InvocableActionHandler.InvocableActionRequest>();
        requests.add(request);

        List<InvocableActionHandler.InvocableActionResponse> responses = InvocableActionHandler.invocableAction
                (requests);

    }

    @IsTest
    static void validateSessionCoverageRegressionTest() {
        InvocableActionHandler.InvocableActionRequest request = new InvocableActionHandler.InvocableActionRequest();

        Treatment_Session__c session = TestDataFactory.createSession();

        request.recordId = session.Id;
        request.targetSObject = 'Quote';
        request.action = 'validateSession';
        request.name = 'Test';

        List<InvocableActionHandler.InvocableActionRequest> requests = new List<InvocableActionHandler.InvocableActionRequest>();
        requests.add(request);

        List<InvocableActionHandler.InvocableActionResponse> responses = InvocableActionHandler.invocableAction
                (requests);

        Test.startTest();

        System.debug(responses);

        Test.stopTest();
    }
    @IsTest
    static void validateAssignPlanAction() {
        Behavior_Evaluation__c evaluation = TestDataFactory.createAdultBehaviorEvaluation(false);

        InvocableActionHandler.InvocableActionRequest actionRequest = new InvocableActionHandler.InvocableActionRequest();
        actionRequest.recordId = evaluation.Id;
        actionRequest.targetSObject = 'Treatment_Plan__c';
        actionRequest.name = 'assignPlanFromEval';
        actionRequest.action = 'assignPlan';
        List<InvocableActionHandler.InvocableActionRequest> invocableActionRequests = new List<InvocableActionHandler.InvocableActionRequest>();
        invocableActionRequests.add(actionRequest);
        List<InvocableActionHandler.InvocableActionResponse> invocableActionResponses = InvocableActionHandler.invocableAction(invocableActionRequests);

        Test.startTest();

        System.debug(invocableActionRequests);
        Test.stopTest();
    }
}