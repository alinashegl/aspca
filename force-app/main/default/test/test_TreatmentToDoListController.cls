@isTest
public with sharing class test_TreatmentToDoListController {
    @isTest
    static void getAnimalTreatmentsWithData() {
        User u = [SELECT Id, Location__c FROM User WHERE Id = :userInfo.getUserId() LIMIT 1];
        u.Location__c = 'All';
        update u;
        Treatment_Plan__c treatmentPlan = TestDataFactory.createPlan();
        Test.startTest();
        List<Treatment_Plan__c> treatmentPlans = TreatmentToDoListController.getAnimalTreatments();
        Test.stopTest();
        System.assertEquals(1, treatmentPlans.size());
    }

    @isTest
    static void getAnimalTreatmentsWithoutData() {
        Test.startTest();
        List<Treatment_Plan__c> treatmentPlans = TreatmentToDoListController.getAnimalTreatments();
        Test.stopTest();
        System.assertEquals(0, treatmentPlans.size());
    }

    @isTest
    static void getAnimalTreatmentsWithoutTreatmentPriority() {
        User u = [SELECT Id, Location__c FROM User WHERE Id = :userInfo.getUserId() LIMIT 1];
        u.Location__c = 'All';
        update u;
        Treatment_Plan__c treatmentPlan = TestDataFactory.createPlan();
        treatmentPlan.Treatment_Priority__c = null;
        update treatmentPlan;

        Test.startTest();
        List<Treatment_Plan__c> treatmentPlans = TreatmentToDoListController.getAnimalTreatments();
        Test.stopTest();
        System.assertEquals(0, treatmentPlans.size());
    }
    
    @isTest
    static void updateAnimalTreatment() {
        Treatment_Plan__c treatmentPlan = TestDataFactory.createPlan();
        Test.startTest();
        Map<String, Object> objMap = new Map<String, Object>{'Description__c'=> (Object)'Test'};
        TreatmentToDoListController.updateTreatment(treatmentPlan.Id, objMap);
        Test.stopTest();
    }
}