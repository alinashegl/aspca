public with sharing class LocationFilterController {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getAnimalLocations(String applicationType){
        try {
            UserAppInfo userAppInfo = [SELECT Id, AppDefinitionId FROM UserAppInfo WHERE UserId = :UserInfo.getUserId() LIMIT 1];
            AppDefinition appDefinition = [SELECT DurableId, Label FROM AppDefinition Where DurableId = :userAppInfo.AppDefinitionId LIMIT 1];
            String currentApp = appDefinition.Label;

            Animal_Location_Config__mdt[] locConfigs = new Animal_Location_Config__mdt[0];
            User u = [SELECT Id, Location__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            if(u.Location__c != null){
                locConfigs = [
                    SELECT Id, Animal_Locations__c 
                    FROM Animal_Location_Config__mdt 
                    WHERE User_Location__c = :u.Location__c
                    AND Application_Type__c = :applicationType
                    AND App_Name__c = :currentApp
                ];
            }
            String locations = !locConfigs.isempty() && locConfigs[0].Animal_Locations__c != null ? '{"locs":' + locConfigs[0].Animal_Locations__c + '}' : null;

            List<Map<String, Object>> myMaps = new List<Map<String, Object>>();
            myMaps.add(new Map<String, Object>{'configFound' => (object) locations != null});

            if(locations != null){
                Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(locations);            
                List<Object> myMapObjects = (List<Object>) m.get('locs');
                for (Object obj : myMapObjects) {
                    myMaps.add((Map<String, Object>)obj);
                }
            }
            
            return myMaps;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
