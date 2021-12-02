public with sharing class TreatmentToDoListController {
    @AuraEnabled(cacheable=true)
    public static List<Treatment_Plan__c> getAnimalTreatments(String location, String sortString, String filterString) {
        List<Treatment_Plan__c> treatmentPlans = Database.query('SELECT Id, Name, Treatment_Priority__c, Animal__c, IsActive__c, ' +
                'Animal__r.Animal_Name__c, Animal__r.Name, Animal__r.Location__c, Animal__r.Shelter_Location2__c, Animal__r.Number_of_Treatments__c, ' +
                'Animal__r.Gender__c, Animal__r.Current_Animal_Age_Estimate__c, Animal__r.Current_Behavior_Grade__c, Animal__r.Shelter_Location__c, ' +
                'AssignedTreatmentBundleId__c, AssignedTreatmentBundleId__r.Name, Shelter_Color_Code__c ' +
                'FROM Treatment_Plan__c ' +
                'WHERE Animal__r.Shelter_Location2__c =: location ' +
                    'AND IsActive__c = TRUE ' +
                    (String.isBlank(filterString) ? '' : filterString) +
                'ORDER BY ' + (String.isBlank(sortString) ? 'Id' : sortString));
        return treatmentPlans;
    }
}