public class PlaygroupToDoPdfController {
    private List<Animal__c> animals;

    public PlaygroupToDoPdfController() {
      	  String[] locationsToExclude = new String[]{
            'Board and Train',
                'Boarding',
                'Field Temp Shelter',
                'Foster Home',
                'Partner Hospital',
                'Response Partner'
                };
        animals = [SELECT Id, Name, Animal_Name__c, Shelter_Color_Coding__c, Playgroup_Priority_Level__c, Play_Category__c, Play_Style_Notes__c,
                    Gender__c, Shelter_Location__c, Number_of_Playgroups__c, Does_Not_Walk_on_a_Leash__c, Does_Not_Walk_on_a_Leash_Notes__c,
                    (SELECT Id FROM Medical_Conditions__r WHERE Medical_Condition__c = 'Babesia' AND Date_Diagnosed__c <= TODAY AND (Date_Resolved__c = null OR Date_Resolved__c > TODAY)),
                    (SELECT Id FROM Play_Pauses__r WHERE Type__c = 'Medical' AND Play_Pause_Reason__c = 'In Heat' AND Start_Date__c <= TODAY AND (End_Date__c = null OR End_Date__c > TODAY))
                FROM Animal__c
                WHERE Active_Animal__c = true 
                    AND Current_Location__c NOT IN :locationsToExclude 
                    AND Type_of_Animal__c = 'Dog'
                    AND Play_Category__c NOT IN ('Unevaluated', 'DO NOT PLAY', '')
                    AND Id NOT IN (SELECT Animal__c FROM Play_Pause__c WHERE Type__c = 'Behavioral' AND Start_Date__c <= TODAY AND (End_Date__c = null OR End_Date__c >= TODAY))
                    AND Location_Filter__c = true
                ORDER BY Id];
    }

    public List<Animal__c> getAnimals() {
        return animals;
    }
}