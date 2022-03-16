public with sharing class createTreatmentSessionController {
    @AuraEnabled
    public static Treatment_Plan__c getActiveTreatmentPlan(Id animalId) {
        Treatment_Plan__c[] plans = [SELECT Id, Preferred_Motivators__c FROM Treatment_Plan__c WHERE Animal__c =: animalId AND IsActive__c = true LIMIT 1];
        return !plans.isEmpty() ? plans[0] : null;
    }
}