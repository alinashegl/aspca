@isTest
private class TestVaccineCert {

    static testMethod void unitTest(){
        
        Case cs = new Case();
        insert cs;  
        
        VaccineCert_Controller objVaccineCert  = new VaccineCert_Controller (new ApexPages.StandardController(cs));
        
        Animal__c objAnimal = new Animal__c(Name='Test', Case__c=cs.Id, Type_of_Animal__c = 'Dog', Gender__c = 'Unknown', Age__c = 'Unknown At Intake', Color__c = 'Black');
        insert objAnimal;
        
        PageReference pageRef = Page.VaccineCert;
        Test.setCurrentPage(pageRef);
        apexpages.currentpage().getparameters().put('Id' , objAnimal.id);
        
        Animal_Exam_Sheet__c objAnimalExam = new Animal_Exam_Sheet__c (Animal__c =objAnimal.id,Heartworm__c=true,FIV__c=true,FIV_Results__c='FIVResult',Heartworm_Results__c='heartwormResult',Babesia__c=true,Babesia_Results__c='babesiaResult',Felv_FIV_Results__c='FelvFIV',Include_in_discharge__c ='Yes',Editor__c='AS');
        insert objAnimalExam;
        
        Vaccine_and_Preventative__c objVacc = new Vaccine_and_Preventative__c (Animal__c =objAnimal.id,Animal_Exam_Sheet__c=objAnimalExam.id);
        insert objVacc;
        
        String docName = 'Test';
        objVaccineCert.setDoc(docName);
        objVaccineCert.getDoc();
  
		System.assertEquals(1, objVaccineCert.vaccs.size());

        objVaccineCert.genCert();
    }
    
}