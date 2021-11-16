public class Last5TreatmentsController {
    
    public List<Session_Protocol__c> treatments {get;set;}
    
    public Last5TreatmentsController() {
        treatments = [SELECT Id
                      , Aggressive_Worst__c
                      , Arousal_Best__c
                      , Arousal_Worst__c
                      , Fear_Best__c
                      , Social_Best__c
                      , Fear_Worst__c
                      , Solicitation__c
                      , Overall_Score__c
                      , Protocol_Notes__c
                      , CreatedDate
                      , Novel_Person__c
                      , IsSkipped__c
                      , ProtocolId__r.Name
                      FROM Session_Protocol__c
                      WHERE TreatmentSessionId__r.Treatment_Plan__c = 'a257h000000wrKqAAI'
                      /* WHERE TreatmentSessionId__r.Treatment_Plan__c = :treatmentPlanId*/
                      ORDER BY Id, CreatedDate DESC
                      /* LIMIT :recordCount*/
                     ];
    }
}