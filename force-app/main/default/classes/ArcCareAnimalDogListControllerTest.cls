@isTest
public class ArcCareAnimalDogListControllerTest {

    @testSetup
    static void setupData(){
        Contact con1 = new Contact(LastName='Test1', MailingCity='Test1', MailingState='AK',County__c='Test2', Contact_Type__c='Behavior Case Worker', Email='test5@domain.com');
        insert con1;
        
        Contact con2 = new Contact(LastName='Test2', MailingCity='Test2', MailingState='AK',County__c='Test2', Contact_Type__c='Behavior Case Worker', Email='test5@domain.com');
        insert con2;
        
        Animal__c a = TestDataFactory.createAnimalWithName('anm');
        a.Behavior_Case_Worker__c = con2.Id;
        update a;
        
        BehaviorCaseWorker__c bcw = new BehaviorCaseWorker__c();
        bcw.Animal__c = a.Id;
        bcw.StartDate__c = System.today();
        bcw.CaseWorker__c = con2.Id;
        insert bcw;
    }
    
    @isTest
    static void testRecords(){
        List<Animal__c> objs = ArcCareAnimalDogListController.getRecords();
        System.assertNotEquals(objs, null);
        if(!objs.isEmpty()){
            Animal__c anm = objs[0];
            anm.Behavior_Case_Worker__c = [Select Id from Contact Where LastName = 'Test1'].Id;
            update anm;
            String result = ArcCareAnimalDogListController.saveRecords(JSON.serialize(new List<Animal__c>{anm}));
            System.assertEquals('success', result);
        }
        
        
        List<Contact> contacts = ArcCareAnimalDogListController.getBehCaseWorkers();
        System.assertNotEquals(contacts, null);
    }
}