public with sharing class createTreatmentSessionController {
    @AuraEnabled
    public static String getActiveTreatmentPlan(Id animalId) {
        Treatment_Plan__c[] plans = [SELECT Id FROM Treatment_Plan__c WHERE Animal__c =: animalId AND IsActive__c = true LIMIT 1];
        return !plans.isEmpty() ? (String) plans[0].Id : null;
    }
}
