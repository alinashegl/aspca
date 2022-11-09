public with sharing class AnimalLocationFilterUtil {
    public String[] locationList;
    public Boolean useFilter;

    public AnimalLocationFilterUtil() {}

    public AnimalLocationFilterUtil(String locationsFilter){
        System.debug('util locationsFilter: ' + locationsFilter);
        if(locationsFilter != null && String.isNotEmpty(locationsFilter)){
            Map<String, Object> locationsFilterMap = (Map<String, Object>) JSON.deserializeUntyped(locationsFilter);
            this.handleMapFilter(locationsFilterMap);
        }
    }

    public AnimalLocationFilterUtil(Map<String, Object> locationsFilterMap){
        this.handleMapFilter(locationsFilterMap);
    }

    private void handleMapFilter(Map<String, Object> locationsFilterMap){
        if(locationsFilterMap.isEmpty()) return;
        String locationsString = (String) locationsFilterMap.get('locations');
        this.locationList = locationsString != null ? locationsString.split(',') : null;
        this.useFilter = 
            (Boolean) locationsFilterMap.get('hasConfigWithLocations') &&
            this.locationList != null && 
            !this.locationList.isEmpty();
    }    
}
