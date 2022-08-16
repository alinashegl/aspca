@isTest
private class test_AutoScheduleController {
    @isTest 
    static void handleScheduleTasksNoDates(){
        test.startTest();
            AutoScheduleController.handleScheduleTasks(null, null, null);
        test.stopTest();

        //We aren't testing functionality here because the each class called by the controller have their own tests
        Task[] taskList = [SELECT Id FROM Task];
        System.assert(taskList.isEmpty());
    }

    @isTest
    static void handleScheduleTasksWithDates(){
        test.startTest();
            AutoScheduleController.handleScheduleTasks(null, date.today(), date.today().addDays(7));
        test.stopTest();

        //We aren't testing functionality here because the each class called by the controller have their own tests
        Task[] taskList = [SELECT Id FROM Task];
        System.assert(taskList.isEmpty());
    }    

    @isTest 
    static void deleteFutureTasks(){
        Animal__c anim = TestDataFactory.createAnimal();
        Id recordTypeId = Util.getRecordTypeId('Task', AutoScheduleTasksUtil.BEH_TREATMENT_TASK_RECORD_TYPE_NAME);
        Task[] toInsert = new Task[0];
        //future task
        toInsert.add(new Task(
            Animal__c = anim.Id,
            RecordTypeId = recordTypeId,
            ActivityDate = date.today().addDays(3),
            Auto_Scheduled_Task__c = true
        ));

        //older task
        toInsert.add(new Task(
            Animal__c = anim.Id,
            RecordTypeId = recordTypeId,
            ActivityDate = date.today().addDays(-3),
            Auto_Scheduled_Task__c = true
        ));

        insert toInsert;

        test.startTest();
            AutoScheduleController.deleteFutureTasks(new Id[]{anim.Id}, date.today(), date.today().addDays(4));
        test.stopTest();

        System.assert([SELECT Id FROM Task WHERE Animal__c =: anim.Id AND ActivityDate >= TODAY].isEmpty(), 'Should not have returned any tasks');
        System.assert(![SELECT Id FROM Task WHERE Animal__c =: anim.Id AND ActivityDate < TODAY].isEmpty(), 'Should have returned 1 task');
    }
}