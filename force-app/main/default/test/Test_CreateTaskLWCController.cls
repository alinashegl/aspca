@isTest 
private class Test_CreateTaskLWCController {
    @isTest
    static void getRecordInfo_hasAnimal(){
        Animal__c anim = TestDataFactory.createAnimal();

        test.startTest();
        CreateTaskLWCController.NewTaskWrapper taskInfo = CreateTaskLWCController.getRecordInfo(anim.Id);
        test.stopTest();

        validateTaskInfo(taskInfo, anim.Id);
    }

    @isTest
    static void getRecordInfo_nonAnimalId(){
        Contact con = TestDataFactory.createContact();

        test.startTest();
        CreateTaskLWCController.NewTaskWrapper taskInfo = CreateTaskLWCController.getRecordInfo(con.Id);
        test.stopTest();

        validateTaskInfo(taskInfo, null);
    }

    @isTest
    static void getRecordInfo_noId(){
        test.startTest();
        CreateTaskLWCController.NewTaskWrapper taskInfo = CreateTaskLWCController.getRecordInfo(null);
        test.stopTest();

        validateTaskInfo(taskInfo, null);
    }

    @isTest
    static void getBehCaseWorker_hasCaseworker(){
        Animal__c anim = TestDataFactory.createAnimal();
        Contact con = TestDataFactory.createBehaviorCaseWorkerContact();
        anim.Behavior_Case_Worker__c = con.Id;
        update anim;

        test.startTest();
        Id caseWorkerId = CreateTaskLWCController.getBehCaseWorker(anim.Id);
        test.stopTest();
        
        System.assertEquals(false, caseWorkerId == null);
    }

    @isTest
    static void getBehCaseWorker_noCaseworker(){
        Animal__c anim = TestDataFactory.createAnimal();

        test.startTest();
        Id caseWorkerId = CreateTaskLWCController.getBehCaseWorker(anim.Id);
        test.stopTest();
        
        System.assertEquals(true, caseWorkerId == null);
    }

    @isTest
    static void getBehCaseWorker_noAnimalr(){

        test.startTest();
        Id caseWorkerId = CreateTaskLWCController.getBehCaseWorker(null);
        test.stopTest();
        
        System.assertEquals(true, caseWorkerId == null);
    }

    @isTest
    static void insertTask_success(){
        Animal__c anim = TestDataFactory.createAnimal();
       
        Task t = new Task(
            Animal__c = anim.Id
        );

        test.startTest();
        String url = CreateTaskLWCController.insertTask(t);
        test.stopTest();

        System.assertEquals(false, url == null);
    }

    @isTest
    static void insertTask_GeneralRT_success(){
        Animal__c anim = TestDataFactory.createAnimal();
        Contact con = TestDataFactory.createContact();
       
        Task t = new Task(
            Animal__c = anim.Id,
            RecordTypeId = Util.getRecordTypeId('Task', 'General_Task'),
            WhoId = con.Id
        );

        test.startTest();
        String url = CreateTaskLWCController.insertTask(t);
        test.stopTest();

        System.assertEquals(false, url == null);

        Task newTask = [SELECT Id, Assigned_Resources__c FROM Task LIMIT 1];
        System.assertEquals(
            true, 
            newTask.Assigned_Resources__c != null, 
            'Assigned resources should have been populated, but was null'
        );        
    }

    private static void validateTaskInfo(CreateTaskLWCController.NewTaskWrapper taskInfo, Id animalId){
        
        if(animalId != null){
            System.assertEquals(
                animalId, 
                taskInfo.animal.Id,
                'Animal Id returned in taskinfo should have matched the animalId created in the test setup'
            );
        } else {
            System.assertEquals(
                true, 
                taskInfo.animal == null,
                'taskInfo.animal should have been null, but was: ' + taskInfo.animal
            );
        }
        
        System.assertEquals(
            false, 
            taskInfo.subjectOptions == null,
            'Should have returned a list of subject options, but was null'
        );
        System.assertEquals(
            false, 
            taskInfo.recordTypeOptions == null,
            'Should have returned a list of record type options, but was null'
        );
        System.assertEquals(
            Util.getRecordTypeId('Task', 'General_Task'), 
            taskInfo.defaultRecordType,
            'Should have returned the Id for the Task General_Task record type, but was: ' + taskInfo.defaultRecordType
        );
        System.assertEquals(
            Date.today(), 
            taskInfo.dueToday,
            'taskInfo.dueToday should be today\'s date, but was: ' + taskInfo.dueToday
        );
    }
}