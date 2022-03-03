public with sharing class LastTreatmentsController {
    @AuraEnabled(cacheable=true)
    public static List<Session_Protocol__c> getLastTreatments(Id treatmentPlanId, Id protocolId, Integer recordCount) {
        List<Session_Protocol__c> treatments = [SELECT Id, Overall_Score__c, Protocol_Notes__c, CreatedDate, Novel_Person__c
                                                FROM Session_Protocol__c
                                                WHERE TreatmentSessionId__r.Treatment_Plan__c = :treatmentPlanId
                                                AND ProtocolId__c = :protocolId
                                                ORDER BY CreatedDate DESC
                                                LIMIT :recordCount];
        return treatments;
    }
}