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
    public static Date startDate;
    public static Date endDate;

    public static Map<String, Contact> genericContactMap {
        get{
            if(genericContactMap == null){
                genericContactMap = getGenericContacts();
            }
            return genericContactMap;
        } 
        set;
    }

    public static Map<String, DateRangeWrapper> dateRanges {
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

    public static Date[] getDateList(String customSchedule){
        Date[] datesForTasks = new Date[0];
        String[] dayList = customSchedule.split(';');
        Integer numOfDays = startDate.daysBetween(endDate) + 1;
        for(integer i = 0; i < numOfDays; i++){
            Date currentDate = startDate.addDays(i);
            String dayOfWeek = getDayOfWeek(currentDate);
            if(dayList.contains(dayOfWeek)){
                datesForTasks.add(currentDate);
            }
        }

        return datesForTasks;
    }

    public static Date[] getDateList(Calendar_Schedule_Config__mdt config){
        Date[] datesForTasks = new Date[0];
        String[] dayList = getDayListFromConfig(config);
        Integer numOfDays = startDate.daysBetween(endDate) + 1;
        for(integer i = 0; i < numOfDays; i++){
            Date currentDate = startDate.addDays(i);
            String dayOfWeek = getDayOfWeek(currentDate);
            if(dayList.contains(dayOfWeek)){
                datesForTasks.add(currentDate);
            }
        }

        return datesForTasks;
    }

    public static String[] getDayListFromConfig(Calendar_Schedule_Config__mdt config){
        String[] selectedDays = new String[0];
        String[] daysOfWeek = new String[]{'Sunday__c','Monday__c','Tuesday__c','Wednesday__c','Thursday__c','Friday__c','Saturday__c'};
        for(String day : daysOfWeek){
            if(config.get(day) == true){
                selectedDays.add(day.remove('__c'));
            }
        }

        System.debug('selectedDays: ' + selectedDays);
        return selectedDays;
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
        date startDate = dateRanges.get('nextWeek').startDate;
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
        date startDate = dateRanges.get('nextWeek').startDate;
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

    public static Map<String, DateRangeWrapper> determineDateRange(){
        Map<String, DateRangeWrapper> dateRanges = new Map<String, DateRangeWrapper>();

        Date today = date.today();
        Date tempWeekStart = today.toStartOfWeek();
        Boolean isMonday = getDayOfWeek(today) == 'Monday';
        Date startDate;
        Date endDate;

        //current week dates
        startDate = today;
        endDate = tempWeekStart.addDays(isMonday == true ? 1 : 8);

        DateRangeWrapper thisWeek = new DateRangeWrapper();
        thisWeek.startDate = today;
        thisWeek.endDate = endDate;
        thisWeek.startDateFormatted = startDate.format();
        thisWeek.endDateFormatted = endDate.format();
        thisWeek.startDay = getDayOfWeek(startDate);
        thisWeek.endDay = getDayOfWeek(endDate);
        thisWeek.isMonday = isMonday;
        dateRanges.put('thisWeek', thisWeek);


        //next week dates
        startDate = tempWeekStart.addDays(isMonday == true ? 2 : 9);
        endDate = tempWeekStart.addDays(isMonday == true ? 8 : 15);

        DateRangeWrapper nextWeek = new DateRangeWrapper();
        nextWeek.startDate = startDate;
        nextWeek.endDate = endDate;
        nextWeek.startDateFormatted = startDate.format();
        nextWeek.endDateFormatted = endDate.format();
        nextWeek.startDay = getDayOfWeek(startDate);
        nextWeek.endDay = getDayOfWeek(endDate);
        dateRanges.put('nextWeek', nextWeek);

        return dateRanges;
    }

    public static String getDayOfWeek(Date d){
        DateTime dt = DateTime.newInstance(d.year(), d.month(), d.day(), 11, 59, 59);
        return dt.format('EEEE');
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

    public static Date startOfASPCAWeek(Date d){
        String dayOfWeek = getDayOfWeek(d);
        if(dayOfWeek == 'Sunday' || dayOfWeek == 'Monday'){
            d = d.addDays(-2);
        }
        return d.toStartOfWeek().addDays(2);
    }

    public static Integer translateFrequency(String frequency){
        Integer minDays = 0;
        switch on frequency {
            when 'Every Other Week' {
                minDays = 13;
            }	
            when 'Every Three Weeks' {
                minDays = 20;
            }
            when 'Monthly' {
                minDays = 27;
            }
            when 'Every Other Month' {
                minDays = 55;
            }
        }
        return minDays;
    }

    public class DateRangeWrapper{
        @AuraEnabled public Date startDate;
        @AuraEnabled public Date endDate;
        @AuraEnabled public String startDateFormatted;
        @AuraEnabled public String endDateFormatted;
        @AuraEnabled public String startDay;
        @AuraEnabled public String endDay;
        @AuraEnabled public Boolean isMonday;
    }
}