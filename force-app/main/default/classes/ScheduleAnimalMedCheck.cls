public with sharing class ScheduleAnimalMedCheck {
    public static Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.BEHAVIOR_MED_CHECK_TASK_RECORD_TYPE_NAME);
    public static Task[] scheduleMedCheck(){
        Task[] medCheckTasks = new Task[0];
        Task[] treatmentTasks = [SELECT Id, IsRecurrence, CreatedDate, ActivityDate, RecurrenceStartDateOnly, RecurrenceEndDateOnly, RecurrenceActivityId FROM Task WHERE RecordType.Name = 'Treatments' 
        AND (IsRecurrence = true OR RecurrenceActivityId = null) ORDER BY ActivityDate];

        //add status check
        //add end date check

        return medCheckTasks;
    }
}
