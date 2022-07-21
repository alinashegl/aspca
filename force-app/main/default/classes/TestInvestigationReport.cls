/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@istest
private class TestInvestigationReport
{
  static testMethod void investigationReportTest() {
     //Creating new case obj
      Case newCaseObj = new case(Category__C = 'Consultation',Status = 'New',CASE_STATUS_SUBTYPE__c = 'Placement', Investigator__c = 'Terry Mills',Origin = 'Phone');
      insert newCaseObj;
      
     //Creating new contact for case contact role obj   
      Contact con = new Contact(FirstName = 'testName', LastName = 'lName',MailingCity = 'testCity', MailingState='testState');
      insert con;
      
     //Creating multiple case contact role obj to cover the cases for  Suspect and Complainant role.
      List<CaseContactRole> listCaseContactRole = new List<CaseContactRole>();
      CaseContactRole caseContactRoleObj1 = new CaseContactRole(CasesId = newCaseObj.Id, ContactId = con.Id, Role = 'Suspect');
      listCaseContactRole.add(caseContactRoleObj1);
      CaseContactRole caseContactRoleObj2 = new CaseContactRole(CasesId = newCaseObj.Id, ContactId = con.Id, Role = 'Complainant');
      listCaseContactRole.add(caseContactRoleObj2);
      insert listCaseContactRole;
      
     //Instantiating the class  
      ApexPages.StandardController std = new ApexPages.StandardController(newCaseObj);
      ApexPages.currentPage().getParameters().put('Id', newCaseObj.id);
      extInvestigationReport spObj1 = new extInvestigationReport();
      extInvestigationReport spObj = new extInvestigationReport(std);
      spObj.getrepeatDiv();
  }  
}