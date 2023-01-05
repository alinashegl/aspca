public with sharing class LocationFilterController {
    @AuraEnabled
    public static Map<String, Object> getAnimalLocations(String applicationType, String currentApp){
        try {
            //this is used as a back up in case for some reason the current app is null
            if(currentApp == null){
                currentApp = getUsersCurrentApp();
            }
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

            Map<String, Object> returnMap = new Map<String, Object>();
            returnMap.put('hasConfigWithLocations', (Object) false);
            returnMap.put('showAllLocations', (Object) false);

            if(!locConfigs.isEmpty()){
                Animal_Location_Config__mdt config = locConfigs[0];
                
                String locations = config.Animal_Locations__c != null ? config.Animal_Locations__c : null;

                if(locations != null){
                    returnMap.put('hasConfigWithLocations', (Object) true);
                    AnimalLocationFilterUtil util = new AnimalLocationFilterUtil();
                    returnMap.put('locations', util.locationStringToObjectList(locations));
                } else {
                    returnMap.put('showAllLocations', (Object) true);
                }
            } else {
                returnMap.put('hasConfigWithLocations', (Object) false);
            }
            System.debug('returnMap: ' + returnMap);
            
            return returnMap;
        } catch (Exception e) {
            System.debug('error getting locations: ' + e.getMessage());
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static String getUsersCurrentApp(){
        String currentApp;
        if(test.isRunningTest()){
            currentApp = null;
        } else {
            UserAppInfo userAppInfo = [SELECT Id, AppDefinitionId FROM UserAppInfo WHERE UserId = :UserInfo.getUserId() LIMIT 1];
            AppDefinition appDefinition = [SELECT DurableId, Label FROM AppDefinition Where DurableId = :userAppInfo.AppDefinitionId LIMIT 1];
            currentApp = appDefinition.Label;
        }
        return currentApp;
    }
}