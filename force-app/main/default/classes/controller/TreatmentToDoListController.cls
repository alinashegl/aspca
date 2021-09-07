/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentToDoListController {
    public class TreatmentToDoListData{
        @AuraEnabled public String name;
        @AuraEnabled public Animal__c animal;
        @AuraEnabled public Treatment_Plan__c plan;
        @AuraEnabled public String priority;
        @AuraEnabled public String assignment;
        @AuraEnabled public Integer treatmentcount;
        @AuraEnabled public String colorCode;

        public TreatmentToDoListData(String name, String priority, String assignment, Integer treatmentCount, String
                colorCode) {
            this.name = name;
            this.priority = priority;
            this.assignment = assignment;
            this.treatmentcount = treatmentCount;
            this.colorCode = colorCode;
        }

        public TreatmentToDoListData() { }
    }

    @AuraEnabled
    public static List<TreatmentToDoListData> listData(String key) {
        List<Animal__c> animals = [SELECT Id, Name, Location__c, Shelter_Location2__c FROM Animal__c WHERE
                Shelter_Location2__c =: key];
        List<Treatment_Plan__c> treatmentPlans = [SELECT Id, Name, Treatment_Priority__c, Animal__c, IsActive__c,
                AssignedTreatmentBundleId__c, Shelter_Color_Code__c FROM Treatment_Plan__c WHERE Animal__c =: animals
                AND IsActive__c = TRUE];
        Map<Id, Animal__c> animalsByIds = new Map<Id, Animal__c>(animals);
        Map<Id, Treatment_Plan__c> treatmentPlansByIds = new Map<Id, Treatment_Plan__c>(treatmentPlans);

        Map<Id, Treatment_Session__c> sessionsByIds = new Map<Id, Treatment_Session__c>([SELECT Id,
                Treatment_Plan__c, CreatedDate
                FROM Treatment_Session__c WHERE Treatment_Plan__c =: treatmentPlans]);
        Map<Id, List<Treatment_Session__c>> idToTreatmentSessionMap = new Map<Id, List<Treatment_Session__c>>();
        for(Treatment_Plan__c plan : treatmentPlans) {
            List<Treatment_Session__c> sessions = new List<Treatment_Session__c>();
            for(Treatment_Session__c session : sessionsByIds.values()) {
                if (plan.Id == session.Treatment_Plan__c) {
                    sessions.add(session);
                }
            }
            idToTreatmentSessionMap.put(plan.id, sessions);
        }

        List<TreatmentToDoListData> data = new List<TreatmentToDoListData>();

        for(Treatment_Plan__c plan : treatmentPlans) {
            Animal__c animal = animalsByIds.get(plan.Animal__c);
            TreatmentToDoListData item = new TreatmentToDoListData();
            item.name = animal.Name == null ? 'None Found' : animal.Name;
            item.priority = plan.Treatment_Priority__c == null ? 'None Found' : plan.Treatment_Priority__c;

            Treatment_Bundle__c bundle = new Treatment_Bundle__c();
            if(plan.AssignedTreatmentBundleId__c != null) { bundle = [SELECT Name, Id FROM Treatment_Bundle__c WHERE Id =: plan
                    .AssignedTreatmentBundleId__c]; }
            item.assignment = bundle == null ? 'None Found' : bundle.Name;
            item.colorCode = plan.Shelter_Color_Code__c == null ? 'None Found' : plan.Shelter_Color_Code__c;
            List<Treatment_Session__c> sessions = idToTreatmentSessionMap.get(plan.Id);
            item.treatmentcount = 5;
            item.animal = animal;
            item.plan = plan;
            data.add(item);
        }
        System.debug(data);
        return data;
    }
}