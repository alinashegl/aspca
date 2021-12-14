public with sharing class AutoScheduleController {
    public static void handleScheduleTasks(){
        Task[] tasksToInsert = new Task[0];
        tasksToInsert.addAll(ScheduleAnimalPlaygroups.schedulePlaygroups());
        tasksToInsert.addAll(ScheduleAnimalBehaviorTreatments.scheduleTreatments());
        tasksToInsert.addAll(ScheduleAnimalFoster.scheduleFollowUps());
        tasksToInsert.addAll(ScheduleAnimalMedCheck.scheduleMedCheck());

        insert tasksToInsert;
    }
}
