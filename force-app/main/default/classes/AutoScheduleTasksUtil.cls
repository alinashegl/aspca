public with sharing class AutoScheduleTasksUtil {
    public static final String BEH_TREATMENT_TASK_RECORD_TYPE_NAME = 'Behavior_TX';
    public static final String PLAYGROUP_TASK_RECORD_TYPE_NAME = 'Playgroup';
    public static final String FOSTER_TASK_RECORD_TYPE_NAME = 'Foster_Follow_Up';
    public static final String BEHAVIOR_MED_CHECK_TASK_RECORD_TYPE_NAME = 'Behavior_Medication_Check';
    public static final String BOARD_AND_TRAIN_RECORD_TYPE_NAME = 'Board_And_Train';
    public static final String TREATMENT_TASK_RECORD_TYPE_NAME = 'Treatments';
    public static final String EVALUATION_RECORD_TYPE_NAME = 'Evaluation';
    public static final String NO_CONTACT_RESOURCE = 'unassigned';
    public static final String[] dogPopulations = new String[]{'ARC','CARE','CRC','MRC'};
    public static final String[] taskRecordTypes = new String[]{
        BEH_TREATMENT_TASK_RECORD_TYPE_NAME, 
        PLAYGROUP_TASK_RECORD_TYPE_NAME, 
        FOSTER_TASK_RECORD_TYPE_NAME,
        BEHAVIOR_MED_CHECK_TASK_RECORD_TYPE_NAME,
        BOARD_AND_TRAIN_RECORD_TYPE_NAME,
        EVALUATION_RECORD_TYPE_NAME
    };


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
        Map<String, Date> dayOfWeekMap = dayOfWeekFields();
        for(String day : dayOfWeekMap.keySet()){
            if(config.get(day) == true){
                System.Debug('has Day: ' + day);
                System.Debug('date: ' + dayOfWeekMap.get(day));
                //exclude dates in the past
                if(dayOfWeekMap.get(day) >= date.today()){
                    dateMap.put(day, dayOfWeekMap.get(day));
                }
            }
        }
        return dateMap;
    }

    public static Map<String, Date> getDateMap(String customSchedule){
        Map<String, Date> dateMap = new Map<String, Date>();
        Date myDate = Date.today();
        Map<String, Date> dayOfWeekMap = dayOfWeekMap();
        for(String day : customSchedule.split(';')){
            //exclude dates in the past
            if(dayOfWeekMap.get(day) >= date.today()){
                dateMap.put(day, dayOfWeekMap.get(day));
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
            if(con.User__r.Division == 'ARC/CARE'){
                contactMap.put('ARC', con);
                contactMap.put('CARE', con);    
            } else {
                contactMap.put(con.User__r.Division, con);
            }
        }

        return contactMap;
    }

    private static Map<String, Date> dayOfWeekFields(){
        date currentDate = date.today();
        date weekStart = currentDate.toStartofWeek();
        return new Map<String, Date>{
            'Tuesday__c' => weekStart.addDays(2),
            'Wednesday__c' => weekStart.addDays(3),
            'Thursday__c' => weekStart.addDays(4),
            'Friday__c' => weekStart.addDays(5),
            'Saturday__c' => weekStart.addDays(6),
            'Sunday__c' => weekStart.addDays(7),
            'Monday__c' => weekStart.addDays(8)
        };
    }

    public static Map<String, Date> dayOfWeekMap(){
        date currentDate = date.today();
        date weekStart = currentDate.toStartofWeek();
        return new Map<String, Date>{
            'Tuesday' => weekStart.addDays(2),
            'Wednesday' => weekStart.addDays(3),
            'Thursday' => weekStart.addDays(4),
            'Friday' => weekStart.addDays(5),
            'Saturday' => weekStart.addDays(6),
            'Sunday' => weekStart.addDays(7),
            'Monday' => weekStart.addDays(8)
        };
    }

    public static String determineResources(Animal__c animal){
        String[] resourceList = new String[0];
        if(animal.Animal_Name_Id__c != null){
            resourceList.add(animal.Animal_Name_Id__c);
        }
        resourceList.add(animal.Behavior_Case_Worker__r.Is_Generic_Contact__c == false ? animal.Behavior_Case_Worker__r.Name : AutoScheduleTasksUtil.NO_CONTACT_RESOURCE);
        return string.join(resourceList, ';');
    }
}