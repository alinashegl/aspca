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
        return getLocationGroup(userLocation);
    }

    public static String[] getLocationGroup(String location){
        String[] tempLocationGroup = new String[]{'CRC', 'MRC', 'CRC/MRC'};
            String tempLocation = location;
            if(tempLocation == 'All'){
                tempLocationGroup = new String[]{'ARC', 'CARE', 'ARC/CARE', 'CRC', 'MRC', 'CRC/MRC'};
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

    public static String getAnimalRestDays(Id animalId){
        Map<Id, String> restDaysMap = getAnimalRestDays(new Id[]{animalId});
        return restDaysMap.get(animalId);
    }
    
    public static Map<Id, String> getAnimalRestDays (Id[] animalIds){
        Map<Id, String> restDaysMap = new Map<Id, String>();

        Date startDate = AutoScheduleTasksUtil.startOfASPCAWeek(date.today());
        Date endDate = startDate.addDays(7);

        Map<Id, Date[]> animalToTaskDatesMap = getTaskDates(animalIds, startDate, endDate);

        for(Id animalId : animalIds){
            String restDays = null;
            Set<String> restDaysSet = new Set<String>();
            if(!animalToTaskDatesMap.containsKey(animalId) || animalToTaskDatesMap.get(animalId).isEmpty()){
                restDaysMap.put(animalId, 'No treatments assigned this week');
            } else {
                Date[] treatmentDays = animalToTaskDatesMap.get(animalId);
                while(startDate < endDate){
                    if(!treatmentDays.contains(startDate)){
                        restDaysSet.add(AutoScheduleTasksUtil.getDayOfWeek(startDate));
                    }   
                    startDate = startDate.addDays(1);
                }
    
                if(!restDaysSet.isEmpty()){
                    restDays = String.join(new List<String>(restDaysSet), ', ');
                } else {
                    restDays = 'No rest days this week';
                }
                restDaysMap.put(animalId, restDays);
            }
            
        }

        return restDaysMap;
    }

    private static Map<Id, Date[]> getTaskDates(Id[] animalIds, Date startDate, Date endDate){
        Map<Id, Date[]> animalsToDateMap = new Map<Id, Date[]>();
        Id rtId = Util.getRecordTypeId('Task', AutoScheduleTasksUtil.BEH_TREATMENT_TASK_RECORD_TYPE_NAME);

        for(Task t : [SELECT Id, ActivityDate, Animal__c FROM Task WHERE Animal__c IN: animalIds AND RecordTypeId =: rtId AND ActivityDate >=: startDate AND ActivityDate <: endDate]){
            if(animalsToDateMap.containsKey(t.Animal__c)){
                animalsToDateMap.get(t.Animal__c).add(t.ActivityDate);
            } else {
                animalsToDateMap.put(t.Animal__c, new Date[]{t.ActivityDate});
            }
        }
        return animalsToDateMap;
    }
}