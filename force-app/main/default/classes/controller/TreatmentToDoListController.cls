public with sharing class TreatmentToDoListController {
    @AuraEnabled(cacheable=true)
    public static List<Treatment_Plan__c> getAnimalTreatments(String location) {
        String[] translatedLocation = util.translateLocation(location);
        List<Treatment_Plan__c> treatmentPlans = [SELECT Id, Name, Treatment_Priority__c, Animal__c, IsActive__c,
                Animal__r.Animal_Name__c, Animal__r.Name, Animal__r.Location__c, Animal__r.Number_of_Treatments__c,
                Animal__r.Gender__c, Animal__r.Current_Animal_Age_Estimate__c, Animal__r.Current_Behavior_Grade__c, Animal__r.Shelter_Location__c,
                AssignedTreatmentBundleId__c, AssignedTreatmentBundleId__r.Name, Shelter_Color_Code__c
                FROM Treatment_Plan__c
                WHERE Animal__r.Current_Recent_Shelter_Location__c IN: translatedLocation
                    AND IsActive__c = TRUE
                ORDER BY Id];
        return treatmentPlans;
    }

    @AuraEnabled(cacheable=false)
    public static void updateTreatment(ID recordId, Map<String, Object> fieldMap){
        sObject sObj = cloneRecord(recordId);
        for(String field : fieldMap.keySet()){
            sObj.put(field, fieldMap.get(field));
        }
        insert sObj;
    }

    @AuraEnabled 
    public static String getUserLocation(){
        try {
            return [SELECT Location__c FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].Location__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
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
}