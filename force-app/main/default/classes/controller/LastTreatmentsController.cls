public with sharing class LastTreatmentsController {
    @AuraEnabled(cacheable=true)
    public static SessionProtocol[] getLastTreatments(Id treatmentPlanId, Id protocolId, Integer recordCount) {
        System.debug('**lastTreatments');
        List<SessionProtocol[]> protocolLists = new List<SessionProtocol[]>();
        Map<Id, SessionProtocol[]> sProtocolMap = new Map<Id, SessionProtocol[]>();
        SessionProtocol[] sProtocolList = new SessionProtocol[0];
        for(Session_Protocol__c sp : [
            SELECT Id, Overall_Score__c, Protocol_Notes__c, CreatedDate, Novel_Person__c, TreatmentSessionId__c, TreatmentSessionId__r.Session_Date__c,
            (
                SELECT Id, Protocol_Scale_Name__c, Protocol_Score__c, Protocol_Score_Number__c 
                FROM Session_Protocol_Scales__r
            )
            FROM Session_Protocol__c
            WHERE TreatmentSessionId__r.Treatment_Plan__c = :treatmentPlanId
            AND ProtocolId__c = :protocolId
            AND Status_Text__c = 'Complete'
            ORDER BY TreatmentSessionId__r.Session_Date__c DESC
            LIMIT :recordCount
        ]){
            SessionProtocol proto = new SessionProtocol(sp);
            System.debug('proto: ' + proto);
            sProtocolList.add(proto);
        }

        System.debug('sProtocolList: ' + sProtocolList);

        return sProtocolList;
    }
}