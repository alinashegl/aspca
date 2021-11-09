@isTest
public class CaseTriggerTest {

    static testMethod void validateCaseTrigger(){
        
        Contact con = new Contact(LastName='Test', MailingCity='Test', MailingState='NY',County__c='Test');
        insert con;
        
        Contact con2 = new Contact(LastName='Test2', MailingCity='Test2', MailingState='CA',County__c='Test2');
        insert con2;
        
        Case cs = new Case(ContactId=con.Id);
        insert cs;   
        
        List<CaseContactRole> ccr = [SELECT Id, CasesId, ContactId, Role FROM CaseContactRole WHERE CasesId =: cs.Id AND ContactId =: con.Id AND Role='Officer'];
        System.assertEquals(ccr.size(), 1);
        System.debug(ccr);
        
        cs.ContactId=con2.Id;
        update cs;
        
        List<CaseContactRole> ccr2 = [SELECT Id, CasesId, ContactId, Role FROM CaseContactRole WHERE CasesId =: cs.Id AND ContactId =: con2.Id AND Role='Officer'];
        System.assertEquals(ccr2.size(), 1);
        System.debug(ccr);
        
    }
    
    
}