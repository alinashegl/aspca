@iSTest 
private class Test_AnimalPlaygroupTriggerHandler {
    private static String[] animalNames = new String[]{
        'Fido',
        'Willow',
        'AJ',
        'Apollo'
    };

    @TestSetup
    static void testSetup(){
        Playgroup_Session__c ps = TestDataFactory.createPlaygroupSessionWithAnimals();
        for(String st : animalNames){
            TestDataFactory.createAnimalWithName(st);
        }

        Animal_Playgroup__c[] apgs = new Animal_Playgroup__c[0];
        for(Animal__c anim : [SELECT Id FROM Animal__c]){
            apgs.add( new Animal_Playgroup__c(
                Animal__c = anim.Id,
                Playgroup_Session__c = ps.Id
            ));
        }
 
        insert apgs;
    }

    @isTest static void addDogToSession() {
        Playgroup_Session__c ps = [SELECT Id FROM Playgroup_Session__c LIMIT 1];

        Animal_Playgroup__c[] apgs = new Animal_Playgroup__c[0];
        Animal__c newAnimal = TestDataFactory.createAnimalWithName('New Dog');
        
        Test.startTest();
        insert new Animal_Playgroup__c(
            Animal__c = newAnimal.Id,
            Playgroup_Session__c = ps.Id
        );
        Test.stopTest();

        animalNames.add('New Dog');

        for(Animal_Playgroup__c apg : [SELECT Id, Animal_Name__c, Other_Dogs__c FROM Animal_Playgroup__c]){
            System.assertEquals(true, apg.Other_Dogs__c != null, 'Other Dogs on Animal Playgroup should be populated, but was null');
            for(String aName : animalNames){
                if(aName == apg.Animal_Name__c){
                    System.assertEquals(false, apg.Other_Dogs__c.contains(aName), 'List of other dogs shold not include dog related to Animal_Playgroup');
                } else {
                    System.assertEquals(true, apg.Other_Dogs__c.contains(aName), 'List of other dogs should include ' + aName + ', but did not');
                }
            }
        }

    }

    @isTest static void deleteAnimalPlaygroup() {

        Animal_Playgroup__c apgToDelete = [SELECT Id FROM Animal_Playgroup__c WHERE Animal_Name__c = 'Willow' LIMIT 1];
        test.startTest();
        delete apgToDelete;
        test.stopTest();

        for(Animal_Playgroup__c apg : [SELECT Id, Animal_Name__c, Other_Dogs__c FROM Animal_Playgroup__c]){
            System.assertEquals(true, apg.Other_Dogs__c != null, 'Other Dogs on Animal Playgroup should be populated, but was null');
            System.assertEquals(false, apg.Other_Dogs__c.contains('Willow'), 'Willow was deleted and should no longer be listed in the Other Dogs');
        }

    }
}