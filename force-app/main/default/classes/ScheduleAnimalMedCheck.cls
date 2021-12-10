public with sharing class ScheduleAnimalMedCheck {
    public static Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.BEHAVIOR_MED_CHECK_TASK_RECORD_TYPE_NAME);
    public static Task[] scheduleMedCheck(){
        Task[] medCheckTasks = new Task[0];
        for(Task treatmentTask : getTreatmentTasks()){
            if(treatmentTask.Animal__c != null){
                medCheckTasks.add(prepTask(treatmentTask));
            }
        }
        return medCheckTasks;
    }

    private static Task prepTask(Task treatmentTask){
        Contact genericCon = AutoScheduleTasksUtil.genericContactMap.get(treatmentTask.Animal__r.Current_Recent_Shelter_Location__c);
        Task newTask = new Task(
            WhatId = treatmentTask.WhatId,
            Animal__c = treatmentTask.Animal__c,
            RecordTypeId = recordTypeId,
            ActivityDate = calculateActivityDate(treatmentTask),
            Description = 'Med Check is needed for: ' + treatmentTask.Animal__r.Animal_Name_Id__c + ' (' + treatmentTask.Animal__r.Current_Recent_Shelter_Location__c + ')',
            IsReminderSet = false,
            Status = 'Not Started',
            WhoId = treatmentTask.Animal__r.Behavior_Case_Worker__c != null ? treatmentTask.Animal__r.Behavior_Case_Worker__c : genericCon.Id,
            OwnerId = genericCon.User__c,
            Subject = 'Behavior Medication Check',
            Assigned_Resources__c = treatmentTask.Animal__r.Behavior_Case_Worker__r.Is_Generic_Contact__c == false ? treatmentTask.Animal__r.Behavior_Case_Worker__r.Name : null,
            Species__c = 'Dog'
        );

        return newTask;
    }

    private static Date calculateActivityDate(Task task){
        Date tempDate = task.IsRecurrence == True ? task.RecurrenceStartDateOnly : task.ActivityDate;
        Double daysToAdd = Math.Ceil((Double) tempDate.daysBetween(Date.today())/7)*7;
        return tempDate.addDays(integer.valueOf(daysToAdd));
    }

    private static Task[] getTreatmentTasks(){
        Date tempEndDate = Date.today().addDays(-7);
        return [
            SELECT Id, IsRecurrence, CreatedDate, ActivityDate, RecurrenceStartDateOnly, RecurrenceEndDateOnly, RecurrenceActivityId,
            WhatId, WhoId, OwnerId, Animal__c, Animal__r.Animal_Name_Id__c, Animal__r.Current_Recent_Shelter_Location__c,
            Animal__r.Behavior_Case_Worker__c, Animal__r.Behavior_Case_Worker__r.Name, Animal__r.Behavior_Case_Worker__r.Is_Generic_Contact__c
            FROM Task WHERE RecordType.Name = 'Treatments'
            AND Animal__r.Type_of_Animal__c = 'Dog'
            AND (
                (IsRecurrence = true AND RecurrenceEndDateOnly >= : tempEndDate)
                OR 
                (RecurrenceActivityId = null AND ActivityDate >= : tempEndDate)
            )
        ];
    }
}
