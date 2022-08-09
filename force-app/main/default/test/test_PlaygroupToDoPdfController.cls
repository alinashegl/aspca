@isTest
public class test_PlaygroupToDoPdfController {
    @isTest
    static void getToDoPdf() {
        Animal__c a = TestDataFactory.createAnimal();
        a.Play_Category__c = 'Small Mellow';
        update a;

        User u = [SELECT Id, Location__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        u.Location__c = 'All';
        update u;

        PageReference toDoPdf = Page.PlaygroupToDoPdf;
        toDoPdf.getParameters().put('location', 'MRC');
        Test.setCurrentPage(toDoPdf);

        Test.startTest();
        PlaygroupToDoPdfController controller = new PlaygroupToDoPdfController();
        List<Animal__c> animals = controller.getAnimals();
        Test.stopTest();
        
        System.assertEquals(1, animals.size());
    }
}