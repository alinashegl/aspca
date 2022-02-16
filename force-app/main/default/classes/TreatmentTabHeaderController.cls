public with sharing class TreatmentTabHeaderController {

    @AuraEnabled (cacheable=true)
    public static String getActiveTreatmentPlan(Id animalId) {
        Treatment_Plan__c[] plans = [SELECT Id FROM Treatment_Plan__c WHERE Animal__c =: animalId AND IsActive__c = true LIMIT 1];
        // Map<String, String> returnMap = new Map<String, String>{
        //     'Id' => !plans.isEmpty() ? plans[0].Id : null,
        //     'hasPlan' => !plans.isEmpty() ? 'true' : 'false'
        // };
        return !plans.isEmpty() ? (String) plans[0].Id : 'noPlan';
    }
}
