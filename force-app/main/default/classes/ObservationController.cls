public with sharing class ObservationController {
    @AuraEnabled (cacheable=true)
    public static Observation__c[] getObservations(Id recordId, String observationType){
        try {
            Observation__c[] observations = [
                SELECT Id, Animal__c, Daily_Enrichment__c, Observation_Date__c, Observation_Notes__c, Observation_Reported_By__c, Observation_Type__c,
                Behavior_Response__c, Behavior_Staff_Initials__c
                FROM Observation__c 
                WHERE Animal__c =: recordId 
                AND Observation_Type__c =: observationType 
                ORDER BY Observation_Date__c DESC];

            if(!observations.isEmpty()){
                return observations;
            }
            else {
                return null;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean getUserLocation(){
        try {
            Boolean isArcCare = false;
            User u = [SELECT Id, Location__c FROM User WHERE Id =: userInfo.getUserId() LIMIT 1];
            String[] locations = Util.translateLocation(u.Location__c);
            
            if(locations.contains('ARC') || locations.contains('CARE')){
                isArcCare = true;
            }

            return isArcCare;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}