public with sharing class ScheduleAnimalFoster {
    public static Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.FOSTER_TASK_RECORD_TYPE_NAME);

    //main method,called by AutoScheduleController class
    public static Task[] scheduleFollowUps(Id[] animalIds) {
        //make sure we have default start and end dates set
        Map<String, AutoScheduleTasksUtil.DateRangeWrapper> dateRanges = AutoScheduleTasksUtil.dateRanges;

        Task[] fosterTasks = new Task[0];

        //get a map of all the active foster Calendar_Schedule_Config__mdt records
        Map<String, Calendar_Schedule_Config__mdt> calendarConfigMap = AutoScheduleTasksUtil.getCalendarConfig('Foster');

        //if the map is empty or does not containthe default, no need to continue
        if(!calendarConfigMap.isEmpty() && calendarConfigMap.containsKey('Foster - All-Foster - Weekly')){ 

            //set the default config
            Calendar_Schedule_Config__mdt defaultConfig = calendarConfigMap.get('Foster - All-Foster - Weekly');

            Animal__c[] animals = getAnimals(animalIds);

            //Query for any existing foster tasks related to the animals
            Map<Id, Task> animalToTaskMap = getTasks(animals);

            //query the animals that meet the criteria and loops through them preparing the tasks for each one
            for(Animal__c animal : animals){
                //if the animal has an existing task already assign it here
                Task task = animalToTaskMap.containsKey(animal.Id) ? animalToTaskMap.get(animal.Id) : null;

                Task[] newTasks = prepTasks(animal, defaultConfig, task);
                if(newTasks != null && !newTasks.isEmpty()){
                    fosterTasks.addAll(newTasks);
                }
            }
        }
        return fosterTasks;
    }

    //queries and returns a list of animals wit the related foster Facility_Outcome__c's, will query specific animals if the animalIds param is not null
    public static Animal__c[] getAnimals(Id[] animalIds){
        String[] dogPopulations = AutoScheduleTasksUtil.dogPopulations;
        String queryString = 'SELECT Id, Animal_Name_Id__c, Current_Recent_Shelter_Location__c, Current_Location__c, ' +
            'Behavior_Case_Worker__c, Behavior_Case_Worker__r.Name, Behavior_Case_Worker__r.Is_Generic_Contact__c, ' +
                '(SELECT Id, Follow_Up_Days__c, Follow_Up_Frequency__c, CreatedDate, Start_Date__c ' +
                'FROM Facilities_Outcomes__r ' +
                'WHERE Facility_Outcome__c = \'Foster Home\' ' +
                'AND (End_Date__c = null OR End_Date__c >= TODAY) ' +
                'ORDER BY CreatedDate DESC ' +
                'LIMIT 1) ' +
            'FROM Animal__c ' +
            'WHERE Current_Location__c = \'Foster Home\' ' +
            'AND Active_Animal__c = true ' + 
            'AND Type_of_Animal__c = \'Dog\' ' +
            'AND Current_Recent_Shelter_Location__c IN: dogPopulations ' +
            'AND Id IN ' +
                '(SELECT Animal__c ' +
                'FROM Facility_Outcome__c ' +
                'WHERE Facility_Outcome__c = \'Foster Home\' ' +
                'AND (End_Date__c = null OR End_Date__c >= TODAY))';

        if(animalIds != null){
            queryString += ' AND Id IN: animalIds';
        }
                
        return Database.query(queryString);
    }

    //returns a map of animal Ids and the related foster tasks
    public static Map<Id,Task> getTasks(Animal__c[] animals){
        Map<Id,Task> taskMap = new Map<Id,Task>();
        for(Task t : [SELECT Id, ActivityDate, Animal__c FROM Task WHERE RecordTypeId =: recordTypeId AND Animal__c IN: animals ORDER BY ActivityDate DESC]){
            //if map already contains the animal Id as a key we can skip this task
            if(!taskMap.containsKey(t.Animal__c)){
                taskMap.put(t.Animal__c, t);
            }
        }
        return taskMap;
    }

    /*
    * depending on the schedule we may not need to create a task for this week.
    * We need to compare the date of the last task and frequency set up.  i.e. if we only need a task every other week then we
    * only create one for this week if the last one was at least 7 days ago (see translateFrequency()).
    */
    public static Date[] datesForTasks(Animal__c animal, Calendar_Schedule_Config__mdt config, Task task){
        /*
        * The startDate and endDate can potentially span 2 weeks
        * the startDateWeekStart is the date of the first day of week 1
        * the endDateWeekStart is the date of the first day of week 2
        */
        Date startDateWeekStart = AutoScheduleTasksUtil.startOfASPCAWeek(AutoScheduleTasksUtil.startDate);
        Date endDateWeekStart = AutoScheduleTasksUtil.startOfASPCAWeek(AutoScheduleTasksUtil.endDate);
        Facility_Outcome__c location = animal.Facilities_Outcomes__r[0];

        Date[] dateList = new Date[0];

        /*
        * Determine which dates need tasks
        * If a Calendar_Schedule_Config__mdt was passed in, use it, otherwise use the custom schedule on the location.Follow_Up_Days__c
        */
        if(location.Follow_Up_Days__c == null){
            dateList = AutoScheduleTasksUtil.getDateList(config);
        } else {
            dateList = AutoScheduleTasksUtil.getDateList(location.Follow_Up_Days__c);
        }

        Date[] datesForTasks = new Date[0];
        
        //location.Follow_Up_Frequency__c is null or is 'Weekly' we create follow ups each week so we can skip this part and go down to else
        if(location.Follow_Up_Frequency__c != null && location.Follow_Up_Frequency__c != 'Weekly'){
            //use this boolean to make sure when we get to scheduling next week we add 7 days
            Boolean createdTasksForCurrentWeek = false;

            //need the date of the first day of the ASPCA week that the original Task's activity date is in, otherwise base it on the start date of the foster record
            Date activityDateWeekStart = task != null ? AutoScheduleTasksUtil.startOfASPCAWeek(task.ActivityDate) : location.Start_Date__c;

            /*
            * if the number of days between the activityDateWeekStart and is greater than the number of days returned by the translateFrequency method
            * and for the dates in the list that fall during the first week then we know we need to create tasks for the 1st week 
            */
            if(activityDateWeekStart.daysBetween(startDateWeekStart) > AutoScheduleTasksUtil.translateFrequency(location.Follow_Up_Frequency__c)){
                for(Date d : dateList){
                    if(d > startDateWeekStart && d < startDateWeekStart.addDays(6)){
                        datesForTasks.add(d);
                        //only set this to true if we actually created tasks for the first week
                        createdTasksForCurrentWeek = true;
                    }
                }
            }

            //if we created tasks for the first week we need to make sure the second week is a week later
            if(createdTasksForCurrentWeek == true){
                activityDateWeekStart = startDateWeekStart.addDays(7);
            }

            /*
            * if the number of days between the activityDateWeekStart and is greater than the number of days returned by the translateFrequency method
            * and the first days of week for 1st and 2nd weeks are not the same (this will happen when the startDate and endDate do not span multiple weeks)
            * and for the dates in the list that fall during the first week then we know we need to create tasks for the 1st week 
            */            
            if(startDateWeekStart != endDateWeekStart && activityDateWeekStart.daysBetween(endDateWeekStart) > AutoScheduleTasksUtil.translateFrequency(location.Follow_Up_Frequency__c)){
                for(Date d : dateList){
                    if(d > endDateWeekStart && d < endDateWeekStart.addDays(6)){
                        datesForTasks.add(d);
                    }
                }
            }
        } else {
            datesForTasks = dateList;
        }
        return datesForTasks;
    }

    /*
    * determines the dates that need tasks based on the animal, original task and the Calendar_Schedule_Config__mdt record
    * loops through the dates and returns a list of tasks
    */
    public static Task[] prepTasks(Animal__c animal, Calendar_Schedule_Config__mdt config, Task task){
        //get the genericCon for the animal's location
        Id genericConId = UserInfo.getUserId();
        Contact genericCon = AutoScheduleTasksUtil.genericContactMap.get(animal.Current_Recent_Shelter_Location__c);
        if(genericCon != null){
            genericConId = genericCon.User__c;
        }
        Task[] newTasks = new Task[0];
        
        //determine which dates need tasks
        Date[] dateList = datesForTasks(animal, config, task);
        
        Facility_Outcome__c location = animal.Facilities_Outcomes__r[0];

        //loop through the dates and prep the tasks, adding them to the list of newTasks to return
        for(Date day : dateList){
            Task newTask = new Task(
                WhatId = location.Id,
                Animal__c = animal.Id,
                RecordTypeId = recordTypeId,
                ActivityDate = day,
                Description = 'Foster Follow Up for: ' + animal.Animal_Name_Id__c + ' (' + animal.Current_Recent_Shelter_Location__c + ')',
                IsReminderSet = true,
                Status = 'Not Started',
                WhoId = animal.Behavior_Case_Worker__c != null ? animal.Behavior_Case_Worker__c : (genericCon != null ? genericCon.Id : null),
                OwnerId = genericConId,
                Subject = 'Foster Follow Up',
                Species__c = 'Dog',
                Auto_Scheduled_Task__c = true
            );
            newTasks.add(newTask);
        }
        return newTasks;
    }
}