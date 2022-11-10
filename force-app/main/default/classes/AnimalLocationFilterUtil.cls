public with sharing class AnimalLocationFilterUtil {
    public String[] locationList;
    public Boolean useFilter;

    public AnimalLocationFilterUtil() {

    }

    public AnimalLocationFilterUtil(String locationsFilter){
        System.debug('util locationsFilter: ' + locationsFilter);
        if(locationsFilter != null){
            Map<String, Object> locationsFilterMap = (Map<String, Object>) JSON.deserializeUntyped(locationsFilter);
            String locationsString = (String) locationsFilterMap.get('locations');
            this.locationList = String.isNotBlank(locationsString) ? locationsString.split(',') : null;
            this.useFilter = 
                (Boolean) locationsFilterMap.get('hasConfigWithLocations') &&
                this.locationList != null && 
                !this.locationList.isEmpty();
        }
    }

    public AnimalLocationFilterUtil(Map<String, Object> locationsFilterMap){
        String locationsString = (String) locationsFilterMap.get('locations');
        this.locationList = locationsString != null ? locationsString.split(',') : null;
        this.useFilter = 
            (Boolean) locationsFilterMap.get('hasConfigWithLocations') &&
            this.locationList != null && 
            !this.locationList.isEmpty();
    }
}