@isTest
public class test_PlaygroupToDoPdfController {
    @isTest
    static void getToDoPdf() {
        Animal__c a = TestDataFactory.createAnimal();
        a.Play_Category__c = 'Small Mellow';
        update a;

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