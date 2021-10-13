public with sharing class ObservationController {
    @AuraEnabled (cacheable=true)
    public static Observation__c[] getObservations(Id recordId, String observationType){
        try {
            Observation__c[] observations = [
                SELECT Id, Animal__c, Daily_Enrichment__c, Observation_Date__c, Observation_Notes__c, Observation_Reported_By__c, Observation_Type__c
                FROM Observation__c 
                WHERE Animal__c =: recordId 
                AND Observation_Type__c =: observationType 
                ORDER BY Observation_Date__c DESC];

            return !observations.isEmpty() ? observations : null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
