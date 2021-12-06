@isTest
public class test_Last5TreatmentsController {
    @isTest
    static void getLast5TreatmentsPdf() {
        List<Session_Protocol__c> spList = TestDataFactory.createSessionProtocols();
        Treatment_Plan__c plan = [SELECT Id, Animal__c FROM Treatment_Plan__c WHERE Id = :spList[0].TreatmentSessionId__r.Treatment_Plan__c LIMIT 1];

        PageReference last5Pdf = Page.Last5TreatmentsReport;
        last5Pdf.getParameters().put('animalId', plan.Animal__c);
        Test.setCurrentPage(last5Pdf);

        Test.startTest();
        Last5TreatmentsController controller = new Last5TreatmentsController();
        Map<Id, List<Session_Protocol__c>> sessionProtocolMap = controller.getSessionProtocolMap();
        Animal__c animal = controller.getAnimal();
        Test.stopTest();
        
        //Test data creates 4 protocols
        System.assertEquals(4, sessionProtocolMap.size());
        System.assertEquals(plan.Animal__c, animal.Id);
    }
}