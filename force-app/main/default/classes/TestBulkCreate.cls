@isTest
public class TestBulkCreate {
    @isTest public static void testIt() {
        RecordType puppyMill = [SELECT ID FROM RecordType WHERE Name = 'Puppy Mill Agency' LIMIT 1];
        Account testAccount = new Account();
        testAccount.Name = 'Test Puppy Mill Agency';
        testAccount.RecordTypeId = puppyMill.ID;
        //testAccount.No_Folders__c = true;
        insert testAccount;
        
        BulkCreate.createFolders(0);
    }
}