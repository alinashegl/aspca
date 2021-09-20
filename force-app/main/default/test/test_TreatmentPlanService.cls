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
}