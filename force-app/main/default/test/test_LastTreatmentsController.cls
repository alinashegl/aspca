@isTest
public with sharing class test_LastTreatmentsController {
    @isTest
    static void getRecords() {
        List<Session_Protocol__c> spList = TestDataFactory.createSessionProtocols();
        Test.startTest();
        List<Session_Protocol__c> contList = LastTreatmentsController.getLastTreatments(spList[0].TreatmentSessionId__r.Treatment_Plan__c, spList[0].ProtocolId__c, 5);
        Test.stopTest();
        System.assertEquals(1, contList.size());
        System.assertEquals(spList[0].Id, contList[0].Id);
    }
}