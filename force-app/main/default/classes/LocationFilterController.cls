public with sharing class LocationFilterController {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getAnimalLocations(String applicationType){
        try {
            Animal_Location_Config__mdt locConfig = new Animal_Location_Config__mdt();
            User u = [SELECT Id, Location__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            if(u.Location__c != null){
                locConfig = [
                    SELECT Id, Animal_Locations__c 
                    FROM Animal_Location_Config__mdt 
                    WHERE User_Location__c = :u.Location__c
                    AND Application_Type__c = :applicationType
                ];
            }
            System.debug('locConfig: ' + locConfig);
            String locations = locConfig != null && locConfig.Animal_Locations__c != null ? '{"locs":' + locConfig.Animal_Locations__c + '}' : null;

            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(locations);
            System.debug('m: ' + m);

            List<Map<String, Object>> myMaps = new List<Map<String, Object>>();
            List<Object> myMapObjects = (List<Object>) m.get('locs');
            for (Object obj : myMapObjects) {
                myMaps.add((Map<String, Object>)obj);
            }
            System.debug('myMaps: ' + myMaps);

            // System.debug('locations: ' + locations);
            return myMaps;
        } catch (Exception e) {
            System.debug('e.stacktrace: '+ e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }
}
