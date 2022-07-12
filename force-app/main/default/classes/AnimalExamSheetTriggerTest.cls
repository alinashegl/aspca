@isTest
public class AnimalExamSheetTriggerTest {

    @testSetup
    static void setupData(){
        
        Case cs = new Case();
        insert cs;
        
        Contact con = new Contact(LastName='Test', MailingCity='Test', MailingState='AK',County__c='Test');
        insert con;
        
        Contact con2 = new Contact(LastName='Test2', MailingCity='Test2', MailingState='AK',County__c='Test2', Contact_Type__c='Behavior Case Worker', Email='test5@domain.com');
        insert con2;
        
        Animal__c anim = new Animal__c(Name='Test', Case__c=cs.Id, Behavior_Case_Worker__c=con2.Id,Discharged_to_Contact__c=con.Id,Type_of_Animal__c = 'Dog',Age__c='Unknown At Intake');
        insert anim;
        
        Id devRecordTypeId = Schema.SObjectType.Animal_Exam_Sheet__c.getRecordTypeInfosByName().get('Behavior Exam').getRecordTypeId();


        Animal_Exam_Sheet__c objAnimalExam = new Animal_Exam_Sheet__c (Species_PL__c  = 'Dog', Sex__c = 'FS', recordtypeId = devRecordTypeId,Exam_Type__c = 'Storm Distress/Anxiety', Animal__c =anim.id,Heartworm__c=true,FIV__c=true,FIV_Results__c='FIVResult',Heartworm_Results__c='heartwormResult',Babesia__c=true,Babesia_Results__c='babesiaResult',Felv_FIV_Results__c='FelvFIV',Include_in_discharge__c ='Yes',Editor__c='AS');
        insert objAnimalExam;
        
        objAnimalExam.Exam_Type__c = 'Behavior Medications';
        
        //Animal_Exam_Sheet__c objAnimalExam2 = new Animal_Exam_Sheet__c (recordtypeId = devRecordTypeId,Exam_Type__c = 'Behavior Medications', Animal__c =anim.id,Heartworm__c=true,FIV__c=true,FIV_Results__c='FIVResult',Heartworm_Results__c='heartwormResult',Babesia__c=true,Babesia_Results__c='babesiaResult',Felv_FIV_Results__c='FelvFIV',Include_in_discharge__c ='Yes',Editor__c='AS');
        update objAnimalExam;
    }
    
    @isTest
    static void testFlags(){
        List<Animal_Exam_Sheet__c> aesList = new List<Animal_Exam_Sheet__c>();
        Animal__c a = [Select Id,Storm_Distress_Anxiety__c,Storm_Distress_Anxiety_Notes__c,Behavior_Medication_Flag__c, Behavior_Medication_Data_Time__c,(Select id, Subjective__c, Exam_Type__c  from Animal_Exam_Sheets__r WHERE RecordType.Name = 'Behavior Exam' Order By CreatedDate DESC) from Animal__c];
        for(Animal_Exam_Sheet__c aes : a.Animal_Exam_Sheets__r){
            aes.Subjective__c = 'Test';
            aesList.add(aes);
        }
        update aesList;
    }
}