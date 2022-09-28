public class CRCAnimalDogListController {
	@AuraEnabled
    public static List<Treatment_Plan__c> getRecords() {
        List<Treatment_Plan__c> objs = [SELECT Animal__c, Treatment_Priority__c, Enrichment_Priority__c, 
                Animal__r.Shelter_Color_Coding__c, Animal__r.Behavior_Summary_Change_Date__c,
                Animal__r.Name, Animal__r.Animal_Name__c, Animal__r.Animal_Name_Id__c,
                Animal__r.Meets_Adoptability_Date__c, Animal__r.Playgroup_Priority_Level__c, Animal__r.Current_Location__c,
                Animal__r.Behavior_Case_Worker__c, Animal__r.Behavior_Case_Worker__r.Name from Treatment_Plan__c 
                WHERE IsActive__c = true
                AND Animal__c IN (Select Animal__c from Play_Pause__c where End_Play_Pause__c != true) ];
        
        List<Treatment_Plan__c> objList = new List<Treatment_Plan__c>();
        for(Treatment_Plan__c obj : objs){
            if((obj.Animal__r != null && String.isNotBlank(obj.Animal__r.Current_Location__c)) && 
               (obj.Animal__r.Current_Location__c.equalsIgnoreCase('CRC - CRC') ||obj.Animal__r.Current_Location__c.equalsIgnoreCase('CRC-MRC') || 
               obj.Animal__r.Current_Location__c.equalsIgnoreCase('CRC- MRC') || obj.Animal__r.Current_Location__c.equalsIgnoreCase('CRC'))){
                objList.add(obj);
            }
        }
        return objList;
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
}