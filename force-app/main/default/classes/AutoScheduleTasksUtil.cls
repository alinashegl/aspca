public class AutoScheduleTasksUtil {
    public static final String BEH_TREATMENT_TASK_RECORD_TYPE_NAME = 'Behavior_TX';
    public static final String PLAYGROUP_TASK_RECORD_TYPE_NAME = 'Playgroup';
    public static final String FOSTER_TASK_RECORD_TYPE_NAME = 'Foster_Follow_Up';
    public static final String BEHAVIOR_MED_CHECK_TASK_RECORD_TYPE_NAME = 'Behavior_Medication_Check';
    public static final String BOARD_AND_TRAIN_RECORD_TYPE_NAME = 'Board_And_Train';
    public static final String TREATMENT_TASK_RECORD_TYPE_NAME = 'Treatments';
    public static final String EVALUATION_RECORD_TYPE_NAME = 'Evaluation';
    public static final String MRC_BRC_FOLLOW_UP_TASK_RECORD_TYPE_NAME = 'MRC_BRC_Follow_UP';
    public static final String NO_CONTACT_RESOURCE = 'unassigned';
    public static final String[] dogPopulations = new String[]{'ARC','CARE','CRC','MRC'};
    public static final String[] taskRecordTypes = new String[]{
        BEH_TREATMENT_TASK_RECORD_TYPE_NAME, 
        PLAYGROUP_TASK_RECORD_TYPE_NAME, 
        FOSTER_TASK_RECORD_TYPE_NAME,
        BEHAVIOR_MED_CHECK_TASK_RECORD_TYPE_NAME,
        BOARD_AND_TRAIN_RECORD_TYPE_NAME,
        EVALUATION_RECORD_TYPE_NAME,
        MRC_BRC_FOLLOW_UP_TASK_RECORD_TYPE_NAME
    };

    public static Map<String, Contact> genericContactMap {
        get{
            if(genericContactMap == null){
                genericContactMap = getGenericContacts();
            }
            return genericContactMap;
        } 
        set;
    }

    public static DateRangeWrapper dateRanges {
        get{
            if(dateRanges == null){
                dateRanges = determineDateRange();
            }
            return dateRanges;
        }
        set;
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
            SELECT Id, Name, User__c, User_Location__c
            FROM Contact
            WHERE Is_Generic_Contact__c = TRUE
            AND Active__c = true
            AND User__r.isActive = true
        ]){
            if(con.User_Location__c == 'ARC/CARE'){
                contactMap.put('ARC', con);
                contactMap.put('CARE', con);    
            } else {
                contactMap.put(con.User_Location__c, con);
            }
        }
        return contactMap;
    }

    private static Map<String, Date> dayOfWeekFields(){
        date startDate = dateRanges.startDate;
        return new Map<String, Date>{
            'Tuesday__c' => startDate,
            'Wednesday__c' => startDate.addDays(1),
            'Thursday__c' => startDate.addDays(2),
            'Friday__c' => startDate.addDays(3),
            'Saturday__c' => startDate.addDays(4),
            'Sunday__c' => startDate.addDays(5),
            'Monday__c' => startDate.addDays(6)
        };
    }

    public static Map<String, Date> dayOfWeekMap(){
        date startDate = dateRanges.startDate;
        return new Map<String, Date>{
            'Tuesday' => startDate,
            'Wednesday' => startDate.addDays(1),
            'Thursday' => startDate.addDays(2),
            'Friday' => startDate.addDays(3),
            'Saturday' => startDate.addDays(4),
            'Sunday' => startDate.addDays(5),
            'Monday' => startDate.addDays(6)
        };
    }

    public static DateRangeWrapper determineDateRange(){
        DateRangeWrapper dateRanges = new DateRangeWrapper();
        Date today = date.today();
        Date tempWeekStart = today.toStartOfWeek();

        Date startDate = tempWeekStart.addDays(9);
        Date endDate = tempWeekStart.addDays(15);
        DateTime startDT = DateTime.newInstance(startDate.year(), startDate.month(), startDate.day(), 11, 59, 59);
        DateTime endDT = DateTime.newInstance(endDate.year(), endDate.month(), endDate.day(), 11, 59, 59);

        dateRanges.startDate = startDate;
        dateRanges.endDate = endDate;
        dateRanges.startDateFormatted = startDate.format();
        dateRanges.endDateFormatted = endDate.format();
        
        dateRanges.startDateDay = startDT.format('EEEE');
        dateRanges.endDateDay = endDT.format('EEEE');

        return dateRanges;
    }

    public class DateRangeWrapper{
        @AuraEnabled public Date startDate;
        @AuraEnabled public Date endDate;
        @AuraEnabled public String startDateFormatted;
        @AuraEnabled public String endDateFormatted;
        @AuraEnabled public String startDateDay;
        @AuraEnabled public String endDateDay;
    }

    public static String determineResources(Animal__c animal){
        String[] resourceList = new String[0];
        if(animal.Animal_Name_Id__c != null){
            resourceList.add(animal.Animal_Name_Id__c);
        }
        //Dayback doesn't work well with '/' in a resource name, so we have to remove it
        resourceList.add(animal.Behavior_Case_Worker__r != null ? animal.Behavior_Case_Worker__r.Name.replace('/',' ') : NO_CONTACT_RESOURCE);
        return string.join(resourceList, ';');
    }
}