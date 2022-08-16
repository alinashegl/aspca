@isTest
private class Test_ProtocolSelector {
    @TestSetup
    static void setupData(){
        Treatment_Plan__c tPlan = TestDataFactory.createPlan();
    }

    @isTest 
    static void GetByIdSuccess() {
        Protocol__c[] protocols = [SELECT Id FROM Protocol__c];

        Set<Id> protocolIds = new Set<Id>();
        for(Protocol__c proto : protocols){
            protocolIds.add(proto.Id);
        }

        test.startTest();
            ProtocolSelector selector = new ProtocolSelector();
            Protocol__c[] returnedProtos = selector.GetById(protocolIds);
        test.stopTest();

        System.assertNotEquals(null, returnedProtos);
        System.assertEquals(protocols.size(), returnedProtos.size());
    }

    @isTest 
    static void GetByNameSuccess() {
        Protocol__c protocol = [SELECT Id, Name FROM Protocol__c LIMIT 1];

        test.startTest();
            ProtocolSelector selector = new ProtocolSelector();
            Protocol__c[] returnedProtos = selector.GetByName(protocol.Name);
        test.stopTest();

        System.assertNotEquals(null, returnedProtos);
        System.assertEquals(protocol.Id, returnedProtos[0].Id);
    }

    @isTest 
    static void GetByPlanSuccess() {
        Protocol__c[] protocols = [SELECT Id, Name FROM Protocol__c];
        Treatment_Plan__c plan = [SELECT Id FROM Treatment_Plan__c LIMIT 1];

        test.startTest();
            ProtocolSelector selector = new ProtocolSelector();
            Protocol__c[] returnedProtos = selector.getByPlan(plan.Id);
        test.stopTest();

        System.assertNotEquals(null, returnedProtos);
        System.assertEquals(protocols.size(), returnedProtos.size());
    }

    @isTest 
    static void getProtocolWithChildProtocolScaleJunctionByIdsSuccess(){
        Protocol__c[] protocols = [SELECT Id FROM Protocol__c];

        Set<Id> protocolIds = new Set<Id>();
        for(Protocol__c proto : protocols){
            protocolIds.add(proto.Id);
        }

        test.startTest();
            ProtocolSelector selector = new ProtocolSelector();
            Protocol__c[] returnedProtos = selector.getProtocolWithChildProtocolScaleJunctionByIds(protocolIds);
        test.stopTest();

        System.assertNotEquals(null, returnedProtos);
        System.assertEquals(protocols.size(), returnedProtos.size());
    }
}