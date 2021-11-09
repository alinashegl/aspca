public class TreatmentToDoPDFController {
    
    public List<Animal__c> objAnimal{get;set;}
    public List<Treatment_Plan__c> treatmentPlans{get;set;}
    public List<Treatment_Bundle__c> bundle{get;set;} 
    public List<Plan_Protocol__c> protocols{get;set;} 
    public List<Protocol__c> proto{get;set;} 
    
    public TreatmentToDoPDFController (){
        treatmentPlans = [SELECT Id
                          , Name
                          , Treatment_Priority__c
                          , Animal__c
                          , IsActive__c
                          , Preferred_Motivators__c
                          , Plan_Notes__c
                          , Animal__r.Animal_Name__c
                          , Animal__r.Name
                          , Animal__r.Location__c
                          , Animal__r.Shelter_Location2__c
                          , Animal__r.Number_of_Treatments__c
                          , Animal__r.Gender__c
                          , Animal__r.Current_Animal_Age_Estimate__c
                          , Animal__r.Current_Behavior_Grade__c
                          , Animal__r.Shelter_Location__c
                          , AssignedTreatmentBundleId__r.Name
                          , AssignedTreatmentBundleId__c
                          , Animal__r.Shelter_Color_Coding__c 
                          , (SELECT Id
                             , Protocol_Name__c
                             FROM Plan_Protocols__r)
                          FROM Treatment_Plan__c WHERE IsActive__c = TRUE
                          /*								AND Animal__r.Shelter_Location2__c =: key*/];
    }
    
/*    public String getProtocolStr() {
        String protocolStr = '';
        List<Plan_Protocol__c> protocolLst = new List<Plan_Protocol__c>([SELECT Id
                                                                         , Name
                                                                         , Protocol__r.Name
                                                                         , Treatment_Plan__r.Name
                                                                         FROM Plan_Protocol__c where Treatment_Plan__r.IsActive__c = TRUE 
                                                                         ]);
List<String> protocolNames = new List<String>();

        for(Plan_Protocol__c protocolObj : protocolLst){
            protocolNames.add(protocolObj.Protocol__r.Name);
       }
        protocolStr = string.join(protocolNames, '; ');
        return protocolStr;
    }*/
}