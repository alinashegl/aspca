@isTest
public class test_FacilityOutcomeTrigger {
    @isTest
    static void sendInsertUpdateEmailTest() {
        Contact c = new Contact(FirstName = 'Second', LastName = 'Contact', Email = 'second@contact.com');
        insert c;
        Test.startTest();
        //First email invocation occurs here on the insert
        Facility_Outcome__c fosterFacility = TestDataFactory.createFacilityOutcome();
        //Second email invocation occurs here on the update from one contact to another
        fosterFacility.Point_of_Contact__c = c.Id;
        update fosterFacility;
        //No email occurs here
        fosterFacility.Point_of_Contact__c = null;
        update fosterFacility;
        //Third email invocation occurs here on the update from having no contact to having a contact
        fosterFacility.Point_of_Contact__c = c.Id;
        update fosterFacility;
        Integer emailInvocations = Limits.getEmailInvocations();
        Test.stopTest();
        
        //do not send emails if tests are running because it will fail if emails are turned off (typical in sandboxes) so, this should be 0
        System.assertEquals(0, emailInvocations);
    }

    @isTest
    static void sendNoEmailAddressTest() {
        Contact c = new Contact(FirstName = 'No', LastName = 'Email');
        insert c;
        Facility_Outcome__c fosterFacility = TestDataFactory.createFacilityOutcome();
        Test.startTest();
        fosterFacility.Point_of_Contact__c = c.Id;
        Integer emailInvocations = Limits.getEmailInvocations();
        Test.stopTest();
        System.assertEquals(0, emailInvocations);
    }

    @isTest 
    static void handleEvaluationProcessTest(){
        Animal__c dog = TestDataFactory.createAnimalWithName('Willow');
        Contact c = TestDataFactory.createContact();
        Facility_Outcome__c arcFO = new Facility_Outcome__c(
            Animal__c = dog.Id,
            Facility_or_Outcome__c = 'Facility',
            Facility_Outcome__c = 'ARC',
            Point_of_Contact__c = c.Id,
            Start_Date__c = System.today()
        );        

        Test.startTest();
        insert arcFO;
        Test.stopTest();

        dog = [SELECT Id, Evaluation_Due_Date__c FROM Animal__c WHERE Id = :dog.Id LIMIT 1];
        System.assertEquals(true, dog.Evaluation_Due_Date__c != null, 'Should have an evaluation due date, but was null');

        Task[] evalTasks = [SELECT Id FROM Task WHERE Animal__c = :dog.Id AND RecordTypeId = :Util.getRecordTypeId('Task',AutoScheduleTasksUtil.EVALUATION_RECORD_TYPE_NAME)];
        System.assertEquals(1, evalTasks.size(), 'Should have returned one evaluation task, instead was: ' + evalTasks);
    }
}