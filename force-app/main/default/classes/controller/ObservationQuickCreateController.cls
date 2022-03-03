public with sharing class ObservationQuickCreateController {
    @AuraEnabled
    public static Daily_Enrichment__c getEnrichmentNotes(Id enrichmentId) {
        List<Daily_Enrichment__c> enrichment = [SELECT Notes__c, Animal__c FROM Daily_Enrichment__c WHERE Id = :enrichmentId LIMIT 1];
        if (enrichment.size() > 0) {
            return enrichment[0];
        }
        else {
            return null;
        }
    }
    
    @AuraEnabled
    public static Observation__c createQuickObservation(Observation__c observation) {
        try {
            insert observation;
            return observation;
        }
        catch (DMLException ex) {
            System.debug('Error creating record: ' + ex.getMessage());
            return null;
        }
    }
}