public with sharing class LastTreatmentsController {
    @AuraEnabled(cacheable=true)
    public static SessionProtocol[] getLastTreatments(Id treatmentPlanId, Id protocolId, Integer recordCount) {
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
            sProtocolList.add(new SessionProtocol(sp));
            // if(sProtocolMap.containsKey(sp.TreatmentSessionId__c)){
            //     sProtocolMap.get(sp.TreatmentSessionId__c).add(new SessionProtocol(sp));
            // } else {
            //     sProtocolMap.put(sp.TreatmentSessionId__c, new SessionProtocol[]{new SessionProtocol(sp)});
            // }   
        }
        // for(SessionProtocol[] protos : sProtocolMap.values()){
        //     protocolLists.add(protos);
        // }
        System.debug('sProtocolList: ' + sProtocolList);

        return sProtocolList;
    }


    // public static List<Session_Protocol__c> getLastTreatments(Id treatmentPlanId, Id protocolId, Integer recordCount) {
    //     List<Session_Protocol__c> treatments = [
    //         SELECT Id, Overall_Score__c, Protocol_Notes__c, CreatedDate, Novel_Person__c
    //         FROM Session_Protocol__c
    //         WHERE TreatmentSessionId__r.Treatment_Plan__c = :treatmentPlanId
    //         AND ProtocolId__c = :protocolId
    //         AND Status_Text__c = 'Complete'
    //         ORDER BY CreatedDate DESC
    //         LIMIT :recordCount
    //     ];
    //     return treatments;
    // }
}