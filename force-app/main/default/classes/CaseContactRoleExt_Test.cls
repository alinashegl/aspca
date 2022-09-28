@istest
private class CaseContactRoleExt_Test
{
  static testMethod void ReportTest() {
     //Creating the case object  
      Case newCaseObj = new case(Category__C = 'Consultation',Status = 'New',CASE_STATUS_SUBTYPE__c = 'Placement', Investigator__c = 'Terry Mills',Origin = 'Phone');
      insert newCaseObj;
     
     //Creating Contact obj for Case Contact Role 
      Contact con = new Contact(FirstName = 'testName', LastName = 'lName',MailingCity = 'testCity', MailingState='testState');
      insert con;
      
     //Creating multiple Case Contact Role objects to cover Suspect and Complainant Role. 
      List<CaseContactRole> listCaseContactRole = new List<CaseContactRole>();
      CaseContactRole caseContactRoleObj1 = new CaseContactRole(CasesId = newCaseObj.Id, ContactId = con.Id, Role = 'Suspect/Defendant');
      listCaseContactRole.add(caseContactRoleObj1);
      CaseContactRole caseContactRoleObj2 = new CaseContactRole(CasesId = newCaseObj.Id, ContactId = con.Id, Role = 'Complainant');
      listCaseContactRole.add(caseContactRoleObj2);
      insert listCaseContactRole;
     
     //Instantiating the class 
      ApexPages.StandardController std = new ApexPages.StandardController(newCaseObj);
      ApexPages.currentPage().getParameters().put('Id', newCaseObj.id);
      CaseContactRoleExtension spObj = new CaseContactRoleExtension(std);
//      spObj.getrepeatDiv();
  }  
}