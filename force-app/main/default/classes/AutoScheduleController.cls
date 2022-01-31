public with sharing class AutoScheduleController {
    public static void handleScheduleTasks(Id[] animalIds){
        Task[] tasksToInsert = new Task[0];
        tasksToInsert.addAll(ScheduleAnimalPlaygroups.schedulePlaygroups(animalIds));
        tasksToInsert.addAll(ScheduleAnimalBehaviorTreatments.scheduleTreatments(animalIds));
        tasksToInsert.addAll(ScheduleAnimalFoster.scheduleFollowUps(animalIds));
        tasksToInsert.addAll(ScheduleAnimalMedCheck.scheduleMedCheck(animalIds));
        tasksToInsert.addAll(ScheduleBoardAndTrainTask.scheduleFollowUps(animalIds));
        tasksToInsert.addAll(ScheduleAnimalBRCMRC.scheduleBRCMRCTasks(animalIds));

        //update existing BRCMRC tasks
        ScheduleAnimalBRCMRC.completeBRCMRCTasks();

        insert tasksToInsert;
    }

    public static void deleteFutureTasks(Id[] animalIds, Date startDate){
        delete [
            SELECT Id 
            FROM Task 
            WHERE Animal__c IN: animalIds 
            AND RecordType.DeveloperName IN :AutoScheduleTasksUtil.taskRecordTypes
            AND ActivityDate >=: startDate
        ];
    }
}
