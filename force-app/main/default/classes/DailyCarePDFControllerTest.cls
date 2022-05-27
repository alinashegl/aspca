@isTest
public class DailyCarePDFControllerTest {

    @testSetup
    static void setupData(){
        
        case objCase = new Case(Status = 'On hold',Origin='Email',Agency_Case__c = 'test');
        insert objCase ;
        
        Animal__c objAnimal = new Animal__c(Case__c =objCase.id, Name='A-001-West',type_of_animal__c='Cat',breed__c='Coonhound',gender__c='MI',Animal_Age__c=12,Color__c='Brown',Intake_Date_Time__c= DateTime.now());
        insert objAnimal;
        
        Daily_Care__c dc = new Daily_Care__c(AM_Reminders__c = 'Refill DBT buckets w/hot dog/cheese each AM and ice pack!2.', 
                                             Date__c = System.today(), 
                                             General_Reminders__c = 'Test General Reminder', 
                                             PM_Reminders__c = 'Test PM Reminder', 
                                             Scent_of_the_Week__c = 'Skunk', 
                                             Special_Projects__c = 'Its Special');
        insert dc;
        
        Animal_Daily_Care__c adc = new Animal_Daily_Care__c(Daily_Care__c = dc.id,
                                                            Animal__c = objAnimal.Id, 
                                                            Handling_Instructions__c = 'Walks really well!', 
                                                            Movement_Method_For_Cleaning__c = 'Test', 
                                                            Movements_For_Cleaning__c = 'Test', 
                                                            Mvmt_Round_Notes_Cleaning_Destination__c = 'Test', 
                                                            Round__c = '1', 
                                                            Special_Care_Other__c = 'Test', 
                                                            Special_Care_Outside_TX__c = 'Test', 
                                                            Special_Care_TX__c = 'Test', 
                                                            Enrichment__c = 'Test');
        insert adc;
        
        Task t = new Task(ActivityDate = system.today(),
                          RecordTypeId = Util.getRecordTypeId('Task', AutoScheduleTasksUtil.BEH_TREATMENT_TASK_RECORD_TYPE_NAME),
                          Animal__c = objAnimal.Id,
                          OwnerId = UserInfo.getUserId(),
                          Subject = 'Test',
                          Editor__c = 'Test');

        insert t;
    }
    
    @isTest
    static void testPdf(){
        Daily_Care__c dc = [SELECT AM_Reminders__c, Date__c, General_Reminders__c, PM_Reminders__c, Scent_of_the_Week__c, Special_Projects__c, Name, Id FROM Daily_Care__c];
        ApexPages.StandardController sc = new ApexPages.StandardController(dc);
        ApexPages.currentPage().getParameters().put('dailyCareId',dc.Id);
        PageReference pageRef = sc.view();
        Test.setCurrentPage(pageRef);
      
        DailyCarePDFController controller = new DailyCarePDFController();
        Daily_Care__c ddc = controller.dailyCare;
        List<DailyCarePDFController.AnimalDailyCare> adcList = controller.animalDailyCares;
        System.assertNotEquals(null, controller);
    }
    
    @isTest
    static void testPdf2(){
        PageReference pageRef = Page.DailyCarePDF;
        Test.setCurrentPage(pageRef);
      	Daily_Care__c dc = [SELECT AM_Reminders__c, Date__c, General_Reminders__c, PM_Reminders__c, Scent_of_the_Week__c, Special_Projects__c, Name, Id FROM Daily_Care__c];
        ApexPages.currentPage().getParameters().put('dailyCareId',dc.Id);
        DailyCarePDFController controller = new DailyCarePDFController();
        Daily_Care__c ddc = controller.dailyCare;
        List<DailyCarePDFController.AnimalDailyCare> adcList = controller.animalDailyCares;
        System.assertNotEquals(null, controller);
    }
}