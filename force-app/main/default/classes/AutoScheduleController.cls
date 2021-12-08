public with sharing class AutoScheduleController {
    public static void handleScheduleTasks(){
        Task[] tasksToInsert = new Task[0];
        tasksToInsert.addAll(ScheduleAnimalPlaygroups.schedulePlaygroups());
        tasksToInsert.addAll(ScheduleAnimalTreatments.scheduleTreatments());
        tasksToInsert.addAll(ScheduleAnimalFoster.scheduleFollowUps());

        insert tasksToInsert;
    }
}
