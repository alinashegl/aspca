@isTest
public class HomePageControllerTest {

    @testSetup
    static void setupData(){
        User cU = [SELECT Id, Location__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        cU.Location__c = 'All';
        update cU;
        
        User u = new User(firstname= 'Test',
                          lastname='XXXX',
                          Alias='Test',
                          Location__c = 'All',
                          email = 'test1234@example.com',
                          username= 'test1234xxx@test.com', 
                          profileId= [SELECT id, Name FROM Profile where name = 'System Administrator' ].id, 
                          emailencodingkey='UTF-8',
                          languagelocalekey='en_US',
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles');
        insert u;
        
        Case cs = new Case();
        insert cs;
        
        Contact con = new Contact(LastName='Test', MailingCity='Test', MailingState='AK',MailingCountry='United States');
        insert con;
        
        Contact con2 = new Contact(LastName='Test2', MailingCity='Test2', MailingState='AK',MailingCountry='United States', Contact_Type__c='Behavior Case Worker', Email='test5@domain.com');
        insert con2;
        
        System.runAs(u) {
            
        
        Animal__c anim = TestDataFactory.createAnimalWithName('Test');
        anim.Behavior_Case_Worker__c = con2.Id;
        anim.Discharged_to_Contact__c = con.Id;
        anim.Age__c = 'Unknown At Intake';

        update anim;
        
        Medication_Drug__c drug = new Medication_Drug__c(Name='drug1', Behavior_Medication__c=true);
        insert drug;
        
   		Animal_Exam_Sheet__c objAnimalExam = new Animal_Exam_Sheet__c (Animal__c =anim.id,Heartworm__c=true,FIV__c=true,FIV_Results__c='FIVResult',Heartworm_Results__c='heartwormResult',Babesia__c=true,Babesia_Results__c='babesiaResult',Felv_FIV_Results__c='FelvFIV',Include_in_discharge__c ='Yes',Editor__c='AS');
        insert objAnimalExam;
        
                
        Treatment_Bundle__c bundle = new Treatment_Bundle__c();
        bundle.Name = 'Master';
        bundle.IsActive__c = true;
        bundle.IsMaster__c = true;
        insert bundle;
        
        Treatment_Plan__c plan = new Treatment_Plan__c(
          IsActive__c = true, 
          Description__c = 'Test', 
          Animal__c = anim.Id, 
          Problem_Behavior__c = 'Fear of People - Mild',
            Treatment_Priority__c = 'Daily – 7 days'
        );
        
        insert plan;
        
        Protocol__c protocol = new Protocol__c();
        protocol.Name = 'Test';
        protocol.IsActive__c = true;
        protocol.Description__c = 'This is a Test Protocol';
        insert protocol;
        
        Plan_Protocol__c newProtocol = new Plan_Protocol__c(Treatment_Plan__c = plan.Id, Protocol__c = protocol.Id, IsRemoved__c = Math.mod(1, 2) != 0);
        insert newProtocol;
            
        }

        Animal__c anim2 = TestDataFactory.createAnimalWithName('Test2');
        anim2.Behavior_Case_Worker__c = con2.Id;
        anim2.Discharged_to_Contact__c = con.Id;
        anim2.Age__c = 'Unknown At Intake';

        update anim2;
        
        Task treatmentTask = new Task();
        treatmentTask.Subject = 'Animal Treatment';
        treatmentTask.ActivityDate = System.today();
        treatmentTask.Editor__c = 'Test';
        treatmentTask.Animal_Exam_Sheet_Lookup__c = [select id from Animal_Exam_Sheet__c LIMIT 1].Id;
        treatmentTask.Frequency_Of_Treatment__c = 'BID';
        treatmentTask.Priority = 'Low';
        treatmentTask.Status = 'Not Started';
        treatmentTask.WhatId = anim2.Id;
        treatmentTask.Animal__c = treatmentTask.WhatId;
        treatmentTask.Medication__c = [select id from Medication_Drug__c LIMIT 1].Id;
        treatmentTask.RecordTypeId = Util.getRecordTypeId('Task','Treatments');
		treatmentTask.Species__c = 'Dog';
        insert treatmentTask;

    }
    
    @isTest
    static void testTasks(){
        List<HomePageController.animalTaskRec> recs = HomePageController.getAnmialTasks(10, 0);
        System.assertNotEquals(null, recs);
    }
    
    @isTest
    static void testTreatments(){
        List<HomePageController.animalTreatmentRec> recs = HomePageController.getAnmialTreatement();
        System.assertNotEquals(null, recs);
    }
}