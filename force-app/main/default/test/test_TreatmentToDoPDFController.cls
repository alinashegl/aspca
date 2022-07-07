@isTest
private  class test_TreatmentToDoPDFController {
    @isTest 
    static void TreatmentToDoPDFController_hasData(){
        //create treatment plan, pan protocols, animla, etc
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
