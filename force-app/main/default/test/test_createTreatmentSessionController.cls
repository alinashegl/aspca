@isTest
private class test_createTreatmentSessionController {
    @isTest 
    static void getActiveTreatmentPlanHasPlan(){
        Treatment_Plan__c plan = TestDataFactory.createPlan();

        test.startTest();
            String planId = createTreatmentSessionController.getActiveTreatmentPlan(plan.Animal__c);
        test.stopTest();

        System.assertEquals(plan.Id, planId);
    }

    static void getActiveTreatmentPlanNoPlan(){
        Animal__c anim = TestDataFactory.createAnimal();

        test.startTest();
            String planId = createTreatmentSessionController.getActiveTreatmentPlan(anim.Id);
        test.stopTest();

        System.assertEquals(null, planId);
    }
}
