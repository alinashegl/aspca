public class TreatmentToDoPDFController {
    public List<TreatmentPlanWithProtocols> treatmentPlansWithProtocols{get;set;}
    public TreatmentToDoPDFController (){
        String locationsFilter = ApexPages.currentPage()?.getparameters()?.get('locations');
        Boolean useFilter = Boolean.valueOf(ApexPages.currentPage()?.getparameters()?.get('useFilter'));

        TreatmentPlanWithProtocols[] treatmentPlanList = new TreatmentPlanWithProtocols[0];

        for(Treatment_Plan__c plan : new TreatmentToDoListController.QueryTreatmentPlansForList(locationsFilter, useFilter).treatmentPlanList){

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