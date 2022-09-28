@isTest
private class Test_SessionProtocol {
    @isTest
    static void SessionProtocolTest() {
        Session_Protocol__c[] sProtos = TestDataFactory.createSessionProtocols();
        sProtos = [SELECT Id, TreatmentSessionId__r.Session_Date__c, 
            (SELECT Id, Name, Protocol_Score__c, Protocol_Score_Number__c, Protocol_Scale_Name__c
                FROM Session_Protocol_Scales__r
            )
            FROM Session_Protocol__c
            WHERE Id IN :sProtos
        ];

        test.startTest();
            SessionProtocol[] protocols = new SessionProtocol[0];
            for(Session_Protocol__c sProto : sProtos){
                protocols.add(new SessionProtocol(sProto));
            }
        test.stopTest();

        System.assertEquals(true, !protocols.isEmpty());
    }
}