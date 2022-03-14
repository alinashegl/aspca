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
            info.categoryToProtocolIdMap = getProtocolIdMap(recordId);

            return info;
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

    // private static List<Plan_Protocol__c[]> getProtocolIdLists(Id animalId){
    //     Plan_Protocol__c[] protocols = [SELECT Id, Protocol__r.Protocol_Categories__c FROM Plan_Protocol__c WHERE Protocol__r.Protocol_Categories__c = 'Fear Walking'];
    //     List<Plan_Protocol__c[]> mainList = new List<Plan_Protocol__c[]>();
    //     mainList.add(protocols);
    //     return mainList;
    // }

    public class AnimalInfo{
        @AuraEnabled public String restDays;
        @AuraEnabled public Map<String, Id[]> categoryToProtocolIdMap;
    }
}
