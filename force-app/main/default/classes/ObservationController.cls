public with sharing class ObservationController {
    @AuraEnabled (cacheable=true)
    public static Observation__c[] getObservations(Id recordId, String observationType, Integer count){
        System.debug('in getObservations');
        System.debug('recordId: ' + recordId);
        System.debug('observationType: ' + observationType);
        try {
            String query = 'SELECT Id, Animal__c, Daily_Enrichment__c, Observation_Date__c, Observation_Notes__c, Observation_Reported_By__c, Observation_Type__c ' +
                'FROM Observation__c WHERE Animal__c =: recordId AND Observation_Type__c =: observationType ORDER BY CreatedDate DESC';
            if(count != null){
                query += ' LIMIT : count';
            }
            
            Observation__c[] observations = database.query(query);

            System.debug('observations: ' + observations);
            return !observations.isEmpty() ? observations : null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
