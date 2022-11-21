public with sharing class AnimalLocationFilterUtil {
    public String[] locationList;
    public Boolean useFilter;

    public AnimalLocationFilterUtil() {}

    public AnimalLocationFilterUtil(String locationsFilter){
        System.debug('util locationsFilter: ' + locationsFilter);
        if(locationsFilter != null && String.isNotEmpty(locationsFilter)){

            if(isValidMap(locationsFilter)){
                Map<String, Object> locationsFilterMap = (Map<String, Object>) JSON.deserializeUntyped(locationsFilter);
                this.handleMapFilter(locationsFilterMap);
            } else {
                Map<String, Object> locationsFilterMap = new Map<String, Object> {
                    'locations' => 
                    locationStringToObjectList(locationsFilter)
                };
            }            
        }
    }

    public AnimalLocationFilterUtil(Map<String, Object> locationsFilterMap){
        this.handleMapFilter(locationsFilterMap);
    }

    private void handleMapFilter(Map<String, Object> locationsFilterMap){
        if(locationsFilterMap.isEmpty()) return;
        Object obj = locationsFilterMap.get('locations');

        //need to check if obj is a string or list of strings
        if(obj instanceOf String){
            String locationsString = (String) locationsFilterMap.get('locations');
            this.locationList = locationsString != null ? locationsString.split(',') : null;
        }
        else if(obj instanceOf String[]) {
            this.locationList = (String[]) obj;
        }

        if(locationsFilterMap.get('hasConfigWithLocations') != null){
            this.useFilter = 
                    (Boolean) locationsFilterMap.get('hasConfigWithLocations') &&
                    this.locationList != null && 
                    !this.locationList.isEmpty();
        }
    }

    public Object[] locationStringToObjectList(String locations){
        Object[] locationsObjList;
        if(isValidList(locations)){
            locations = '{"locs":' + locations + '}';
            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(locations);            
            locationsObjList = (List<Object>) m.get('locs');
        } else {       
            locationsObjList = new Object[0];
            locationsObjList.add(locations);
        }
        return locationsObjList;
    }

    public Boolean isValidList(String st){
        return st.substring(0,1) == '[';
    }

    public Boolean isValidMap(String st){
        return st.substring(0,1) == '{';
    }
}