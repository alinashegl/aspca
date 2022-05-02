public class Last5TreatmentsController {
    private Map<Id, List<Session_Protocol__c>> sessionProtocolMap = new Map<Id, List<Session_Protocol__c>>();
    private Animal__c animal;
    private String animalId;
    
    public Last5TreatmentsController() {
        if (ApexPages.currentPage().getParameters().get('animalId') != null) {
            animalId = ApexPages.currentPage().getParameters().get('animalId');
            animal = [SELECT Name, Animal_Name__c FROM Animal__c WHERE Id = :animalId LIMIT 1];
            for (Treatment_Session__c ts : [SELECT Id,
                                                (SELECT Id, Aggressive_Worst__c, Arousal_Best__c, Arousal_Worst__c, Fear_Best__c, Social_Best__c, Fear_Worst__c, Solicitation__c,
                                                Overall_Score__c, Protocol_Notes__c, IsSkipped__c, Session_Date__c, ProtocolId__c, ProtocolId__r.Name
                                                FROM Session_Protocols__r)
                                            FROM Treatment_Session__c
                                            WHERE Treatment_Plan__r.IsActive__c = true
                                                AND Treatment_Plan__r.Animal__c = :animalId
                                            ORDER BY CreatedDate DESC
                                            LIMIT 5]) {
                for(Session_Protocol__c sp : ts.Session_Protocols__r) {
                    if (sessionProtocolMap.containsKey(sp.ProtocolId__c)) {
                        sessionProtocolMap.get(sp.ProtocolId__c).add(sp);
                    }
                    else {
                        sessionProtocolMap.put(sp.ProtocolId__c, new List<Session_Protocol__c>{sp});
                    }
                }
            }
        }
    }

    public Map<Id, List<Session_Protocol__c>> getSessionProtocolMap() {
        return sessionProtocolMap;
    }

    public Animal__c getAnimal() {
        return animal;
    }
}