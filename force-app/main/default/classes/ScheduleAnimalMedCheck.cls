public with sharing class ScheduleAnimalMedCheck {
    public static Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.BEHAVIOR_MED_CHECK_TASK_RECORD_TYPE_NAME);
    public static Task[] scheduleMedCheck(){
        Task[] medCheckTasks = new Task[0];
        for(Task treatmentTask : getTreatmentTasks()){
            if(treatmentTask.Animal__c != null){
                Date followUpDate = calculateTaskDate(treatmentTask);
                if(followUpDate != null){
                    medCheckTasks.add(prepTask(treatmentTask, followUpDate));
                }
            }
        }
        return medCheckTasks;
    }

    private static Date calculateTaskDate(Task task){
        Date lastDayOfWeek = AutoScheduleTasksUtil.dayOfWeekMap().get('Monday');

        Date tempDate = task.IsRecurrence == True ? task.RecurrenceStartDateOnly : task.ActivityDate;
        Date tempDateWeekStart = tempDate.toStartOfWeek();
        Integer daysBetween = tempDateWeekStart.daysBetween(Date.today());
        String dayOfWeek = checkDayofWeek(daysBetween + 1);
        Date nextFollowUpDate = AutoScheduleTasksUtil.dayOfWeekMap().get(dayOfWeek);
        return nextFollowUpDate <= lastDayOfWeek ? nextFollowUpDate : null;
    }

    private static Task prepTask(Task treatmentTask, Date taskDate){
        Contact genericCon = AutoScheduleTasksUtil.genericContactMap.get(treatmentTask.Animal__r.Current_Recent_Shelter_Location__c);
        Task newTask = new Task(
            WhatId = treatmentTask.Animal_Exam_Sheet_Lookup__c,
            Animal__c = treatmentTask.Animal__c,
            RecordTypeId = recordTypeId,
            ActivityDate = taskDate,
            Description = 'Med Check is needed for: ' + treatmentTask.Animal__r.Animal_Name_Id__c + ' (' + treatmentTask.Animal__r.Current_Recent_Shelter_Location__c + ')',
            IsReminderSet = false,
            Status = 'Not Started',
            WhoId = treatmentTask.Animal__r.Behavior_Case_Worker__c != null ? treatmentTask.Animal__r.Behavior_Case_Worker__c : genericCon.Id,
            OwnerId = genericCon.User__c,
            Subject = 'Behavior Medication Check',
            Assigned_Resources__c = determineResources(treatmentTask),
            Species__c = 'Dog',
            Medication__c = treatmentTask.Medication__c
        );

        return newTask;
    }

    private static String determineResources(Task task){
        String[] resourceList = new String[0];
        if(task.Animal__r.Animal_Name_Id__c != null){
            resourceList.add(task.Animal__r.Animal_Name_Id__c);
        }
        resourceList.add(task.Animal__r.Behavior_Case_Worker__r.Is_Generic_Contact__c == false ? task.Animal__r.Behavior_Case_Worker__r.Name : AutoScheduleTasksUtil.NO_CONTACT_RESOURCE);
        return string.join(resourceList, ';');

    }

    private static Task[] getTreatmentTasks(){
        Date tempEndDate = Date.today().addDays(-7);
        return [
            SELECT Id, IsRecurrence, CreatedDate, ActivityDate, RecurrenceStartDateOnly, RecurrenceEndDateOnly, RecurrenceActivityId,
            WhatId, WhoId, OwnerId, Animal__c, Animal__r.Animal_Name_Id__c, Animal__r.Current_Recent_Shelter_Location__c,
            Animal__r.Behavior_Case_Worker__c, Animal__r.Behavior_Case_Worker__r.Name, Animal__r.Behavior_Case_Worker__r.Is_Generic_Contact__c,
            Animal_Exam_Sheet_Lookup__c, Medication__c
            FROM Task WHERE RecordType.Name = 'Treatments'
            AND Animal__r.Type_of_Animal__c = 'Dog'
            AND Medication__r.Behavior_Medication__c = true
            AND (
                (IsRecurrence = true AND RecurrenceEndDateOnly >= : tempEndDate)
                OR 
                (RecurrenceActivityId = null AND ActivityDate >= : tempEndDate)
            )
        ];
    }

    private static String checkDayOfWeek(Integer num){
        String dayOfWeek = 'Sunday';
        switch on num {
            when 1 {
                dayOfWeek = 'Monday';
            }	
            when 2 {
                dayOfWeek = 'Tuesday';
            }
            when 3 {
                dayOfWeek = 'Wednesday';
            }
            when 4 {
                dayOfWeek = 'Thursday';
            }
            when 5 {
                dayOfWeek = 'Friday';
            }
            when 6 {
                dayOfWeek = 'Saturday';
            }
        }
        return dayOfWeek;
    }
}
