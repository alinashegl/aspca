@isTest
public class TaskTriggerHandlerTest {

    @testSetup
    static void setupData(){
        Case cs = new Case();
        insert cs;
        
        Contact con = new Contact(LastName='Test', MailingCity='Test', MailingState='AK',County__c='Test');
        insert con;
        
        Contact con2 = new Contact(LastName='Test2', MailingCity='Test2', MailingState='AK',County__c='Test2', Contact_Type__c='Behavior Case Worker', Email='test5@domain.com');
        insert con2;
        
        Animal__c anim = new Animal__c(Name='Test', Case__c=cs.Id, Behavior_Case_Worker__c=con2.Id,Discharged_to_Contact__c=con.Id,Type_of_Animal__c = 'Dog',Age__c='Unknown At Intake');
        insert anim;
        
        Medication_Drug__c drug = new Medication_Drug__c(Name='drug1', Behavior_Medication__c=true);
        insert drug;
        
   		Animal_Exam_Sheet__c objAnimalExam = new Animal_Exam_Sheet__c (Animal__c =anim.id,Heartworm__c=true,FIV__c=true,FIV_Results__c='FIVResult',Heartworm_Results__c='heartwormResult',Babesia__c=true,Babesia_Results__c='babesiaResult',Felv_FIV_Results__c='FelvFIV',Include_in_discharge__c ='Yes',Editor__c='AS');
        insert objAnimalExam;
    }
    
    @isTest
    static void testBehMedCheck(){
        test.startTest();
        Task treatmentTask = new Task();
        treatmentTask.Subject = 'Animal Treatment';
        treatmentTask.ActivityDate = System.today();
        treatmentTask.Editor__c = 'Test';
        treatmentTask.Animal_Exam_Sheet_Lookup__c = [select id from Animal_Exam_Sheet__c LIMIT 1].Id;
        treatmentTask.Frequency_Of_Treatment__c = 'BID';
        treatmentTask.Priority = 'Low';
        treatmentTask.Status = 'Not Started';
        treatmentTask.WhatId = [select id from Animal__c LIMIT 1].Id;
        treatmentTask.Medication__c = [select id from Medication_Drug__c LIMIT 1].Id;
        treatmentTask.RecordTypeId = Util.getRecordTypeId('Task','Treatments');
		treatmentTask.Species__c = 'Dog';
        insert treatmentTask;
        test.stopTest();
        List<Task> taskList = [Select Id,recordType.name from task where recordType.name = 'Behavior Medication Check'];
        System.assertEquals(taskList.size(), 3);
    }
    
	@isTest
    static void testInvalid(){
        test.startTest();
        Animal__c anm = [select id, Behavior_Case_Worker__c from Animal__c LIMIT 1];
        anm.Behavior_Case_Worker__c = null;
        update anm;
        
        Task treatmentTask = new Task();
        treatmentTask.Subject = 'Animal Treatment';
        treatmentTask.ActivityDate = System.today();
        treatmentTask.Editor__c = 'Test';
        treatmentTask.Animal_Exam_Sheet_Lookup__c = [select id from Animal_Exam_Sheet__c LIMIT 1].Id;
        treatmentTask.Frequency_Of_Treatment__c = 'BID';
        treatmentTask.Priority = 'Low';
        treatmentTask.Status = 'Not Started';
        treatmentTask.WhatId = anm.Id;
        treatmentTask.Medication__c = [select id from Medication_Drug__c LIMIT 1].Id;
        treatmentTask.RecordTypeId = Util.getRecordTypeId('Task','Treatments');
		treatmentTask.Species__c = 'Dog';
        insert treatmentTask;
        test.stopTest();
        List<Task> taskList = [Select Id from task where recordType.name =: AutoScheduleTasksUtil.BEHAVIOR_MED_CHECK_TASK_RECORD_TYPE_NAME];
        System.assertEquals(taskList.size(), 0);
    }

    @isTest
    static void cleanResources(){
        String[] resourceList = new String[]{'test', AutoScheduleTasksUtil.NO_CONTACT_RESOURCE, 'test1'};
        test.startTest();
        String cleaned = TaskTriggerHandler.cleanResources(resourceList);
        test.stopTest();

        System.assertEquals('test;test1', cleaned, 'should have returned cleaned list with test and test1, but was: ' + cleaned);
    }

    @isTest 
    static void resourceMap(){
        test.startTest();
            Map<String, String[]> resourceMap = TaskTriggerHandler.resourceMap('willow (111); George; Bill');
        test.stopTest();

        System.assertEquals(false, resourceMap.isEmpty(), 'Should have returned a map with items, instead was empty');
        System.assertEquals(true, resourceMap.containsKey('dog'), 'Should have returned a map with dog as one of the keys, but did not');
        System.assertEquals(true, resourceMap.containsKey('contact'), 'Should have returned a map with contact as one of the keys, but did not');
    }

