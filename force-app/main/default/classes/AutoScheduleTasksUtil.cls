public class AutoScheduleTasksUtil {
    public static final String BEH_TREATMENT_TASK_RECORD_TYPE_NAME = 'Behavior_TX';
    public static final String PLAYGROUP_TASK_RECORD_TYPE_NAME = 'Playgroup';
    public static final String FOSTER_TASK_RECORD_TYPE_NAME = 'Foster_Follow_Up';
    public static final String BEHAVIOR_MED_CHECK_TASK_RECORD_TYPE_NAME = 'Behavior_Medication_Check';
    public static final String BOARD_AND_TRAIN_RECORD_TYPE_NAME = 'Board_And_Train';
    public static final String TREATMENT_TASK_RECORD_TYPE_NAME = 'Treatments';
    public static final String EVALUATION_RECORD_TYPE_NAME = 'Evaluation';
    public static final String MRC_BRC_FOLLOW_UP_TASK_RECORD_TYPE_NAME = 'MRC_BRC_Follow_UP';
    public static final String[] taskRecordTypes = new String[]{
        BEH_TREATMENT_TASK_RECORD_TYPE_NAME, 
        PLAYGROUP_TASK_RECORD_TYPE_NAME, 
        FOSTER_TASK_RECORD_TYPE_NAME,
        BEHAVIOR_MED_CHECK_TASK_RECORD_TYPE_NAME,
        BOARD_AND_TRAIN_RECORD_TYPE_NAME,
        EVALUATION_RECORD_TYPE_NAME,
        MRC_BRC_FOLLOW_UP_TASK_RECORD_TYPE_NAME
    };
    public static final String NO_CONTACT_RESOURCE = 'unassigned';
    public static final String BMED_DESCRIPTION = 'Bmed Check is needed for: ';
    public static Date startDate;
    public static Date endDate;

    public static final String[] dogPopulations {
        get{
            if(Test.isRunningTest()){
                dogPopulations = new String[]{'ARC','CARE','CRC','MRC'};
            }
            else {
                dogPopulations = new String[]{'ARC','CARE'};
            }
            return dogPopulations;
        }
        set;
    }

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

    //create a map of the config custom meta data table for the specific task type
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

    //returns a list of dates between the start date and end dates that match the days provided in the custom schedule
    //customSchedule should be a ';' separated string (like a multi select picklist field)
    public static Date[] getDateList(String customSchedule){
        String[] dayList = customSchedule.split(';');
        return datesForTasks(dayList);
    }

    //returns a list of dates between the start date and end dates that match the days provided Calendar_Schedule_Config
    public static Date[] getDateList(Calendar_Schedule_Config__mdt config){
        String[] dayList = getDayListFromConfig(config);
        return datesForTasks(dayList);
        
    }

    /*
    * Loop through the dates between start end and date, convert them to a day of the weekk,
    * if the day of the week is in the dayList then we need a task for that date and we add
    * the date to the datesForTasks list
    */
    private static Date[] datesForTasks(String[] dayList){
        if(startDate == null || endDate == null){
            determineDateRange();
        }

        Date[] datesForTasks = new Date[0];
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

    //Converts the days selected in the config record into a list of the days of the week
    private static String[] getDayListFromConfig(Calendar_Schedule_Config__mdt config){
        String[] selectedDays = new String[0];
        String[] daysOfWeek = new String[]{'Sunday__c','Monday__c','Tuesday__c','Wednesday__c','Thursday__c','Friday__c','Saturday__c'};
        for(String day : daysOfWeek){
            if(config.get(day) == true){
                selectedDays.add(day.remove('__c'));
            }
        }
        return selectedDays;
    }

    //queries for the active generic contacts and creates a map based on their location
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
            } 
            else if(con.User_Location__c == 'CRC/MRC'){
                contactMap.put('CRC', con);
                contactMap.put('MRC', con);
            } else {
                contactMap.put(con.User_Location__c, con);
            }
        }
        return contactMap;
    }

    /*
    * The start of the nextWeek should always be a Tuesday becuae of ASPCA's weekly schedule
    * here, we return a map with the key being the day of the week
    * the value is the date that corresponds to that day of the week
    */
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

    //return a map of date ranges for the rest of this week and next week
    public static Map<String, DateRangeWrapper> determineDateRange(){
        Map<String, DateRangeWrapper> dateRangeMap = new Map<String, DateRangeWrapper>();

        Date today = date.today();

        // Date tempWeekStart = today.toStartOfWeek();
        // Boolean isMonday = 

        Date tempWeekStart = startOfASPCAWeek(today);
        Date tempStartDate;
        Date tempEndDate;

        //current week dates
        tempStartDate = today;
        tempEndDate = tempWeekStart.addDays(6);

        //create date range for this week
        DateRangeWrapper thisWeek = new DateRangeWrapper();
        thisWeek.startDate = today;
        thisWeek.endDate = tempEndDate;
        thisWeek.startDateFormatted = tempStartDate.format();
        thisWeek.endDateFormatted = tempEndDate.format();
        thisWeek.startDay = getDayOfWeek(tempStartDate);
        thisWeek.endDay = getDayOfWeek(tempEndDate);
        thisWeek.isMonday = getDayOfWeek(today) == 'Monday';
        dateRangeMap.put('thisWeek', thisWeek);


        //next week's dates
        tempStartDate = tempWeekStart.addDays(7);
        tempEndDate = tempWeekStart.addDays(13);

        DateRangeWrapper nextWeek = new DateRangeWrapper();
        nextWeek.startDate = tempStartDate;
        nextWeek.endDate = tempEndDate;
        nextWeek.startDateFormatted = tempStartDate.format();
        nextWeek.endDateFormatted = tempEndDate.format();
        nextWeek.startDay = getDayOfWeek(tempStartDate);
        nextWeek.endDay = getDayOfWeek(tempEndDate);
        dateRangeMap.put('nextWeek', nextWeek);

        //setting default dates if in case they aren't sent by the calling class
        if(startDate == null && endDate == null){
            startDate = dateRangeMap.get('nextWeek').startDate;
            endDate = dateRangeMap.get('nextWeek').endDate;
        }

        return dateRangeMap;
    }

    //Convert a date to a day of the week
    public static String getDayOfWeek(Date d){
        DateTime dt = DateTime.newInstance(d.year(), d.month(), d.day(), 11, 59, 59);
        return dt.format('EEEE');
    }

    /*
    * Events on Dayback need a resources field to assign the event to the appropriate resources
    * this method returns a ';' string of resources to be populated on the resources field for
    * the specific animal
    */
    public static String determineResources(Animal__c animal){
        String[] resourceList = new String[0];
        if(animal.Animal_Name_Id__c != null){
            resourceList.add(animal.Animal_Name_Id__c);
        }
        //Dayback doesn't work well with '/' in a resource name, so we have to remove it
        resourceList.add(animal.Behavior_Case_Worker__r != null ? animal.Behavior_Case_Worker__r.Name.replace('/',' ') : NO_CONTACT_RESOURCE);
        return string.join(resourceList, ';');
    }

    /* 
    * From the date (d) passed in, calculates what the date would be for the first day of the week that (d) is in.
    * Becuase ASPCA's week starts on Tuesday, need to add 2 days to the start of the week
    */

    public static Date startOfASPCAWeek(Date d){
        String dayOfWeek = getDayOfWeek(d);
        if(dayOfWeek == 'Sunday' || dayOfWeek == 'Monday'){
            d = d.addDays(-2);
        }
        return d.toStartOfWeek().addDays(2);
    }

    /*
    * Calculates the minimum number of days that must be between two startOfWeekDates to
    * determine if a task is needed for the week
    */
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

    /*
    * Date range wrapper, includes start and end dates, formatted start and end dates,
    * start day of the week and end day of the week and if the start date is a Monday or not
    */
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