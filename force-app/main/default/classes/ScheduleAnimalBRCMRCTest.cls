@isTest
public class ScheduleAnimalBRCMRCTest {
	public static Id recordTypeId = Util.getRecordTypeId('Task','MRC_BRC_Follow_UP');
    @testSetup
    static void setupData(){
        Case cs = new Case();
        insert cs;
        
        Contact con = new Contact(LastName='Test', MailingCity='Test', MailingState='AK',County__c='Test');
        insert con;
        
        Contact con2 = new Contact(LastName='Test2', MailingCity='Test2', MailingState='AK',County__c='Test2', Contact_Type__c='Behavior Case Worker', Email='test5@domain.com');
        insert con2;
        
        Animal__c anim = new Animal__c(Name='TestBRC', Case__c=cs.Id, Behavior_Case_Worker__c=con2.Id,Discharged_to_Contact__c=con.Id,Type_of_Animal__c = 'Dog',Age__c='Unknown At Intake');
        anim.BRC_Status__c = 'BRC Accepted';
        anim.Current_Recent_Shelter_Location__c = 'CARE';
        insert anim;
        
        Animal__c animdec = new Animal__c(Name='TestBRCDec', Case__c=cs.Id, Behavior_Case_Worker__c=con2.Id,Discharged_to_Contact__c=con.Id,Type_of_Animal__c = 'Dog',Age__c='Unknown At Intake');
        animdec.BRC_Status__c = 'BRC Declined';
        animdec.Current_Recent_Shelter_Location__c = 'CARE';
        insert animdec;
        
        Animal__c animbrcmrc = new Animal__c(Name='TestBRCMRC', Case__c=cs.Id, Behavior_Case_Worker__c=con2.Id,Discharged_to_Contact__c=con.Id,Type_of_Animal__c = 'Dog',Age__c='Unknown At Intake');
        animbrcmrc.BRC_Status__c = 'BRC Accepted';
        animbrcmrc.MRC_Status__c = 'MRC Accepted';
        animbrcmrc.Current_Recent_Shelter_Location__c = 'CARE';
        insert animbrcmrc;
        
        List<Task> tasks = new List<Task>();
        
        Task newTask = new Task();
        newTask.WhatId = anim.Id;
        newTask.Animal__c = anim.Id;
        newTask.RecordTypeId = recordTypeId;
        newTask.ActivityDate = System.today().addDays(15);
        newTask.Description = 'Test';
        newTask.Status = 'Not Started';
        tasks.add(newTask);
        
        Task newTaskDec = new Task();
        newTaskDec.WhatId = animdec.Id;
        newTaskDec.Animal__c = animdec.Id;
        newTaskDec.RecordTypeId = recordTypeId;
        newTaskDec.ActivityDate = System.today().addDays(15);
        newTaskDec.Description = 'Test';
        newTaskDec.Status = 'Not Started';
        newtaskDec.Completed_By_Text__c = 'Test';
        tasks.add(newTaskDec);
        
        insert tasks;
    }
    
    @isTest
    static void testBRCMRCTasks(){
        test.startTest();
        List<Task> tasks = ScheduleAnimalBRCMRC.scheduleBRCMRCTasks(null);
        System.assertNotEquals(null, tasks, 'Should have returned tasks, instead was null');
        System.debug(tasks.size());
        ScheduleAnimalBRCMRC.completeBRCMRCTasks();
        test.stopTest();

        Task[] completedTasks = [SELECT Id FROM Task WHERE Status = 'Completed'];
        System.assertEquals(1, completedTasks.size());
    }
}