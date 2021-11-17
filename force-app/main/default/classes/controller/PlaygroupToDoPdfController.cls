public class PlaygroupToDoPdfController {
    private List<Animal__c> animals;
    private String location = 'MRC';

    public PlaygroupToDoPdfController() {
        if (ApexPages.currentPage().getParameters().get('location') != null) {
            location = ApexPages.currentPage().getParameters().get('location');
        }
        animals = [SELECT Id, Name, Animal_Name__c, Handler__c, Playgroup_Priority_Level__c, Play_Category__c, Play_Style_Notes__c, Play_Pause_Reason__c
                FROM Animal__c
                WHERE Play_Category__c NOT IN ('Unevaluated', 'DO NOT PLAY')
                    AND (Behavior_Play_Pause__c = null OR Behavior_Play_Pause_Date__c <= TODAY)
                    AND Shelter_Location2__c =: location];
    }

    public List<Animal__c> getAnimals() {
        return animals;
    }

    public String getLocation() {
        return location;
    }
}