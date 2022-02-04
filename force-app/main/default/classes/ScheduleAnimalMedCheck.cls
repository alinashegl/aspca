public with sharing class ScheduleAnimalMedCheck {
    public static Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.BEHAVIOR_MED_CHECK_TASK_RECORD_TYPE_NAME);
    public static Task[] scheduleMedCheck(Id[] animalIds){
        Task[] medCheckTasks = new Task[0];
        for(Task treatmentTask : getTreatmentTasks(animalIds)){
            if(treatmentTask.Animal__c != null){
                Date[] followUpDates = calculateTaskDates(treatmentTask);
                if(!followUpDates.isEmpty()){
                    medCheckTasks.addAll(prepTask(treatmentTask, followUpDates));
                }
            }
        }
        return medCheckTasks;
    }

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

    @testVisible
    private static Task[] prepTask(Task treatmentTask, Date[] taskDates){
        Task[] treatmentTasks = new Task[0];
        if(treatmentTask != null && !taskDates.isEmpty()){
            Contact genericCon = AutoScheduleTasksUtil.genericContactMap.get(treatmentTask.Animal__r.Current_Recent_Shelter_Location__c);

            for(Date d : taskDates){
                Task newTask = new Task(
                    WhatId = treatmentTask.Animal_Exam_Sheet_Lookup__c,
                    Animal__c = treatmentTask.Animal__c,
                    RecordTypeId = recordTypeId,
                    ActivityDate = d,
                    Description = 'Bmed Check is needed for: ' + treatmentTask.Animal__r.Animal_Name_Id__c + ' (' + treatmentTask.Animal__r.Current_Recent_Shelter_Location__c + ')',
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
        Date tempEndDate = Date.today().addDays(-7);
        String queryString = 'SELECT Id, IsRecurrence, CreatedDate, ActivityDate, RecurrenceStartDateOnly, RecurrenceEndDateOnly, RecurrenceActivityId, ' +
            'WhatId, WhoId, OwnerId, Animal__c, Animal__r.Animal_Name_Id__c, Animal__r.Current_Recent_Shelter_Location__c, ' +
            'Animal__r.Behavior_Case_Worker__c, Animal__r.Behavior_Case_Worker__r.Name, Animal__r.Behavior_Case_Worker__r.Is_Generic_Contact__c, ' +
            'Animal_Exam_Sheet_Lookup__c, Medication__c ' +
            'FROM Task WHERE RecordType.Name = \'Treatments\' ' +
            'AND Animal__r.Type_of_Animal__c = \'Dog\' ' +
            'AND Medication__r.Behavior_Medication__c = true ' +
            'AND ((IsRecurrence = true AND RecurrenceEndDateOnly >= : tempEndDate) ' +
            'OR (RecurrenceActivityId = null AND ActivityDate >= : tempEndDate))';

        if(animalIds != null){
            queryString += ' AND Animal__c IN: animalIds';
        }

        return Database.query(queryString);
    }

    @testVisible
    private static integer dayOfWeekToInteger(String day){
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
