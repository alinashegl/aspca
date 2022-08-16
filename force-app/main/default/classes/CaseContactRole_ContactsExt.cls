public class CaseContactRole_ContactsExt {
    
    public final Contact cntct;
    
    public CaseContactRole_ContactsExt(ApexPages.StandardController stdController) {
        this.cntct = (Contact)stdController.getRecord();
    }
    
    public List<CaseContactRole> relcases {
        get {
            return [SELECT Id, CasesId, Role
                   FROM CaseContactRole
                   WHERE ContactId = :cntct.Id];
        }
        set;
    }
    

    

}