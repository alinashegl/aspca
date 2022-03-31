public with sharing class MRCTreatmentPlansReportLWCController {
    @AuraEnabled
    public static Animal__c[] getMRCDogs(){
        try {
            return [
                SELECT Id 
                FROM Animal__c 
                WHERE Type_of_Animal__c = 'Dog'
                AND Current_Location__c IN ('MRC','CRC')
                AND Final_Outcome__c = null

            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static AnimalInfo getAnimalInfo(Id recordId){
        try {
            AnimalInfo info = new AnimalInfo();
            info.restDays = DailyCareLWCController.getAnimalRestDays(recordId);
            info.motivators = getMotivators(recordId);
            info.helperDogs = getHelperDogs(recordId);
            info.categoryToProtocolIdMap = getProtocolIdMap(recordId);

            return info;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Plan_Protocol__c getPlanProtocolInfo(Id recordId){
        try {
            Plan_Protocol__c[] proto = [SELECT Id, Protocol_Notes__c FROM Plan_Protocol__c WHERE Id =: recordId LIMIT 1];
            return !proto.isEmpty() ? proto[0] : null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static Map<String, Id[]> getProtocolIdMap(Id animalId){
        Map<String, Id[]> protocolMap = new Map<String, Id[]>();
        for(Plan_Protocol__c protocol : [
            SELECT Id, Protocol__r.Protocol_Categories__c 
            FROM Plan_Protocol__c 
            WHERE Treatment_Plan__r.IsActive__c = TRUE
            AND Treatment_Plan__r.Animal__c =: animalId
        ]){
            String category = protocol.Protocol__r.Protocol_Categories__c == null ? 'Non Fear Protocols' : protocol.Protocol__r.Protocol_Categories__c;
            
            if(protocolMap.containsKey(category)){
                protocolMap.get(category).add(protocol.Id);
            }else{
                protocolMap.put(category, new Id[]{protocol.Id});
            }
        }
        return protocolMap;
    }

    private static String getMotivators(Id animalId){

        return 'motivators';

    }

    private static String getHelperDogs(Id animalId){

        return 'helper dogs';

    }

    public class AnimalInfo{
        @AuraEnabled public String restDays;
        @AuraEnabled public String motivators;
        @AuraEnabled public String helperDogs;
        @AuraEnabled public Map<String, Id[]> categoryToProtocolIdMap;
    }
}
