@isTest
private class dao_AnimalTest {
    @isTest 
    static void dao_AnimalTestFindAll() {
        Animal__c anim = TestDataFactory.createAnimal();

        test.startTest();
        dao_Animal daoAnimal = new dao_Animal();
        Animal__c[] anims = daoAnimal.findAll();
        test.stopTest();

        System.assertEquals(false, anims.isEmpty());
    }

    @isTest 
    static void dao_AnimalTestFindOne() {
        Animal__c anim = TestDataFactory.createAnimal();

        test.startTest();
        dao_Animal daoAnimal = new dao_Animal();
        Animal__c animReturned = daoAnimal.findOne(anim.Id);
        test.stopTest();

        System.assertEquals(false, animReturned == null);
    }
}