    @isTest 
    static void handleDaybackResourceUnchanged(){
        Task treatmentTask = new Task();
        treatmentTask.Subject = 'Animal Treatment';
        treatmentTask.ActivityDate = System.today();
        treatmentTask.Editor__c = 'Test';
        treatmentTask.Animal_Exam_Sheet_Lookup__c = [select id from Animal_Exam_Sheet__c LIMIT 1].Id;
        treatmentTask.Frequency_Of_Treatment__c = 'BID';
        treatmentTask.Priority = 'Low';
        treatmentTask.Status = 'Not Started';
        treatmentTask.WhatId = [select id from Animal__c LIMIT 1].Id;
        treatmentTask.Medication__c = [select id from Medication_Drug__c LIMIT 1].Id;
        treatmentTask.RecordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.BEH_TREATMENT_TASK_RECORD_TYPE_NAME);
		treatmentTask.Species__c = 'Dog';
        treatmentTask.Assigned_Resources__c = 'George;Bill';
        insert treatmentTask;

        test.startTest();
            update treatmentTask;
        test.stopTest();

        Task updatedTask = [SELECT Id, ActivityDate, Assigned_Resources__c FROM Task WHERE Id = :treatmentTask.Id LIMIT 1];

        System.assertNotEquals(null, updatedTask);
        System.assertEquals('George;Bill', updatedTask.Assigned_Resources__c);
    }

    @isTest 
    static void handleDaybackResourceChanged(){
        Task treatmentTask = new Task();
        treatmentTask.Subject = 'Animal Treatment';
        treatmentTask.ActivityDate = System.today();
        treatmentTask.Editor__c = 'Test';
        treatmentTask.Animal_Exam_Sheet_Lookup__c = [select id from Animal_Exam_Sheet__c LIMIT 1].Id;
        treatmentTask.Frequency_Of_Treatment__c = 'BID';
        treatmentTask.Priority = 'Low';
        treatmentTask.Status = 'Not Started';
        treatmentTask.WhatId = [select id from Animal__c LIMIT 1].Id;
        treatmentTask.Medication__c = [select id from Medication_Drug__c LIMIT 1].Id;
        treatmentTask.RecordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.BEH_TREATMENT_TASK_RECORD_TYPE_NAME);
		treatmentTask.Species__c = 'Dog';
        treatmentTask.Assigned_Resources__c = 'George;Bill';
        insert treatmentTask;

        test.startTest();
            treatmentTask.Assigned_Resources__c = 'Willow (111);George;Mary';
            update treatmentTask;
        test.stopTest();

        Task updatedTask = [SELECT Id, ActivityDate, Assigned_Resources__c FROM Task WHERE Id = :treatmentTask.Id LIMIT 1];

        System.assertNotEquals(null, updatedTask);
        System.assertEquals('George;Mary', updatedTask.Assigned_Resources__c);
    }

    @isTest 
    static void handleDaybackResourceAdditionalDogAdded(){
        Task treatmentTask = new Task();
        treatmentTask.Subject = 'Animal Treatment';
        treatmentTask.ActivityDate = System.today();
        treatmentTask.Editor__c = 'Test';
        treatmentTask.Animal_Exam_Sheet_Lookup__c = [select id from Animal_Exam_Sheet__c LIMIT 1].Id;
        treatmentTask.Frequency_Of_Treatment__c = 'BID';
        treatmentTask.Priority = 'Low';
        treatmentTask.Status = 'Not Started';
        treatmentTask.WhatId = [select id from Animal__c LIMIT 1].Id;
        treatmentTask.Medication__c = [select id from Medication_Drug__c LIMIT 1].Id;
        treatmentTask.RecordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.BEH_TREATMENT_TASK_RECORD_TYPE_NAME);
		treatmentTask.Species__c = 'Dog';
        treatmentTask.Assigned_Resources__c = 'Fido (222);George;Bill';
        insert treatmentTask;

        test.startTest();
            treatmentTask.Assigned_Resources__c = 'Fido (222);Willow (111);George;Mary';
            update treatmentTask;
        test.stopTest();

        Task updatedTask = [SELECT Id, ActivityDate, Assigned_Resources__c FROM Task WHERE Id = :treatmentTask.Id LIMIT 1];

        System.assertNotEquals(null, updatedTask);
        System.assertEquals('Fido (222);George;Bill', updatedTask.Assigned_Resources__c);
    }
}