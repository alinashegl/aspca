public class PlaygroupToDoPdfController {
    private List<Animal__c> animals;

    public PlaygroupToDoPdfController() {
        String locationsFilter = ApexPages.currentPage().getparameters().get('locations');
        Boolean useFilter = Boolean.valueOf(ApexPages.currentPage().getparameters().get('useFilter'));

        animals = new PlaygroupToDoListController.QueryAnimalsForList(locationsFilter, useFilter).animalList;
    }

    public List<Animal__c> getAnimals() {
        return animals;
    }
}