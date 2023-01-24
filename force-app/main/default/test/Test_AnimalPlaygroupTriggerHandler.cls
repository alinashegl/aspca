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
        TestDataFactory.createPlaygroupSessionWithAnimals();
        for(String st : animalNames){
            TestDataFactory.createAnimalWithName(st);
        }
    }
    @isTest static void newPGSession() {
        Playgroup_Session__c ps = [SELECT Id FROM Playgroup_Session__c LIMIT 1];

        Animal_Playgroup__c[] apgs = new Animal_Playgroup__c[0];
        for(Animal__c anim : [SELECT Id FROM Animal__c]){
            apgs.add( new Animal_Playgroup__c(
                Animal__c = anim.Id,
                Playgroup_Session__c = ps.Id
            ));
        }
        
        test.startTest();
            insert apgs;
        test.stopTest();

        
    }   
}