global class BehaviorSchedulable implements Schedulable{
    /*
    * This is a generic Schedulable class, it can be scheduled in the UI through 
    * Setup => Apex Classes => Schedule Apex
    * it is set up to allow adding additional jobs that also need to run weekly
    */

    global void execute(SchedulableContext SC){
        //we pass in null values so it will run for all animals and the default dates instead of specific animals and dates
        AutoScheduleController.handleScheduleTasks(null, null, null);
    }
}