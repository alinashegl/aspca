@isTest 
private class Test_ProtocolDomain {
    @isTest 
    static void Test_InsertProtocolsSuccess() {
        Integer pScaleCount = 3;
        Protocol_Scale__c[] pScales = TestDataFactory.createProtocolScales(pScaleCount);

        test.startTest();
        Protocol__c[] protocols = TestDataFactory.createProtocols();
        test.stopTest();

        Protocol_Scale_Junction__c[] scaleJunctions = [SELECT Id FROM Protocol_Scale_Junction__c];
        System.assertEquals(pScaleCount * protocols.size(), scaleJunctions.size());
    }

    @isTest 
    static void Test_InsertProtocolsNoScales(){
        test.startTest();
        Protocol__c[] protocols = TestDataFactory.createProtocols();
        test.stopTest();

        Protocol_Scale_Junction__c[] scaleJunctions = [SELECT Id FROM Protocol_Scale_Junction__c];
        System.assert(scaleJunctions.isEmpty(), 'No scale junctions should have been created, but query returned: ' + scaleJunctions);
    }
}
