public with sharing class AutoScheduleController {
    public static void handleScheduleTasks(Id[] animalIds, Date startDate, Date endDate){
        if(startDate == null || endDate == null){
            Map<String, AutoScheduleTasksUtil.DateRangeWrapper> dateRanges = AutoScheduleTasksUtil.dateRanges;
            AutoScheduleTasksUtil.startDate = dateRanges.get('nextWeek').startDate;
            AutoScheduleTasksUtil.endDate = dateRanges.get('nextWeek').endDate;
        } else {
            AutoScheduleTasksUtil.startDate = startDate;
            AutoScheduleTasksUtil.endDate = endDate;
        }

        Task[] tasksToInsert = new Task[0];
        tasksToInsert.addAll(ScheduleAnimalPlaygroups.schedulePlaygroups(animalIds));
        tasksToInsert.addAll(ScheduleAnimalBehaviorTreatments.scheduleTreatments(animalIds));
        tasksToInsert.addAll(ScheduleAnimalFoster.scheduleFollowUps(animalIds));
        tasksToInsert.addAll(ScheduleAnimalMedCheck.scheduleMedCheck(animalIds));
        tasksToInsert.addAll(ScheduleBoardAndTrainTask.scheduleFollowUps(animalIds));
        tasksToInsert.addAll(ScheduleAnimalBRCMRC.scheduleBRCMRCTasks(animalIds));

        //update existing BRCMRC tasks
        ScheduleAnimalBRCMRC.completeBRCMRCTasks();

        if(!tasksToInsert.isEmpty()){
            insert tasksToInsert;
        }
    }

    public static void deleteFutureTasks(Id[] animalIds, Date startDate, Date endDate){
        delete [
            SELECT Id 
            FROM Task 
            WHERE Animal__c IN: animalIds 
            AND RecordType.DeveloperName IN :AutoScheduleTasksUtil.taskRecordTypes
            AND ActivityDate >=: startDate
            AND ActivityDate <=: endDate
            AND Auto_Scheduled_Task__c = true
        ];
    }
}
