public with sharing class TreatmentByDogLWCController {
    @AuraEnabled
    public static string[] getUserLocation(){
        try {
            return BehaviorUtil.locationGroup;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static DogWrapper[] getDogList(String[] selectedLocations){
        try {
            DogWrapper[] dogs = new DogWrapper[0];
            for(Animal__c dog : [SELECT Id, Animal_Name_Id__c, Current_Location__c FROM Animal__c WHERE Current_Location__c IN: selectedLocations]){
                dogs.add(new DogWrapper(dog));
            }
            return dogs;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Animal__c getDogInfo(Id recordId){
        System.debug('recordId: ' + recordId);
        return [
            SELECT Id, Animal_Name_Id__c, Gender__c, Breed__c, Current_Animal_Age_Formatted__c, Current_Location__c, 
            Current_Behavior_Grade__c, 
            (SELECT Id, Treatment_Priority__c FROM Treatment_Plan__r WHERE IsActive__c = true LIMIT 1)
            FROM Animal__c 
            WHERE Id =: recordId LIMIT 1 
        ];
    }

    public class DogWrapper{
        @AuraEnabled public Id id;
        @AuraEnabled public String name;
        @AuraEnabled public String location;
        @AuraEnabled public Boolean selected;

        public DogWrapper(Animal__c dog){
            this.id = dog.Id;
            this.name = dog.Animal_Name_Id__c;
            this.location = dog.Current_Location__c;
            this.selected = false;
        }
    }
    
}
