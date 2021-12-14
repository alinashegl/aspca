public class PlaygroupToDoPdfController {
    private List<Animal__c> animals;
    private String location = 'MRC';

    public PlaygroupToDoPdfController() {
        if (ApexPages.currentPage().getParameters().get('location') != null) {
            location = ApexPages.currentPage().getParameters().get('location');
        }
        animals = [SELECT Id, Name, Animal_Name__c, Shelter_Color_Coding__c, Playgroup_Priority_Level__c, Play_Category__c, Play_Style_Notes__c,
                    Gender__c, Shelter_Location__c, Number_of_Playgroups__c, Does_Not_Walk_on_a_Leash__c, Does_Not_Walk_on_a_Leash_Notes__c,
                    (SELECT Id FROM Medical_Conditions__r WHERE Medical_Condition__c = 'Babesia' AND Date_Diagnosed__c <= TODAY AND (Date_Resolved__c = null OR Date_Resolved__c > TODAY)),
                    (SELECT Id FROM Play_Pauses__r WHERE Type__c = 'Medical' AND Play_Pause_Reason__c = 'In Heat' AND Start_Date__c <= TODAY AND (End_Date__c = null OR End_Date__c > TODAY))
                FROM Animal__c
                WHERE Play_Category__c NOT IN ('Unevaluated', 'DO NOT PLAY')
                    AND Id NOT IN (SELECT Animal__c FROM Play_Pause__c WHERE Type__c = 'Behavioral' AND Start_Date__c <= TODAY AND (End_Date__c = null OR End_Date__c >= TODAY))
                    AND Current_Recent_Shelter_Location__c =: location
                ORDER BY Id];
    }

    public List<Animal__c> getAnimals() {
        return animals;
    }

    public String getLocation() {
        return location;
    }
}