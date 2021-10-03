@isTest
private class test_SessionProtocolService {
    @isTest 
    static void handleValidty_Test(){
        Session_Protocol__c[] sProtocols = TestDataFactory.createSessionProtocols();
        Session_Protocol__c[] sProtocolsWithNames = [SELECT Id, ProtocolId__r.Name FROM Session_Protocol__c WHERE Id =: sProtocols];
        ServiceRequest request = new ServiceRequest();
        request.withParams('treatmentSession', new Treatment_Session__c(Id = sProtocols[0].TreatmentSessionId__c));

        test.startTest();
            ServiceResponse response = SessionProtocolService.handleValidity(request);
        test.stopTest();

        System.debug('response: ' + response);
        Map<String,Map<String,String>> responseMap = (Map<String,Map<String,String>>)response.data;

        System.debug('sProtocol.Name: ' + sProtocolsWithNames[0].ProtocolId__r.Name);
        System.debug('response: ' + responseMap.keySet());
        System.debug('response: ' + responseMap.get(sProtocolsWithNames[0].ProtocolId__r.Name));
    }
}
