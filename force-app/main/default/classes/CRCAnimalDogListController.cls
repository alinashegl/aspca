public class CRCAnimalDogListController {
	@AuraEnabled
    public static CRCDogListResult getRecords() {
        Set<Id> animalIds = new Set<Id>();
        List<Treatment_Plan__c> objs = [SELECT Animal__c, Treatment_Priority__c, Enrichment_Priority__c, 
                Animal__r.Shelter_Color_Coding__c, Animal__r.Behavior_Summary_Change_Date__c,
                Animal__r.Name, Animal__r.Animal_Name__c, Animal__r.Animal_Name_Id__c,
                Animal__r.Meets_Adoptability_Date__c, Animal__r.Playgroup_Priority_Level__c, Animal__r.Current_Location__c,
                Animal__r.Behavior_Case_Worker__c, Animal__r.Behavior_Case_Worker__r.Name
                from Treatment_Plan__c 
                WHERE IsActive__c = true];
        
        List<Treatment_Plan__c> objList = new List<Treatment_Plan__c>();
        for(Treatment_Plan__c obj : objs){
            if((obj.Animal__r != null && String.isNotBlank(obj.Animal__r.Current_Location__c)) && 
               (obj.Animal__r.Current_Location__c.equalsIgnoreCase('CRC - CRC') ||obj.Animal__r.Current_Location__c.equalsIgnoreCase('CRC-MRC') || 
               obj.Animal__r.Current_Location__c.equalsIgnoreCase('CRC- MRC') || obj.Animal__r.Current_Location__c.equalsIgnoreCase('CRC'))){
                objList.add(obj);
            }
        }
        
        for(Treatment_Plan__c plan : objList){
            animalIds.add(plan.Animal__c);
        }
        
        List<Play_Pause__c> playPauses = [Select Animal__c, Play_Pause_Reason__c from Play_Pause__c where Animal__c in : animalIds AND End_Play_Pause__c != true]; 
		Map<Id, Set<String>> playPauseReasonByAnimal = new Map<Id, Set<String>>();
        for(Play_Pause__c pp : playPauses){
            if(!playPauseReasonByAnimal.containsKey(pp.Animal__c)){
                playPauseReasonByAnimal.put(pp.Animal__c, new Set<String>{pp.Play_Pause_Reason__c}); 
            } else {
                playPauseReasonByAnimal.get(pp.Animal__c).add(pp.Play_Pause_Reason__c); 
            }
        }
        CRCDogListResult result = new CRCDogListResult();
        result.plans = objList;
        system.debug(playPauseReasonByAnimal);
        result.playPauseReasons = convertToMapList(playPauseReasonByAnimal);
        return result;
    }
    
    @AuraEnabled
    public static String saveRecords(String recsString) {
        System.debug(recsString);
        List<Treatment_Plan__c> treatmentPlanList = (List<Treatment_Plan__c>) JSON.deserialize(recsString, List<Treatment_Plan__c>.class);
        List<Animal__c> animalList = new List<Animal__c>();
        for(Treatment_Plan__c plan: treatmentPlanList){
            animalList.add(plan.Animal__r);
        }
        
        update treatmentPlanList;
        update animalList;
        return 'success';
    }
    
    public class CRCDogListResult {
        @AuraEnabled
        public List<Treatment_Plan__c> plans;
        @AuraEnabled
        public Map<Id, List<String>> playPauseReasons;
        
    }
    
    static Map<Id, List<String>> convertToMapList(Map<Id, Set<String>> source) {
        Map<Id, List<String>> result = new Map<Id, List<String>>();
        for(Id key: source.keySet()) {
            result.put(key, new List<String>(source.get(key)));
        }
        return result;
    }
}