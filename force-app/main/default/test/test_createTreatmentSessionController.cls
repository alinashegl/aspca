@isTest
private class test_createTreatmentSessionController {
    @isTest 
    static void getActiveTreatmentPlanHasPlan(){
        Treatment_Plan__c plan = TestDataFactory.createPlan();

        test.startTest();
            Treatment_Plan__c returnedPlan = createTreatmentSessionController.getActiveTreatmentPlan(plan.Animal__c);
        test.stopTest();

        System.assertEquals(plan.Id, returnedPlan.Id);
    }

    static void getActiveTreatmentPlanNoPlan(){
        Animal__c anim = TestDataFactory.createAnimal();

        test.startTest();
            Treatment_Plan__c returnedPlan = createTreatmentSessionController.getActiveTreatmentPlan(anim.Id);
        test.stopTest();

        System.assertEquals(null, returnedPlan.Id);
    }
}