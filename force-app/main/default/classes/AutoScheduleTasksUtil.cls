public with sharing class AutoScheduleTasksUtil {
    public static final String TREATMENT_TASK_RECORD_TYPE_NAME = 'Behavior_TX';
    public static final String PLAYGROUP_TASK_RECORD_TYPE_NAME = 'Playgroup';
    public static final String FOSTER_TASK_RECORD_TYPE_NAME = 'Foster_Follow_Up';
    public static final String NO_RESOURCE_DEFAULT = 'No Contact';
    public static Map<String, Contact> genericContactMap {
        get{
            if(genericContactMap == null){
                genericContactMap = getGenericContacts();
            }
            return genericContactMap;
        } 
        set{
            genericContactMap = getGenericContacts();
        }
    }

    public static Map<String, Calendar_Schedule_Config__mdt> getCalendarConfig(String taskType){
        Map<String, Calendar_Schedule_Config__mdt> configMap = new Map<String, Calendar_Schedule_Config__mdt>();
        for(Calendar_Schedule_Config__mdt config : [
            SELECT Frequency__c, Population__c, Monday__c, Tuesday__c, Wednesday__c, Thursday__c, Friday__c, Saturday__c, Sunday__c
            FROM Calendar_Schedule_Config__mdt 
            WHERE Task_Type__c =: taskType 
            AND IsActive__c = true
        ]){
            configMap.put(config.Population__c + '-' + config.Frequency__c, config);
        }

        return configMap;
    }

    public static Map<String, Date> getDateMap(Calendar_Schedule_Config__mdt config){
        Map<String, Date> dateMap = new Map<String, Date>();
        Date myDate = Date.today();
        Date weekStart = myDate.toStartofWeek().addDays(2);
        System.debug('weekStart = ' + weekStart);
        Map<String, Integer> dayOfWeekMap = dayOfWeekFields();
        for(String day : dayOfWeekMap.keySet()){
            if(config.get(day) == true){
                System.Debug('has Day: ' + day);
                System.Debug('date: ' + dayOfWeekMap.get(day));
                //exclude dates in the past
                if(weekStart.addDays(dayOfWeekMap.get(day)) >= date.today()){
                    dateMap.put(day, weekStart.addDays(dayOfWeekMap.get(day)));
                }
            }
        }
        return dateMap;
    }

    public static Map<String, Date> getDateMap(String customSchedule){
        Map<String, Date> dateMap = new Map<String, Date>();
        Date myDate = Date.today();
        Date weekStart = myDate.toStartofWeek().addDays(2);
        Map<String, Integer> dayOfWeekMap = dayOfWeekMap();
        for(String day : customSchedule.split(';')){
            //exclude dates in the past
            if(weekStart.addDays(dayOfWeekMap.get(day)) >= date.today()){
                dateMap.put(day, weekStart.addDays(dayOfWeekMap.get(day)));
            }
        }
        return dateMap;
    }

    public static Map<String, Contact> getGenericContacts(){
        Map<String, Contact> contactMap = new Map<String, Contact>();
        for(Contact con : [
            SELECT Id, Name, User__c, User__r.Division
            FROM Contact
            WHERE Is_Generic_Contact__c = TRUE
            AND User__r.isActive = true
        ]){
            contactMap.put(con.User__r.Division, con);
        }

        return contactMap;
    }

    private static Map<String, Integer> dayOfWeekFields(){
        return new Map<String, Integer>{
            'Tuesday__c' => 0,
            'Wednesday__c' => 1,
            'Thursday__c' => 2,
            'Friday__c' => 3,
            'Saturday__c' => 4,
            'Sunday__c' => 5,
            'Monday__c' => 6
        };
    }

    private static Map<String, Integer> dayOfWeekMap(){
        return new Map<String, Integer>{            
            'Tuesday' => 0,
            'Wednesday' => 1,
            'Thursday' => 2,
            'Friday' => 3,
            'Saturday' => 4,
            'Sunday' => 5,
            'Monday' => 6
        };
    }    
}
