@isTest
public class OutOfOfficeControllerTest {
    
    @isTest
    static void testOutOfOfficeRT(){
        List<Map<String, String>> rtList = OutOfOfficeController.getOutOfOfficeRTs();
        System.assertNotEquals(null, rtList);
    }
    
    @isTest
    static void testGetContactId(){
        Contact c = New Contact(FirstName = 'test',
                                LastName = 'user',
                                Email = 'test@user.example.com',
                                WeeklyOff__c = 'Monday;Wednesday',
                               User__c = UserInfo.getUserId());
        insert c;
        OutOfOfficeController.ContactResult result = OutOfOfficeController.getContactId();
        System.assertEquals(result.isSuccess, true);
    }
    
    @isTest
    static void testGetContactIdNegative(){
        Contact c = New Contact(FirstName = 'test',
                                LastName = 'user',
                                Email = 'test@user.example.com',
                                WeeklyOff__c = 'Monday;Wednesday');
        insert c;
        OutOfOfficeController.ContactResult result = OutOfOfficeController.getContactId();
        System.assertEquals(result.isSuccess, false);
    }
    
    @isTest
    static void testhandleOutOfOfficeSchedule(){
        Contact c = New Contact(FirstName = 'test',
                                LastName = 'user',
                                Email = 'test@user.example.com',
                                WeeklyOff__c = 'Monday;Wednesday',
                               User__c = UserInfo.getUserId());
        insert c;
        OutOfOfficeController.handleOutOfOfficeSchedule();
        ControllerHelper.getFieldProperties(Contact.FirstName);
        ControllerHelper.Properties cp = new ControllerHelper.Properties('id', 'Test', new List<PicklistEntry>{}, Account.Type.getDescribe());
    	System.assertNotEquals(cp, null);
    }
}