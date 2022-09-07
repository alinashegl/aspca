public with sharing class MRCTreatmentPlansReportLWCController {
    public List<String> categoryList = new List<String>{'Fear Socialization','Fear Leashing','Fear Walking','Fear Handling','Fear Containment','Non Fear Protocols'};
	public Generic_Data__c genericData {get;set;}
    public List<AnimalInfo> infoWrapper {get; set;}
    public MRCTreatmentPlansReportLWCController(){
        infoWrapper = getMRCDogsForPDF();
        for(AnimalInfo ai: infoWrapper){
            List<CategoryToProtocol> categoryProtocols = new List<CategoryToProtocol>();
            for(String s : categoryList){
                CategoryToProtocol cp = new CategoryToProtocol();
                cp.category = s;
                if(ai.categoryToProtocolMap != null && ai.categoryToProtocolMap.containsKey(s)){
                   cp.protocols = ai.categoryToProtocolMap.get(s);
                } else {
                    cp.protocols = new List<SObject>();
                }
                categoryProtocols.add(cp);
            }
            ai.categoryProtocol = categoryProtocols;
        }
        genericData = getTipOfMonth();
    }
    
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
                SELECT Id, Animal_Name_Id__c, Gender__c, Breed__c, Current_Location__c, Shelter_Color_Coding__c, Shelter_Location__c,Helper_Dogs__c,
                (SELECT Id, Preferred_Motivators__c FROM Treatment_Plan__r),
                (SELECT Id FROM Play_Pauses__r WHERE (End_Date__c = null OR End_Date__c >= TODAY) LIMIT 1)
                FROM Animal__c 
                WHERE Type_of_Animal__c = 'Dog'
                AND Current_Location__c IN ('MRC','CRC')
                AND Active_Animal__c = true
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
        Map<Id, Map<String, Plan_Protocol__c[]>> animalCategorySessionMap = getProtocolCategoryMap(animalIds);

        AnimalInfo[] infos = new AnimalInfo[0];

        for(Animal__c dog : mrcDogs){
            AnimalInfo info = new AnimalInfo();
            info.dog = dog;
            info.restDays = restDaysMap.get(dog.Id);
            info.motivators = getMotivators(dog);
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

    @AuraEnabled(cacheable=true)
    public static Animal__c getHelperDogs(Id recordId){
        return [SELECT Id, Helper_Dogs__c FROM Animal__c WHERE Id =: recordId LIMIT 1];
    }

    @AuraEnabled
    public static Generic_Data__c getTipOfMonth(){
        Generic_Data__c[] gData = [
            SELECT Id, Text__c 
            FROM Generic_Data__c 
            WHERE Species__c = 'Dog'
            AND Location__c = 'MRC'
            AND Name = 'MRC TOM'
            LIMIT 1
        ];

        return !gData.isEmpty() ? gData[0] : null;
    }

    @testVisible
    private static Map<Id, Map<String, Plan_Protocol__c[]>> getProtocolCategoryMap(Id[] animalIds){
        Map<Id, Map<String, Plan_Protocol__c[]>> animalCategoryProtocolMap = new Map<Id, Map<String, Plan_Protocol__c[]>>();

        for(Plan_Protocol__c protocol : [
            SELECT Id, Protocol__r.Protocol_Categories__c, Protocol_Notes__c, Treatment_Plan__r.Animal__c, Protocol_Name__c, IsRemoved__c
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

    @testVisible
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

    public class AnimalInfo{
        @AuraEnabled public Animal__c dog {get;set;}
        @AuraEnabled public String restDays {get;set;}
        @AuraEnabled public String motivators {get;set;}
        @AuraEnabled public Boolean isPlayPause {get;set;}
        @AuraEnabled public Map<String, Plan_Protocol__c[]> categoryToProtocolMap {get;set;}
        @AuraEnabled public List<CategoryToProtocol> categoryProtocol {get;set;}
    }
    
    public class CategoryToProtocol {
        public String category {get; set;}
        public List<Plan_Protocol__c> protocols{get; set;}
    }
}