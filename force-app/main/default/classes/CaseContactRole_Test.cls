@isTest (SeeAllData = true) public class CaseContactRole_Test {
    
    public static testMethod void CCTest(){
        
        Case cs = new Case();
        insert cs;
        
        Contact c = new Contact(LastName='Test', MailingCity='Test', MailingState='Test',County__c='Test');
        insert c;
        ApexPages.StandardController sc = new ApexPages.standardController(c);
        CaseContactRole_ContactsExt e = new CaseContactRole_ContactsExt(sc);
        System.assertEquals(e.cntct, c);
        
        List<CaseContactRole> cr = new List<CaseContactRole>();
        CaseContactRole ccr = new CaseContactRole(ContactId = c.Id, CasesId = cs.Id, Role = 'Subject');
        cr.add(ccr);
        e.relcases.add(ccr);
//        System.assertEquals(e.relcases, cr);
        
        
         
    }
    
    

}