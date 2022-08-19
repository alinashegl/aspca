public with sharing class ScheduleAnimalMedCheck {
    public static Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.BEHAVIOR_MED_CHECK_TASK_RECORD_TYPE_NAME);

    //main method,called by AutoScheduleController class
    public static Task[] scheduleMedCheck(Id[] animalIds){
        Task[] medCheckTasks = new Task[0];

        //query the tasks that meet the criteria and loops through them preparing the follow up tasks for each one
        for(Task treatmentTask : getTreatmentTasks(animalIds)){
            if(treatmentTask.Animal__c != null){

                //based on original task, determine if/when new follow up tasks are needed
                Date[] followUpDates = calculateTaskDates(treatmentTask);
                if(!followUpDates.isEmpty()){
                    medCheckTasks.addAll(
                        prepTask(treatmentTask, followUpDates)
                    );
                }
            }
        }
        return medCheckTasks;
    }

    /*
    * Based on the original task, startDate and endDate determine if any follow up tasks are needed during
    * the specified timeframe
    */
    @testVisible
    private static Date[] calculateTaskDates(Task task){
        //Need to know the date of the last day of the week (ASPCA week ends on Mondays)
        Date lastDayOfWeek = AutoScheduleTasksUtil.dayOfWeekMap().get('Monday');
        
        //Need the start date of recurring tasks, or the due date of a single task
        Date tempDate = task.IsRecurrence == True ? task.RecurrenceStartDateOnly : task.ActivityDate;

        //tempDate is day 0, we need the follow ups to be on a weekly basis from day 1
        //get the day of the week that falls after the tempDate
        String dayOfWeek = AutoScheduleTasksUtil.getDayOfWeek(tempDate.addDays(1));

        //next we need to get the dates of the dayOfWeek that fall between the startDate and endDate
        //get week start from startDate
        Date startDateWeekStart = AutoScheduleTasksUtil.startOfASPCAWeek(AutoScheduleTasksUtil.startDate);
        //get week start from endDate
        Date endDateWeekStart = AutoScheduleTasksUtil.startOfASPCAWeek(AutoScheduleTasksUtil.endDate);
        //get the date of the dayOfWeek for the startDateWeekStart and endDateWeekStart
        Integer dayOfWeekNumber = dayOfWeekToInteger(dayOfWeek);

        /*
        * The startDate and endDate can potentially span 2 weeks
        * the startWeekFollowUpDate is the date of follow up during the first week
        * the endWeekFollowUpDate is the date of follow up during the second week
        */
        Date startWeekFollowUpDate = startDateWeekStart.addDays(dayOfWeekNumber);
        Date endWeekFollowUpDate = endDateWeekStart.addDays(dayOfWeekNumber);
        
        Date[] followUpDates = new Date[0];

        //makee sure the follow up dates fall between the startDate and endDate and that they are not the same
        if(
            startWeekFollowUpDate >= AutoScheduleTasksUtil.startDate && 
            startWeekFollowUpDate <= AutoScheduleTasksUtil.endDate
        ){
            followUpDates.add(startWeekFollowUpDate);
        }
        
        if(
            startWeekFollowUpDate != endWeekFollowUpDate && 
            endWeekFollowUpDate >= AutoScheduleTasksUtil.startDate && 
            endWeekFollowUpDate <= AutoScheduleTasksUtil.endDate
        ){
            followUpDates.add(endWeekFollowUpDate);
        }
        
        return followUpDates;
    }

    /*
    * determines the dates that need tasks based on the animal, original task and the Calendar_Schedule_Config__mdt record
    * loops through the dates and returns a list of tasks
    */
    @testVisible
    private static Task[] prepTask(Task treatmentTask, Date[] taskDates){
        Task[] treatmentTasks = new Task[0];
        //only create followup tasks if there was an original treatment task and the taskDates are not null
        if(treatmentTask != null && !taskDates.isEmpty()){
            //get the genericCon for the animal's location
            Contact genericCon = AutoScheduleTasksUtil.genericContactMap.get(treatmentTask.Animal__r.Current_Recent_Shelter_Location__c);

            //loop through the dates and prep the tasks, adding them to the list of treatmentTasks to return
            for(Date d : taskDates){
                Task newTask = new Task(
                    WhatId = treatmentTask.Animal_Exam_Sheet_Lookup__c,
                    Animal__c = treatmentTask.Animal__c,
                    RecordTypeId = recordTypeId,
                    ActivityDate = d,
                    Description = AutoScheduleTasksUtil.BMED_DESCRIPTION + treatmentTask.Animal__r.Animal_Name_Id__c + ' (' + treatmentTask.Animal__r.Current_Recent_Shelter_Location__c + ')',
                    IsReminderSet = false,
                    Status = 'Not Started',
                    WhoId = treatmentTask.Animal__r.Behavior_Case_Worker__c != null ? treatmentTask.Animal__r.Behavior_Case_Worker__c : genericCon.Id,
                    OwnerId = genericCon.User__c,
                    Subject = 'Behavior Medication Check',
                    Species__c = 'Dog',
                    Medication__c = treatmentTask.Medication__c,
                    Auto_Scheduled_Task__c = true
                );
                treatmentTasks.add(newTask);
            }
        }
        return treatmentTasks;
    }

    @testVisible
    public static Task[] getTreatmentTasks(Id[] animalIds){
        String[] dogPopulations = AutoScheduleTasksUtil.dogPopulations;
        Date tempEndDate = Date.today().addDays(-7);
        String queryString = 'SELECT Id, IsRecurrence, CreatedDate, ActivityDate, RecurrenceStartDateOnly, RecurrenceEndDateOnly, RecurrenceActivityId, ' +
            'WhatId, WhoId, OwnerId, Animal__c, Animal__r.Animal_Name_Id__c, Animal__r.Current_Recent_Shelter_Location__c, ' +
            'Animal__r.Behavior_Case_Worker__c, Animal__r.Behavior_Case_Worker__r.Name, Animal__r.Behavior_Case_Worker__r.Is_Generic_Contact__c, ' +
            'Animal_Exam_Sheet_Lookup__c, Medication__c ' +
            'FROM Task WHERE RecordType.Name = \'Treatments\' ' +
            'AND Animal__r.Type_of_Animal__c = \'Dog\' ' +
            'AND Animal__r.Current_Recent_Shelter_Location__c IN: dogPopulations ' +
            'AND Medication__r.Behavior_Medication__c = true ' +
            'AND ((IsRecurrence = true AND RecurrenceEndDateOnly >= : tempEndDate) ' +
            'OR (RecurrenceActivityId = null AND ActivityDate >= : tempEndDate))';

        if(animalIds != null){
            queryString += ' AND Animal__c IN: animalIds';
        }

        return Database.query(queryString);
    }

    @testVisible
    private static Integer dayOfWeekToInteger(String day){
        Integer dayNum = 0;
        switch on day {	
            when 'Wednesday' {
                dayNum = 1;
            }
            when 'Thursday' {
                dayNum = 2;
            }
            when 'Friday' {
                dayNum = 3;
            }
            when 'Saturday' {
                dayNum = 4;
            }
            when 'Sunday' {
                dayNum = 5;
            }
            when 'Monday' {
                dayNum = 6;
            }
        }
        return dayNum;
    }
}