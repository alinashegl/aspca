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
@isTest
private class TestAnimalPictureUploaderController {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        case objCase = new Case(Status = 'On hold',Origin='Email',Agency_Case__c = 'test');
        insert objCase ;
        
        Animal__c objAnimal = new Animal__c(Case__c =objCase.id, Name='A-001-West',type_of_animal__c='Cat',breed__c='Coonhound',gender__c='MI',Animal_Age__c=12,Color__c='Brown',Intake_Date_Time__c= DateTime.now());
        insert objAnimal;
        
        
        Attachment  objAttachment  = new Attachment (parentId=objAnimal.id,Name='test',body= Blob.valueof('test'));
        insert objAttachment ;
        
        
        PageReference pageRef = Page.AnimalPictureUploader;
        Test.setCurrentPage(pageRef);
        apexpages.currentpage().getparameters().put('cid' ,objAnimal.id);
        
        AnimalPictureUploaderController  objAnimalPictureUploaderController  = new AnimalPictureUploaderController ();
        objAnimalPictureUploaderController.initialise();
        
        
        }
   }