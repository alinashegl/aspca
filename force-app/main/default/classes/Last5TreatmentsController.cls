public class Last5TreatmentsController {
    private Map<String, SessionProtocol[]> sProtocolsMap = new Map<String, SessionProtocol[]>();
    private Animal__c animal;
    private String animalId;

    public Last5TreatmentsController() {
        if (ApexPages.currentPage().getParameters().get('animalId') != null) {
            animalId = ApexPages.currentPage().getParameters().get('animalId');
            animal = [SELECT Name, Animal_Name__c FROM Animal__c WHERE Id = :animalId LIMIT 1];
            Treatment_Session__c[] sessions = [
                SELECT Id
                FROM Treatment_Session__c
                WHERE Treatment_Plan__r.IsActive__c = true
                AND Treatment_Plan__r.Animal__c = :animalId
                ORDER BY CreatedDate DESC
                LIMIT 5
            ];
            for(Session_protocol__c sp : [
                SELECT Id, Name, TreatmentSessionId__r.Session_Date__c, Solicitation__c, Overall_Score__c, Protocol_Notes__c, 
                IsSkipped__c, Session_Date__c, ProtocolId__c, ProtocolId__r.Name,
                (
                    SELECT Id, Protocol_Scale_Name__c, Protocol_Score__c, Protocol_Score_Number__c 
                    FROM Session_Protocol_Scales__r 
                    WHERE Protocol_Scale__r.isDefault__c = true
                )
                FROM Session_Protocol__c
                WHERE TreatmentSessionId__c IN :sessions
            ]){
                if(sProtocolsMap.containsKey(sp.ProtocolId__r.Name)){
                    sProtocolsMap.get(sp.ProtocolId__r.Name).add(new SessionProtocol(sp));
                } else {
                    sProtocolsMap.put(sp.ProtocolId__r.Name, new SessionProtocol[]{new SessionProtocol(sp)});
                }
            }
        }
    }

    public Map<String, SessionProtocol[]> getSProtocolsMap() {
        return sProtocolsMap;
    }

    public Animal__c getAnimal() {
        return animal;
    }
}