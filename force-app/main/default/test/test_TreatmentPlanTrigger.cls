/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class test_TreatmentPlanTrigger {
    @IsTest
    static void regressionCoverage() {
        Test.startTest();
        Treatment_Plan__c plan = TestDataFactory.createPlan();
        Treatment_Bundle__c newBundle = TestDataFactory.createTreatmentBundle();
        List<Protocol__c> newProtocols = TestDataFactory.createProtocols(3);
        Plan_Protocol__c planProtocol = [SELECT Protocol__c FROM Plan_Protocol__c WHERE Treatment_Plan__c =: plan.Id LIMIT 1];
        newProtocols.add(new Protocol__c(Id = planProtocol.Protocol__c));
        List<Bundle_Entry__c> planBundleEntries = TestDataFactory.assignEntries(newBundle, newProtocols);
        plan.AssignedTreatmentBundleId__c = newBundle.Id;
        update plan;
        Treatment_Plan__c newPlan = new Treatment_Plan__c(IsActive__c = true, Description__c = 'Test 1', Animal__c = plan.Animal__c, AssignedTreatmentBundleId__c = plan.AssignedTreatmentBundleId__c);
        insert newPlan;
        Treatment_Plan__c inactivePlan = [SELECT Id, IsActive__c FROM Treatment_Plan__c WHERE IsActive__c = false LIMIT 1];
        inactivePlan.IsActive__c = true;
        update inactivePlan;
        Test.stopTest();
        List<Treatment_Plan__c> afterPlans = [SELECT Id, IsActive__c, Enrichment_Activities__c FROM Treatment_Plan__c WHERE IsActive__c = true];
        System.assertEquals(1, afterPlans.size());
        System.assertEquals(inactivePlan.Id, afterPlans[0].Id);
        System.assertEquals('Nose Work;Snuffle mat;Tug pully', afterPlans[0].Enrichment_Activities__c);
    }
}