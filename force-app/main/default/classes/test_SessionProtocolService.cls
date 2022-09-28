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

        Map<String,Map<String,String>> responseMap = (Map<String,Map<String,String>>)response.data;

        for(String protocolName : responseMap.keySet()){
            Map<String, String> resultMap = responseMap.get(protocolName);
            for(String field : resultMap.keySet()){
                System.assertEquals('INVALID', resultMap.get(field));
            }
        }
    }

    @isTest 
    static void afterInsertHandlerSuccess(){
        Treatment_Session__c session = TestDataFactory.createSession();
        Protocol__c proto = [SELECT Id FROM Protocol__c LIMIT 1];

        test.startTest();
        Session_Protocol__c sp = new Session_Protocol__c(
            ProtocolId__c  = proto.Id,
            TreatmentSessionId__c = session.Id,
            Add_to_Plan__c = true
        );

        insert sp;
        test.stopTest();

        Session_Protocol_Scale__c[] scales = [SELECT Id FROM Session_Protocol_Scale__c WHERE Session_Protocol__c = :sp.Id];
        System.assertNotEquals(null, scales);
        System.assertEquals(9, scales.size());
    }

    @isTest 
    static void updateHandlerSuccess(){
        Treatment_Session__c session = TestDataFactory.createSession();
        Protocol_Scale__c[] pScales = TestDataFactory.createProtocolScales(1);
        Protocol__c proto = [SELECT Id FROM Protocol__c LIMIT 1];
        Protocol_Scale_Junction__c psj = new Protocol_Scale_Junction__c(
            Protocol__c = proto.Id,
            Protocol_Scale__c = pScales[0].Id
        );
        insert psj;

        Session_Protocol__c sp = new Session_Protocol__c(
            ProtocolId__c  = proto.Id,
            TreatmentSessionId__c = session.Id
        );

        insert sp;

        test.startTest();
        sp.Add_To_Plan__c = true;
        update sp;
        test.stopTest();

        Plan_Protocol__c[] pProtocols = [SELECT Id FROM Plan_Protocol__c WHERE Protocol__c = :proto.Id];
        //todo: find the correct assertion
        System.assertNotEquals(null, pProtocols);
        System.assertEquals(1, pProtocols.size());

    }
}