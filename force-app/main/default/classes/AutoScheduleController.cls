public with sharing class AutoScheduleController {
    public static void handleScheduleTasks(Id[] animalIds, Date startDate, Date endDate){
        /*
        * if the start or end dates a null then we follow the default schedule which is calculated on the AutoScheduleTasksUtil class
        * Also save the start and end date to paramters on the AutoScheduleTaskUtil becuase it is used by each of the classes below and that way 
        * we don't need to pass the dates around each time.
        * the default datse are for the following week, with ASPCA's week starting on Tuesday
        */
        if(startDate != null || endDate != null){
            AutoScheduleTasksUtil.startDate = startDate;
            AutoScheduleTasksUtil.endDate = endDate;
        }

        //call each of the methods below to compile a list of all tasks that need to be inserted
        Task[] tasksToInsert = new Task[0];
        tasksToInsert.addAll(ScheduleAnimalPlaygroups.schedulePlaygroups(animalIds));
        tasksToInsert.addAll(ScheduleAnimalBehaviorTreatments.scheduleTreatments(animalIds));
        tasksToInsert.addAll(ScheduleAnimalMedCheck.scheduleMedCheck(animalIds));
        tasksToInsert.addAll(ScheduleAnimalFoster.scheduleFollowUps(animalIds));
        tasksToInsert.addAll(ScheduleBoardAndTrainTask.scheduleFollowUps(animalIds));
        tasksToInsert.addAll(ScheduleAnimalBRCMRC.scheduleBRCMRCTasks(animalIds));
        OutOfOfficeController.handleOutOfOfficeSchedule();

        //update existing BRCMRC tasks
        ScheduleAnimalBRCMRC.completeBRCMRCTasks();

        if(!tasksToInsert.isEmpty()){
            insert tasksToInsert;
        }
    }

    public static void deleteFutureTasks(Id[] animalIds, Date startDate, Date endDate){
        //only delete tasks if we have a specific start and end date
        if(startDate != null && endDate != null){
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
}