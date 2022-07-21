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
@isTest()
private class TestClsEvidenceInformation {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
       
        case objCase = new Case(Status = 'On hold',Origin='Email',Agency_Case__c = 'test');
        insert objCase ;
        
        Animal__c objAnimal = new Animal__c(Case__c =objCase.id, Name='A-001-West',type_of_animal__c='Cat',breed__c='Coonhound',gender__c='MI',Animal_Age__c=12,Color__c='Brown',Intake_Date_Time__c= DateTime.now());
        insert objAnimal;
        
        RecordType rt = [select id,Name from RecordType where SobjectType='Evidence__c'  and Name='Animal Evidence'  Limit 1];
        
        Evidence__c objEvidence = new Evidence__c(recordTypeId=rt.id,Name= 'test',Case__c =objCase.id, Received_Date_Time__c = system.today(),Evidence_Description__c='test',Animal__c=objAnimal.id,Disposition_Date__c = system.today(),Evidence_Type__c='Fiber',Evidence_Category__c='Trace');
        insert objEvidence ;
        
        Evidence_Tracking__c objEvidenceTracking = new  Evidence_Tracking__c(Disposition__c = 'Destroyed',Disposition_Date__c= system.today(),Evidence_ID__c =objEvidence.id,Received_By__c='test' );
        insert objEvidenceTracking ;
        
        PageReference pageRef = Page.EvidenceInformation;
        Test.setCurrentPage(pageRef);
        apexpages.currentpage().getparameters().put('id' , objCase.id);
        apexpages.currentpage().getparameters().put('receiptId' , objEvidence.id);
       
         
        //ClsEvidenceInformation.EvidenceWrapper objwrapper = new ClsEvidenceInformation.EvidenceWrapper(objEvidence);
        //objwrapper.isSelected = true;
        
        //system.assertEquals(objwrapper.isSelected, true);
        
        ClsEvidenceInformation objClsEvidenceInformation = new ClsEvidenceInformation();
        objClsEvidenceInformation.objEvidenceCategory = objEvidence;
        
        System.assert(objClsEvidenceInformation.lstWrpperEvidence[0].isSelected==false);
        
        objClsEvidenceInformation.lstWrpperEvidence[0].isSelected=true;
        List<Evidence__c > lstEvidence = objClsEvidenceInformation.getlstEvidence();
        pageRef  = objClsEvidenceInformation.CallFullReport();
        
        objClsEvidenceInformation.search();
        objClsEvidenceInformation.BackToCase();
        objClsEvidenceInformation.getlstEvidence();
        objClsEvidenceInformation.CallFullReport();
        
        objEvidence.Disposition_Date__c = null;
        update objEvidence;
        objClsEvidenceInformation.search();
        
        objEvidence.Evidence_Category__c = null;
        objEvidence.Evidence_Type__c = null;
        update objEvidence;
        objClsEvidenceInformation.search();
        
        objEvidence.Evidence_Category__c = 'trace';
        objEvidence.Evidence_Type__c = null;
        update objEvidence;
        objClsEvidenceInformation.search();
        
     }
}