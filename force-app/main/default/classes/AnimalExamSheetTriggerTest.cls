@isTest
public class AnimalExamSheetTriggerTest {

    @testSetup
    static void setupData(){
        
        Case cs = new Case();
        insert cs;
        
        Contact con = new Contact(LastName='Test', MailingCity='Test', MailingState='AK',MailingCountry='United States');
        insert con;
        
        Contact con2 = new Contact(LastName='Test2', MailingCity='Test2', MailingState='AK',MailingCountry='United States', Contact_Type__c='Behavior Case Worker', Email='test5@domain.com');
        insert con2;
        
        Animal__c anim = new Animal__c(Name='Test', Case__c=cs.Id, Behavior_Case_Worker__c=con2.Id,Discharged_to_Contact__c=con.Id,Type_of_Animal__c = 'Dog',Age__c='Unknown At Intake');
        insert anim;
        
        Id devRecordTypeId = Schema.SObjectType.Animal_Exam_Sheet__c.getRecordTypeInfosByName().get('Behavior Exam').getRecordTypeId();


        Animal_Exam_Sheet__c objAnimalExam = new Animal_Exam_Sheet__c (Subjective__c = 'Test', Species_PL__c  = 'Dog', Sex__c = 'FS', recordtypeId = devRecordTypeId,Exam_Type__c = 'Storm Distress/Anxiety', Animal__c =anim.id,Heartworm__c=true,FIV__c=true,FIV_Results__c='FIVResult',Heartworm_Results__c='heartwormResult',Babesia__c=true,Babesia_Results__c='babesiaResult',Felv_FIV_Results__c='FelvFIV',Include_in_discharge__c ='Yes',Editor__c='AS');
        insert objAnimalExam;
        
    }
    
    @isTest
    static void testFlags(){
        Animal__c anim = [Select Id,Storm_Distress_Anxiety__c,Storm_Distress_Anxiety_Notes__c,Behavior_Medication_Flag__c, Behavior_Medication_Data_Time__c FROM Animal__c];
        System.assertEquals(anim.Storm_Distress_Anxiety__c,true);
        System.assertNotEquals(anim.Storm_Distress_Anxiety_Notes__c,null);
        
        Animal_Exam_Sheet__c objAnimalExam = [Select Exam_Type__c from Animal_Exam_Sheet__c];
        objAnimalExam.Exam_Type__c = 'Behavior Medications';
        update objAnimalExam;
        
        Animal__c updatedAnimal = [Select Id,Storm_Distress_Anxiety__c,Storm_Distress_Anxiety_Notes__c,Behavior_Medication_Flag__c, Behavior_Medication_Data_Time__c FROM Animal__c];
        System.assertEquals(updatedAnimal.Behavior_Medication_Flag__c, true);
        System.assertNotEquals(updatedAnimal.Behavior_Medication_Data_Time__c, null);
    }
}