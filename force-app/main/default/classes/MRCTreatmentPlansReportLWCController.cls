public with sharing class MRCTreatmentPlansReportLWCController {
    @AuraEnabled
    public static AnimalInfo[] getMRCDogsForPDF(){
        Animal__c[] mrcDogs = getMRCDogs();
        AnimalInfo[] infos = getAnimalInfos(mrcDogs);
        return infos;
    }

    @AuraEnabled
    public static Animal__c[] getMRCDogs(){
        try {
            return [
                SELECT Id, Animal_Name_Id__c, Gender__c, Breed__c, Current_Location__c, Shelter_Color_Coding__c, Shelter_Location__c,
                (SELECT Id, Preferred_Motivators__c FROM Treatment_Plan__r),
                (SELECT Id FROM Play_Pauses__r WHERE (End_Date__c = null OR End_Date__c >= TODAY) LIMIT 1)
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
    public static AnimalInfo[] getAnimalInfos(Animal__c[] mrcDogs){
        Id[] animalIds = new Id[0];
        for(Animal__c dog : mrcDogs){
            animalIds.add(dog.Id);
        }

        //key is animalId, value is a string of rest days
        Map<Id, String> restDaysMap = BehaviorUtil.getAnimalRestDays(animalIds);
        Map<Id, HelperDogsWrapper> animalToHelperDogsMap = getHelperDogs(animalIds);
        Map<Id, Map<String, Plan_Protocol__c[]>> animalCategorySessionMap = getProtocolCategoryMap(animalIds);

        AnimalInfo[] infos = new AnimalInfo[0];

        for(Animal__c dog : mrcDogs){
            AnimalInfo info = new AnimalInfo();
            info.dog = dog;
            info.restDays = restDaysMap.get(dog.Id);
            info.motivators = getMotivators(dog);
            info.helperDogs = animalToHelperDogsMap.get(dog.Id);
            info.isPlayPause = !dog.Play_Pauses__r.isEmpty();
            info.categoryToProtocolMap = animalCategorySessionMap.containsKey(dog.Id) ? animalCategorySessionMap.get(dog.Id) : null;
            infos.add(info);

        }
        return infos;
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

    private static Map<Id, Map<String, Plan_Protocol__c[]>> getProtocolCategoryMap(Id[] animalIds){
        Map<Id, Map<String, Plan_Protocol__c[]>> animalCategoryProtocolMap = new Map<Id, Map<String, Plan_Protocol__c[]>>();

        for(Plan_Protocol__c protocol : [
            SELECT Id, Protocol__r.Protocol_Categories__c, Treatment_Plan__r.Animal__c, Protocol_Name__c, IsRemoved__c
            FROM Plan_Protocol__c 
            WHERE Treatment_Plan__r.IsActive__c = TRUE
            AND Treatment_Plan__r.Animal__c IN: animalIds
        ]){
            String category = protocol.Protocol__r.Protocol_Categories__c == null ? 'Non Fear Protocols' : protocol.Protocol__r.Protocol_Categories__c;

            if(animalCategoryProtocolMap.containsKey(protocol.Treatment_Plan__r.Animal__c)){
                if(animalCategoryProtocolMap.get(protocol.Treatment_Plan__r.Animal__c).containsKey(category)){
                    animalCategoryProtocolMap.get(protocol.Treatment_Plan__r.Animal__c).get(category).add(protocol);
                } else {
                    animalCategoryProtocolMap.get(protocol.Treatment_Plan__r.Animal__c).put(category, new Plan_Protocol__c[]{protocol});
                }
            } else{
                animalCategoryProtocolMap.put(
                    protocol.Treatment_Plan__r.Animal__c,
                    new Map<String, Plan_Protocol__c[]>{category => new Plan_Protocol__c[]{protocol}});
            }
        }
        return animalCategoryProtocolMap;
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

    private static String getMotivators(Animal__c dog){
        Set<String> motivators = new Set<String>();
        for(Treatment_Plan__c plan : dog.Treatment_Plan__r){
            if(plan.Preferred_Motivators__c == null || String.isBlank(plan.Preferred_Motivators__c)) {continue;}
            String[] pMotivators = plan.Preferred_Motivators__c.split(';');
            motivators.addAll(pMotivators);
        }

        String motivatorString = '';
        if(!motivators.isEmpty()){
            String[] motivatorList = new String[0];
            motivatorList.addAll(motivators);
            motivatorString = String.join(motivatorList, '; ');
        }

        return motivatorString;
    }

    private static Map<Id, HelperDogsWrapper> getHelperDogs(Id[] animalIds){
        Map<Id, HelperDogsWrapper> helperDogsWrapperMap = new Map<Id, HelperDogsWrapper>();
        Map<Id, Additional_Dog_Present__c[]> helperDogsMap = queryAdditionalDogs(animalIds);
        for(Id dogId : animalIds){
            HelperDogsWrapper hDogs = new HelperDogsWrapper();
            helperDogsWrapperMap.put(dogId, hDogs);
            if(helperDogsMap.containsKey(dogId)){
                Set<String> dNames = new Set<String>();
                hDogs.dogs = new Additional_Dog_Present__c[0];
                for(Additional_Dog_Present__c dog : helperDogsMap.get(dogId)){
                    dNames.add(dog.Additional_Dog__r.Animal_Name_Id__c);
                    hDogs.dogs.add(dog);
                }
                hDogs.names = String.join(new List<String>(dNames), '; ');
            }
        }
        return helperDogsWrapperMap;
    }

    private static Map<Id, Additional_Dog_Present__c[]> queryAdditionalDogs(Id[] animalIds){
        Map<Id, Additional_Dog_Present__c[]> dogMap = new Map<Id, Additional_Dog_Present__c[]>();
        for(Additional_Dog_Present__c additionalDog : [SELECT Id, Additional_Dog__r.Animal_Name_Id__c, Treatment_Plan__r.Animal__c FROM Additional_Dog_Present__c WHERE Treatment_Plan__r.Animal__c IN: animalIds AND Treatment_Plan__r.IsActive__c = true]){
            if(dogMap.containsKey(additionalDog.Treatment_Plan__r.Animal__c)){
                dogMap.get(additionalDog.Treatment_Plan__r.Animal__c).add(additionalDog);
            } else {
                dogMap.put(additionalDog.Treatment_Plan__r.Animal__c, new Additional_Dog_Present__c[]{additionalDog});
            }
        }

        return dogMap;
    }

    private static HelperDogsWrapper getHelperDogs(Id animalId){
        HelperDogsWrapper hDogs = new HelperDogsWrapper();
        Set<String> dNames = new Set<String>();
        hDogs.dogs = new Additional_Dog_Present__c[0];
        for(Additional_Dog_Present__c dog : [SELECT Id, Additional_Dog__r.Animal_Name_Id__c FROM Additional_Dog_Present__c WHERE Treatment_Plan__r.Animal__c =: animalId AND Treatment_Plan__r.IsActive__c = true]){
            dNames.add(dog.Additional_Dog__r.Animal_Name_Id__c);
            hDogs.dogs.add(dog);
        }
        hDogs.names = String.join(new List<String>(dNames), '; ');
        return hDogs;
    }

    public class AnimalInfo{
        @AuraEnabled public Animal__c dog;
        @AuraEnabled public String restDays;
        @AuraEnabled public String motivators;
        @AuraEnabled public HelperDogsWrapper helperDogs;
        @AuraEnabled public Boolean isPlayPause;
        @AuraEnabled public Map<String, Id[]> categoryToProtocolIdMap;
        @AuraEnabled public Map<String, Plan_Protocol__c[]> categoryToProtocolMap;
    }

    public class HelperDogsWrapper{
        @AuraEnabled public String names;
        @AuraEnabled public Additional_Dog_Present__c[] dogs;
    }
}
