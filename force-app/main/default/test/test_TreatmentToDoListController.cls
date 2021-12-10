@isTest
public with sharing class test_TreatmentToDoListController {
    @isTest
    static void getAnimalTreatmentsWithData() {
        Treatment_Plan__c treatmentPlan = TestDataFactory.createPlan();
        Test.startTest();
        List<Treatment_Plan__c> treatmentPlans = TreatmentToDoListController.getAnimalTreatments('MRC', '');
        Test.stopTest();
        System.assertEquals(1, treatmentPlans.size());
    }

    @isTest
    static void getAnimalTreatmentsWithoutData() {
        Test.startTest();
        List<Treatment_Plan__c> treatmentPlans = TreatmentToDoListController.getAnimalTreatments('MRC', '');
        Test.stopTest();
        System.assertEquals(0, treatmentPlans.size());
    }
}