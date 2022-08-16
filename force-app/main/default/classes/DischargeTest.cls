@isTest
private class DischargeTest {

    static testMethod void unitTest(){
        
        Case cs = new Case();
        insert cs;  
        
        Discharge objDischarge  = new Discharge (new ApexPages.StandardController(cs));
        
        Animal__c objAnimal = new Animal__c(Name='Test', Case__c=cs.Id, Type_of_Animal__c = 'Dog', Gender__c = 'Unknown', Age__c = 'Unknown At Intake', Color__c = 'Black');
        insert objAnimal;
        
        PageReference pageRef = Page.Animal_Discharge;
        Test.setCurrentPage(pageRef);
        apexpages.currentpage().getparameters().put('Id' , objAnimal.id);
        
        RecordType treatmentType = [SELECT ID FROM RecordType WHERE Name = 'Treatments' AND SObjectType = 'Task' LIMIT 1];
       	ID treatmentID = treatmentType.ID;
        
        Animal_Exam_Sheet__c objAnimalExam = new Animal_Exam_Sheet__c (Animal__c =objAnimal.id,Heartworm__c=true,FIV__c=true,FIV_Results__c='FIVResult',Heartworm_Results__c='heartwormResult',Babesia__c=true,Babesia_Results__c='babesiaResult',Felv_FIV_Results__c='FelvFIV',Include_in_discharge__c ='Yes',Editor__c='AS');
        insert objAnimalExam;
        
        Task objTask1 = new Task (WhatId = objAnimal.id, RecordTypeId = treatmentID, Animal_Exam_Sheet_Lookup__c=objAnimalExam.id, Editor__c='AS', Include_in_discharge__c='Yes', ActivityDate=Date.newInstance(2021, 10, 8), Subject='Treatment Dread', Status='In Progress');
        insert objTask1;
        
        Task objTask2 = new Task (WhatId = objAnimal.id, RecordTypeId = treatmentID, Animal_Exam_Sheet_Lookup__c=objAnimalExam.id, Editor__c='AS', Include_in_discharge__c='Yes', ActivityDate=Date.newInstance(2021, 10, 17), Subject='Treatment Wedding', Status='Completed', Completed_By_Text__c='AH');
        insert objTask2;
        
        Task objTask3 = new Task (WhatId = objAnimal.id, RecordTypeId = treatmentID, Animal_Exam_Sheet_Lookup__c=objAnimalExam.id, Editor__c='AS', Include_in_discharge__c='Yes', ActivityDate=Date.newInstance(2021, 10, 20), Subject='Treatment Honeymoon', Status='In Progress');
        insert objTask3;
        
        Task objTask4 = new Task (WhatId = objAnimal.id, RecordTypeId = treatmentID, Animal_Exam_Sheet_Lookup__c=objAnimalExam.id, Editor__c='AS', Include_in_discharge__c='Yes', ActivityDate=Date.newInstance(2021, 10, 21), Subject='Treatment Honeymoon', Status='In Progress');
        insert objTask4;
        
        Task objTask5 = new Task (WhatId = objAnimal.id, RecordTypeId = treatmentID, Animal_Exam_Sheet_Lookup__c=objAnimalExam.id, Editor__c='AS', Include_in_discharge__c='Yes', ActivityDate=Date.newInstance(2021, 10, 27), Subject='Treatment Honeymoon', Status='Completed', Completed_By_Text__c='AH');
        insert objTask5;
        
        Task objTask6 = new Task (WhatId = objAnimal.id, RecordTypeId = treatmentID, Animal_Exam_Sheet_Lookup__c=objAnimalExam.id, Editor__c='AS', Include_in_discharge__c='Yes', ActivityDate=Date.newInstance(2021, 10, 28), Subject='Treatment Honeymoon', Status='Completed', Completed_By_Text__c='AH');
        insert objTask6;
        
        Medical_Conditions__c objMedCon = new Medical_Conditions__c(Animal__c=objAnimal.Id, Date_Diagnosed__c = System.Today(), Include_in_discharge__c = 'Yes');
        insert objMedCon;
        
        Diagnostic__c diag = new Diagnostic__c(Animal__c=objAnimal.Id, Animal_Exam_Sheet__c=objAnimalExam.Id, Include_in_discharge__c = 'Yes', Date__c = System.Today(), Test_Name__c = 'CBC');
        insert diag;
        
                
        System.assertEquals(1, objDischarge.examSheets.size());
		System.assertEquals(6, objDischarge.tsks.size());
		System.assertEquals(1, objDischarge.medCons.size());
        System.assertEquals(1, objDischarge.diags.size());
        System.assertEquals(3, objDischarge.currentTasks.size());
        System.assertEquals(3, objDischarge.pastTasks.size());

    }
    
}