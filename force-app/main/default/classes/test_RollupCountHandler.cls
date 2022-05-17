@isTest
private class test_RollupCountHandler {
    @isTest
    static void tesAnimalUpdatemethod(){
		Test.startTest();
        
		Animal__c animal = TestDataFactory.createAnimalWithName('TestDog');
		Animal__c animalData = [Select id,Days_in_Treatment__c from Animal__c where ID = :animal.id ];
        Treatment_Session__c session = TestDataFactory.createSessionWithAnimal(animal.Id);
        Treatment_Session__c session2 = TestDataFactory.createSessionWithAnimal(animal.Id);
        //Treatment_Session__c sessionData = [SELECT Id, Animal__c FROM Treatment_Session__c WHERE ID =: session.Id limit 1];	
		//sessionData.Animal__c =animalData.ID;	
        //update sessionData;
        Animal__c animalUpdatedData = [Select id,Days_in_Treatment__c from Animal__c where ID = :animal.id ];
        Test.stopTest();
        System.assertEquals(animalUpdatedData.Days_in_Treatment__c, 1);
    }	
    @isTest
    static void testDeleteTreatmentMethod(){
		Test.startTest();
        
		Animal__c animal = TestDataFactory.createAnimalWithName('TestDog3');
		Animal__c animalData = [Select id,Days_in_Treatment__c from Animal__c where ID = :animal.id ];
        Treatment_Session__c session = TestDataFactory.createSessionWithAnimal(animal.id);
         Treatment_Session__c session2 = TestDataFactory.createSessionWithAnimal(animal.id);
        //Treatment_Session__c session2 = TestDataFactory.createSession();
        Treatment_Session__c sessionData = [SELECT Id, Animal__c FROM Treatment_Session__c WHERE ID =: session.Id limit 1];	
		
        // Treatment_Session__c sessionData2 = [SELECT Id, Animal__c FROM Treatment_Session__c WHERE ID =: session2.Id limit 1];	
		// sessionData2.Animal__c =animalData.ID;	
        // update sessionData2;   
        Delete sessionData;
        Animal__c animalUpdatedData = [Select id,Days_in_Treatment__c from Animal__c where ID = :animal.id ];
        Test.stopTest();
        System.assertEquals(animalUpdatedData.Days_in_Treatment__c, 1);
    }	
      @isTest
    static void testUpdateTreatmentMethod(){
		Test.startTest();
        
		Animal__c animal = TestDataFactory.createAnimalWithName('TestDog'); 
        Animal__c animal2 = TestDataFactory.createAnimalWithName('TestDog2');
		
        Treatment_Session__c session = TestDataFactory.createSessionWithAnimal(animal.id);
        Treatment_Session__c sessionData = [SELECT Id, Animal__c FROM Treatment_Session__c WHERE ID =: session.Id limit 1];	
        Animal__c animalData = [Select id,Days_in_Treatment__c from Animal__c where ID = :animal2.id ];
		sessionData.Animal__c =animalData.ID;	
        update sessionData;
        // Animal__c animalData2 = [Select id,Days_in_Treatment__c from Animal__c where ID = :animal2.id ];
        // sessionData.Animal__c =animalData2.ID;	
        // update sessionData;
        
       
        Animal__c animalUpdatedData = [Select id,Days_in_Treatment__c from Animal__c where ID = :animal.id ];
        Test.stopTest();
        System.assertEquals(animalUpdatedData.Days_in_Treatment__c, 1);
    }	
}