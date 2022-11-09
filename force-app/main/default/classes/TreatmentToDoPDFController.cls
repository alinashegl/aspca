public class TreatmentToDoPDFController {
    public List<TreatmentPlanWithProtocols> treatmentPlansWithProtocols{get;set;}
    public TreatmentToDoPDFController (){
        String locationsFilter = ApexPages.currentPage()?.getparameters()?.get('locations');
        Boolean useFilter = Boolean.valueOf(ApexPages.currentPage()?.getparameters()?.get('useFilter'));

        TreatmentPlanWithProtocols[] treatmentPlanList = new TreatmentPlanWithProtocols[0];
        for(Treatment_Plan__c plan : [SELECT Id
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
                             FROM Plan_Protocols__r
                             WHERE IsRemoved__c = False)
                          FROM Treatment_Plan__c 
                                      WHERE Animal__r.Location_Filter__c = true
                                      AND  Animal__r.Active_Animal__c = true
                                      AND IsActive__c = TRUE
                                      AND Treatment_Priority__c != null
                                      AND Treatment_Priority__c != 'No Treatment'
                          								/*AND Animal__r.Shelter_Location2__c =: key*/]){

            TreatmentPlanWithProtocols tPlan = new TreatmentPlanWithProtocols();
            tPlan.treatmentPlan = plan;

            List<String> protocolNames = new List<String>();
            for(Plan_Protocol__c protocolObj : plan.Plan_Protocols__r){
                protocolNames.add(protocolObj.Protocol_Name__c);
            }
            tPlan.protocols = string.join(protocolNames, '; ');

            treatmentPlanList.add(tPlan);
        }

        treatmentPlansWithProtocols = treatmentPlanList;
    }

    public class TreatmentPlanWithProtocols{
        public Treatment_Plan__c treatmentPlan {get; set;}
        public String protocols {get; set;}
    }
}