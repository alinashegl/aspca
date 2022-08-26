@isTest
public with sharing class test_LastTreatmentsController {
    @isTest
    static void getRecords() {
        Treatment_Session__c session = TestDataFactory.createSession();
        // Session_Protocol__c proto = [SELECT Id FROM Session_Protocol__c WHERE TreatmentSessionId__c = :session.Id LIMIT 1];

        //score the session so it's complete:
        Session_Protocol__c[] spList = [
            SELECT Id, Overall_Score__c, ProtocolId__c,
            ( SELECT Id, Protocol_Score__c, Protocol_Scale__r.Options__c
                FROM Session_Protocol_Scales__r
            )
            FROM Session_Protocol__c
            WHERE TreatmentSessionId__c = :session.Id
            LIMIT 1
        ];

        Session_Protocol_Scale__c[] scales = new Session_Protocol_Scale__c[0];
        for(Session_Protocol__c sp : spList){
            sp.Overall_Score__c = '1. Beginning/Acquisition';
            for(Session_Protocol_Scale__c sps : sp.Session_Protocol_Scales__r){
                String[] options = sps.Protocol_Scale__r.Options__c.split(';');
                sps.Protocol_Score__c = options[getRandomNumber(options.size())];
                scales.add(sps);
            }
        }

        update spList;
        update scales;



        Test.startTest();
        List<SessionProtocol> contList = LastTreatmentsController.getLastTreatments(session.Treatment_Plan__c, spList[0].ProtocolId__c, 5);
        Test.stopTest();
        System.assertEquals(1, contList.size());
    }

    public static Integer getRandomNumber(Integer max){
        Double randomNumber = Math.random(); 
        Integer randomIndex = (randomNumber *(max-1)).intValue(); 
        //Output the element at the list index generated above
        return randomIndex;
    }
}