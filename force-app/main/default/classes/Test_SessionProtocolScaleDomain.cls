@isTest
private class Test_SessionProtocolScaleDomain {
    @isTest 
    static void updateSessionProtocolScaleSuccess() {
        Session_Protocol_Scale__c[] spsList = TestDataFactory.createSessionProtocolScales();
        spsList = [SELECT Id, Protocol_Scale_Name__c, Protocol_Score__c, Session_Protocol__c FROM Session_Protocol_Scale__c WHERE Id IN :spsList];
        System.debug('**spsList: ' + spsList);

        for(Session_Protocol_Scale__c sps : spsList){
            if(sps.Protocol_Scale_Name__c == 'Overall Score'){
                sps.Protocol_Score__c = '1. Beginning/Acquisition';
            }
        }
        Test.startTest();
            update spsList;
        Test.stopTest();

        Session_Protocol__c sp = [SELECT Id, Overall_Score__c FROM Session_Protocol__c WHERE Id = :spsList[0].Session_Protocol__c LIMIT 1];
        System.assertNotEquals(null, sp);
        System.assertEquals('1. Beginning/Acquisition', sp.Overall_Score__c);
    }

    @isTest 
    static void updateSessionProtocolScaleNotOverallScore() {
        Session_Protocol_Scale__c[] spsList = TestDataFactory.createSessionProtocolScales();
        spsList = [SELECT Id, Protocol_Scale_Name__c, Protocol_Score__c, Session_Protocol__c FROM Session_Protocol_Scale__c WHERE Id IN :spsList];
        System.debug('**spsList: ' + spsList);

        for(Session_Protocol_Scale__c sps : spsList){
            if(sps.Protocol_Scale_Name__c != 'Overall Score'){
                sps.Protocol_Score__c = '1 test score';
            }
        }
        Test.startTest();
            update spsList;
        Test.stopTest();

        Session_Protocol__c sp = [SELECT Id, Overall_Score__c FROM Session_Protocol__c WHERE Id = :spsList[0].Session_Protocol__c LIMIT 1];
        System.assertNotEquals(null, sp);
        System.assertEquals(null, sp.Overall_Score__c);
    }
}