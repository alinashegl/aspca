public with sharing class EnrichmentQuickCreateController {
    @AuraEnabled
    public static Treatment_Plan__c getTreatmentPlan(Id animalId) {
        List<Treatment_Plan__c> treatmentPlan = [SELECT Id, AssignedTreatmentBundleId__c, Enrichment_Activities__c, Shelter_Color_Code__c FROM Treatment_Plan__c WHERE Animal__c = :animalId AND IsActive__c = true LIMIT 1];
        if (treatmentPlan.size() > 0) {
            return treatmentPlan[0];
        }
        else {
            return null;
        }
    }
    
    @AuraEnabled
    public static Daily_Enrichment__c createQuickEnrichment(Daily_Enrichment__c enrichment) {
        try {
            insert enrichment;
            return enrichment;
        }
        catch (DMLException ex) {
            System.debug('Error creating record: ' + ex.getMessage());
            return null;
        }
    }
}