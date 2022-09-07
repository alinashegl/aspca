@isTest
public class TestAnimalExamSheetTrigger {

    static testMethod void validateAnimalExamSheetTrigger(){
        
        Case cs = new Case();
        insert cs;
        
        Animal__c anim = new Animal__c(Name='Test', Case__c=cs.Id, Type_of_Animal__c = 'Dog',Color__c='Black',Age__c='Unknown At Intake');
        
        insert anim;
        
        Id ExamRecordTypeId = Schema.SObjectType.Animal_Exam_Sheet__c.getRecordTypeInfosByName().get('Canine Forensics Exam Sheet').getRecordTypeId();
        system.debug(ExamRecordTypeId);

        
        Animal_Exam_Sheet__c aes = new Animal_Exam_Sheet__c(Animal__c = anim.Id, RecordTypeId=ExamRecordTypeId,Sex__c='Unknown',Editor__c='test',Breed_Text__c='test',Primary_Color__c='Black',Microchip_Results__c='Positive',Microchip_Number__c='123456',Forensic_Status__c='Released from Forensic Hold',Forensic_Hold_Release_Date__c=Date.newInstance(2017, 10, 17),Forensic_Hold_Released_By__c='Alec Hauser');

        insert aes;
        System.debug('Value: ' + aes.Forensic_Status__c);        
        
    }
    

    
    
}