global class DailyCareSchedulable  implements Schedulable {
    /*
    * This is a generic Schedulable class, it can be scheduled in the UI through 
    * Setup => Apex Classes => Schedule Apex
    * it is set up to allow adding additional jobs that also need to run daily
    */
    global void execute(SchedulableContext SC){
        DailyCareController.handleDailyCareSchedular();
    }
}