@isTest
public with sharing class test_EnrichmentQuickCreateController {
    @isTest
    static void getTreatmentPlanSuccess() {
        Treatment_Plan__c plan = TestDataFactory.createPlan();
        Test.startTest();
        Treatment_Plan__c controllerPlan = EnrichmentQuickCreateController.getTreatmentPlan(plan.Animal__c);
        Test.stopTest();
        Treatment_Plan__c planFields = [SELECT Id, AssignedTreatmentBundleId__c, Enrichment_Activities__c, Shelter_Color_Code__c FROM Treatment_Plan__c WHERE Id = :plan.Id LIMIT 1];
        System.assertEquals(planFields.Id, controllerPlan.Id);
        System.assertEquals(planFields.AssignedTreatmentBundleId__c, controllerPlan.AssignedTreatmentBundleId__c);
        System.assertEquals(planFields.Enrichment_Activities__c, controllerPlan.Enrichment_Activities__c);
        System.assertEquals(planFields.Shelter_Color_Code__c, controllerPlan.Shelter_Color_Code__c);
    }

    @isTest
    static void getTreatmentPlanWrongId() {
        Animal__c a = TestDataFactory.createAnimal();
        Test.startTest();
        Treatment_Plan__c controllerPlan = EnrichmentQuickCreateController.getTreatmentPlan(a.Id);
        Test.stopTest();
        System.assertEquals(null, controllerPlan);
    }

    @isTest
    static void getTreatmentPlanBadId() {
        Treatment_Plan__c plan = TestDataFactory.createPlan();
        String idDeleted = plan.Animal__c;
        delete plan;
        Test.startTest();
        Treatment_Plan__c controllerPlan = EnrichmentQuickCreateController.getTreatmentPlan(idDeleted);
        Test.stopTest();
        System.assertEquals(null, controllerPlan);
    }

    @isTest
    static void createDailyEnrichment() {
        Treatment_Plan__c plan = TestDataFactory.createPlan();
        Daily_Enrichment__c enrichment = new Daily_Enrichment__c(
            Animal__c = plan.Animal__c,
            Notes__c = 'Test notes for test data factory',
            DE_Date__c = System.today(),
            Enrichment_Coordinator__c = 'Hailey Kohl'
        );
        Test.startTest();
        Daily_Enrichment__c created = EnrichmentQuickCreateController.createQuickEnrichment(enrichment);
        Test.stopTest();
        System.assertEquals('Test notes for test data factory', created.Notes__c);
        System.assertEquals(plan.Animal__c, created.Animal__c);
        System.assertEquals(System.today(), created.DE_Date__c);
        System.assertEquals('Hailey Kohl', created.Enrichment_Coordinator__c);
    }

    @isTest
    static void createDailyEnrichmentBadRecord() {
        Daily_Enrichment__c enrichment = new Daily_Enrichment__c();
        Test.startTest();
        Daily_Enrichment__c created = EnrichmentQuickCreateController.createQuickEnrichment(enrichment);
        Test.stopTest();
        System.assertEquals(null, created);
    }
}