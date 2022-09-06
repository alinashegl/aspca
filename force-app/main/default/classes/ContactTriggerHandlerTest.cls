@isTest
public class ContactTriggerHandlerTest {
	
    @testSetup
    static void setupData(){
        TestDataFactory.init();
        Contact c = New Contact(FirstName = 'test',
                                LastName = 'user',
                                Email = 'test@user.example.com',
                                WeeklyOff__c = 'Monday;Wednesday');
        insert c;
    } 
    
    @isTest
    static void testWeeklyOffs(){
        List<Contact> contacts = [Select WeeklyOff__c from Contact];
        for(Contact c : contacts){
        	c.WeeklyOff__c = 'Saturday;Sunday';
        }
        update contacts;
        List<OutOfOffice__c> outofoffices = [Select Id from OutOfOffice__c];
        System.assertNotEquals(null, outofoffices);
    }
}