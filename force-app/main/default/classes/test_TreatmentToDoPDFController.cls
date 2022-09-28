@isTest
private  class test_TreatmentToDoPDFController {
    @isTest 
    static void TreatmentToDoPDFController_hasData(){
        User u = [SELECT Id, Location__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        u.Location__c = 'All';
        update u;

        //create treatment plan, pan protocols, animal, etc
        TestDataFactory.createPlanProtocols(2);

        test.startTest();
        TreatmentToDoPDFController pdfController = new TreatmentToDoPDFController();
        TreatmentToDoPDFController.TreatmentPlanWithProtocols[] plansWithProtocols = pdfController.treatmentPlansWithProtocols;
        test.stopTest();

        System.assert(!plansWithProtocols.isEmpty(), 'Should not have returned an empty list');
        System.assert(plansWithProtocols[0].treatmentPlan != null, 'Should have returned a treatment plan for the first itme in the list');
        System.assert(plansWithProtocols[0].protocols != null, 'Should have returned protocols for the first itme in the list');
    }

    @isTest
    static void TreatmentToDoPDFController_noData(){

        test.startTest();
        TreatmentToDoPDFController pdfController = new TreatmentToDoPDFController();
        TreatmentToDoPDFController.TreatmentPlanWithProtocols[] plansWithProtocols = pdfController.treatmentPlansWithProtocols;
        test.stopTest();

        System.assert(plansWithProtocols.isEmpty(), 'Should have returned an empty list, instead was: ' + plansWithProtocols);
    }
}