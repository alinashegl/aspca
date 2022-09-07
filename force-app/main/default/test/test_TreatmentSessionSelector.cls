@isTest 
private class test_TreatmentSessionSelector {
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
    // @IsTest
    // static void validateAssignPlanActionWithNoPlan() {
    //     Behavior_Evaluation__c evaluation = TestDataFactory.createAdultBehaviorEvaluation(false);


    //     InvocableActionHandler.InvocableActionRequest actionRequest = new InvocableActionHandler.InvocableActionRequest();
    //     actionRequest.recordId = evaluation.Id;
    //     actionRequest.targetSObject = 'Treatment_Plan__c';
    //     actionRequest.name = 'assignPlanFromEval';
    //     actionRequest.action = 'assignPlan';
    //     InvocableActionHandler.InvocableActionResponse actionResponse = InvocableActionHandler.process(actionRequest);
    //     Test.startTest();
    //     System.assertEquals('NO PLAN FOUND', actionResponse.ResponseValue);
    //     System.debug(actionResponse);
    //     Test.stopTest();
    // }
    @IsTest
    static void validateAssignPlanActionWithPlan() {
        Behavior_Evaluation__c evaluation = TestDataFactory.createAdultBehaviorEvaluation(false);
        Treatment_Bundle__c masterbundle = TestDataFactory.createMasterBundle();
        Treatment_Plan__c plan = new Treatment_Plan__c();
        plan.Animal__c = evaluation.Animal__c;
        plan.IsActive__c = true;
        insert plan;

        InvocableActionHandler.InvocableActionRequest actionRequest = new InvocableActionHandler.InvocableActionRequest();
        actionRequest.recordId = evaluation.Id;
        actionRequest.targetSObject = 'Treatment_Plan__c';
        actionRequest.name = 'assignPlanFromEval';
        actionRequest.action = 'assignPlan';
        InvocableActionHandler.InvocableActionResponse actionResponse = InvocableActionHandler.process(actionRequest);

        Test.startTest();
        System.debug(actionResponse);

        Test.stopTest();
    }
}