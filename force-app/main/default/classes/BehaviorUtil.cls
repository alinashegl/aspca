public with sharing class BehaviorUtil {
    public static String[] locationGroup{
        get{
            if(locationGroup == null){
                return getLocationGroup();
            }
            else {
                return locationGroup;
            }
        }
        set;
    }

    public static String userLocation{
        get {
            if(userLocation == null){
                return getUserLocation();
            }
            else {
                return userLocation;
            }
        }
    }

    public static String[] getLocationGroup(){
        String[] tempLocationGroup = new String[]{'CRC', 'MRC'};
            String tempLocation = userLocation;
            if(tempLocation == 'All'){
                tempLocationGroup = new String[]{'ARC', 'CARE', 'ARC/CARE', 'CRC', 'MRC'};
            }
            if(tempLocation == 'ARC/CARE'){
                tempLocationGroup = new String[]{'ARC', 'CARE', 'ARC/CARE'};
            }
        return tempLocationGroup;
    }

    public static String[] getLocationGroup(String location){
        String[] tempLocationGroup = new String[]{'CRC', 'MRC'};
            String tempLocation = location;
            if(tempLocation == 'All'){
                tempLocationGroup = new String[]{'ARC', 'CARE', 'ARC/CARE', 'CRC', 'MRC'};
            }
            if(tempLocation == 'ARC/CARE'){
                tempLocationGroup = new String[]{'ARC', 'CARE', 'ARC/CARE'};
            }
        return tempLocationGroup;
    }

    public static String getUserLocation(){
        User u = [SELECT Id, Location__c FROM User WHERE Id =: userInfo.getUserId()];
        return u.Location__c;
    }
}
