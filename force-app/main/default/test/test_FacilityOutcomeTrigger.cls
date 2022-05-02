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
}