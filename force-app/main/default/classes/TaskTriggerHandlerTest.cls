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
}