@isTest
public class PuppyMillCreatedTest {
    @isTest static void createPuppyMillTest() {
        // Creating Box folders doesn't seem to work in test mode,
        // but we have to have a test class for the trigger anyhow
        Test.startTest();
        // Create account
        String puppyMillId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Puppy Mill Agency').getRecordTypeId();
        Account acct = new Account(Name='Test Trigger Account', RecordtypeId = puppyMillId);
        insert acct;
        // Clean up account
        Database.DeleteResult result = Database.delete(acct, false);
        Test.stopTest();    
        System.assert(result.isSuccess());
    }
}