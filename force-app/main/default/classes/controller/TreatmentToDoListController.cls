public with sharing class TreatmentToDoListController {
    @AuraEnabled(cacheable=true)
    public static List<Treatment_Plan__c> getAnimalTreatments(String locationsFilter) {
        Treatment_Plan__c[] treatmentPlans = new QueryTreatmentPlansForList(locationsFilter).treatmentPlanList;

        return treatmentPlans;
    }

    public static SObject cloneRecord(ID recordId){
        DescribeSObjectResult describeResult = recordId.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query =
        ' SELECT ' +
            String.join( fieldNames, ',' ) +
        ' FROM ' +
            describeResult.getName() +
        ' WHERE ' +
            ' id = :recordId ' +
        ' LIMIT 1 '
        ;
        SObject record = Database.query( query );
        sObject sObj = Schema.getGlobalDescribe().get(describeResult.getName()).newSObject();
        sObj = record.clone();
        return sObj;
    }

    public class QueryTreatmentPlansForList{
        public Treatment_Plan__c[] treatmentPlanList;

        public String treatmentPlanSelect = 'SELECT Id, Name, Treatment_Priority__c, Animal__c, IsActive__c, ' +
            'Animal__r.Animal_Name__c, Animal__r.Name, Animal__r.Location__c, Animal__r.Number_of_Treatments__c, ' +
            'Animal__r.Gender__c, Animal__r.Current_Animal_Age_Estimate__c, Animal__r.Current_Behavior_Grade__c, Animal__r.Shelter_Location__c, ' +
            'AssignedTreatmentBundleId__c, AssignedTreatmentBundleId__r.Name, Shelter_Color_Code__c, Animal__r.Behavior_Case_Worker__r.Name, ' +
            'Animal__r.Current_Location__c, Preferred_Motivators__c, Plan_Notes__c, Animal__r.Shelter_Location2__c, '+ 
            'Animal__r.Shelter_Color_Coding__c ';
        
        public String treatmentQueryChildProtocols = ',(SELECT Id, Protocol_Name__c ' +
            'FROM Plan_Protocols__r ' +
            'WHERE IsRemoved__c = False) ';

        public String treatmentQueryFrom = 'FROM Treatment_Plan__c ' +
            'WHERE Animal__r.Location_Filter__c = true ' +
            'AND  Animal__r.Active_Animal__c = true ' +
            'AND IsActive__c = TRUE ' +
            'AND Treatment_Priority__c != null ' +
            'AND Treatment_Priority__c != \'No Treatment\' ';

        public QueryTreatmentPlansForList(String locationsFilter){
            String query = treatmentPlanSelect + treatmentQueryFrom;
            AnimalLocationFilterUtil filterInfo = new AnimalLocationFilterUtil(locationsFilter);

            if(filterInfo.useFilter == true){
                String[] locationsList = filterInfo.locationList;
                query += 'AND Animal__r.Current_Location__c IN :locationsList ';
            }

            query += 'ORDER BY Id';

            this.treatmentPlanList = Database.query(query); 
        }

        public QueryTreatmentPlansForList(String locationsFilter, Boolean useFilter){
            String query = treatmentPlanSelect + treatmentQueryChildProtocols + treatmentQueryFrom;
            
            if(useFilter == true){
                String[] locationsList = locationsFilter.split(',');
                query += 'AND Animal__r.Current_Location__c IN :locationsList ';
            }

            query += 'ORDER BY Id';

            this.treatmentPlanList = Database.query(query);
        }
    }
}