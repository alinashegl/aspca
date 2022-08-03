/**
 * Created by CloudQnect on 9/20/2021.
 */

@IsTest
private class test_TreatmentPlanService {
    @IsTest
    static void treatmentPlanRegressionTest() {

        Treatment_Bundle__c master = TestDataFactory.createMasterBundle();
        Treatment_Bundle__c bundle = TestDataFactory.createTreatmentBundle();
        Treatment_Bundle__c bundleTwo = TestDataFactory.createTreatmentBundle();
        bundleTwo.Name = 'Bundle Two';
        update bundleTwo;

        List<Protocol__c> protocols = TestDataFactory.createProtocols(5);
        List<Protocol__c> protocolsTwo = TestDataFactory.createProtocols(8);

        List<Bundle_Entry__c> masterEntries = TestDataFactory.assignEntries(master, protocols);
        List<Bundle_Entry__c> masterEntriesTwo = TestDataFactory.assignEntries(master, protocolsTwo);

        List<Bundle_Entry__c> bundleEntries = TestDataFactory.assignEntries(bundle, protocols);
        List<Bundle_Entry__c> bundleTwoEntries = TestDataFactory.assignEntries(bundleTwo, protocolsTwo);

        Treatment_Plan__c plan = new Treatment_Plan__c();
        plan.MasterTreatmentBundleId__c = master.Id;
        insert plan;

        plan.Preferred_Motivators__c = 'Test';
        plan.AssignedTreatmentBundleId__c = bundle.Id;
        update plan;

        plan.AssignedTreatmentBundleId__c = bundleTwo.Id;
        update plan;

    }

    @IsTest
    static void assignNewBundleTest() {
        Treatment_Bundle__c master = TestDataFactory.createMasterBundle();
        Treatment_Bundle__c bundle = TestDataFactory.createTreatmentBundle();
        Treatment_Bundle__c bundleTwo = TestDataFactory.createTreatmentBundle();
        bundleTwo.Name = 'Bundle Two';
        update bundleTwo;

        List<Protocol__c> protocols = TestDataFactory.createProtocols(5);
        List<Protocol__c> protocolsTwo = TestDataFactory.createProtocols(8);

        List<Bundle_Entry__c> masterEntries = TestDataFactory.assignEntries(master, protocols);
        List<Bundle_Entry__c> masterEntriesTwo = TestDataFactory.assignEntries(master, protocolsTwo);

        List<Bundle_Entry__c> bundleEntries = TestDataFactory.assignEntries(bundle, protocols);
        List<Bundle_Entry__c> bundleTwoEntries = TestDataFactory.assignEntries(bundleTwo, protocolsTwo);

        Treatment_Plan__c plan = new Treatment_Plan__c();
        plan.MasterTreatmentBundleId__c = master.Id;
        insert plan;

        plan.Preferred_Motivators__c = 'Test';
        plan.AssignedTreatmentBundleId__c = bundle.Id;
        update plan;
    }

    @IsTest
    static void bundleReassignmentTest() {
        Treatment_Bundle__c master = TestDataFactory.createMasterBundle();
        Treatment_Bundle__c bundle = TestDataFactory.createTreatmentBundle();
        Treatment_Bundle__c bundleTwo = TestDataFactory.createTreatmentBundle();
        bundleTwo.Name = 'Bundle Two';
        update bundleTwo;

        List<Protocol__c> protocols = TestDataFactory.createProtocols(5);
        List<Protocol__c> protocolsTwo = TestDataFactory.createProtocols(8);

        List<Bundle_Entry__c> masterEntries = TestDataFactory.assignEntries(master, protocols);
        List<Bundle_Entry__c> masterEntriesTwo = TestDataFactory.assignEntries(master, protocolsTwo);

        List<Bundle_Entry__c> bundleEntries = TestDataFactory.assignEntries(bundle, protocols);
        List<Bundle_Entry__c> bundleTwoEntries = TestDataFactory.assignEntries(bundleTwo, protocolsTwo);

        Treatment_Plan__c plan = new Treatment_Plan__c();
        plan.MasterTreatmentBundleId__c = master.Id;
        insert plan;

        plan.Preferred_Motivators__c = 'Test';
        plan.AssignedTreatmentBundleId__c = bundle.Id;
        update plan;
        plan.AssignedTreatmentBundleId__c = bundleTwo.Id;
        update plan;

    }

    @isTest 
    static void assignPlanTest(){
        Treatment_Plan__c plan = TestDataFactory.createPlan();
        Behavior_Evaluation__c be = new Behavior_Evaluation__c(
            Puppy_Behavior_in_Kennel__c = 'Social;Excited',
            Puppy_Behavior_on_Leash__c = 'Mildly fearful;Panicked',
            Animal__c = plan.Animal__c,
            Scribe_Initials__c = 'SI',
            Tester_Initials__c = 'TI',
            Handler_Initials__c = 'HI',
            Comments_BIK__c = 'Test Comments for Unit Test',
            Comments_BOL__c = 'Other Test Comments for Unit Test',
            Puppy_Skipped_DI_P1__c = 'Skipped not necessary',
            Puppy_Skipped_DI_P2__c = 'Skipped not necessary',
            Puppy_Skipped_DI_P3__c = 'Skipped not necessary',
            Evaluation_Subtype__c = 'Puppy',
            Potential_Behavior_Issues__c = 'Aggression to People;Other'
        );
        insert be;

        ServiceRequest req = new ServiceRequest('test request','assignPlan',null);
        req.Parameters.put('recordId',(Object) be.Id);

        test.startTest();
            ServiceResponse response = TreatmentPlanService.process(req);
        test.stopTest();
        System.AssertEquals('SUCCESS', response.Data);

    }
}