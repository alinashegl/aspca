@isTest
private class test_AutoScheduleController {
    @isTest 
    static void handleScheduleTasks_test(){
        test.startTest();
            AutoScheduleController.handleScheduleTasks();
        test.stopTest();

        //We aren't testing functionality here because the each class called by the controller have their own tests
        Task[] taskList = [SELECT Id FROM Task];
        System.assert(taskList.isEmpty());
    }
}
