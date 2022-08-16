@isTest
private class test_SessionProtocolDomain {
    @isTest 
    static void beforeUpdate_isSkipped(){
        Session_Protocol__c sp = TestDataFactory.createSessionProtocols()[0];

        sp.Preferred_Motivators__c = 'newspaper';
        sp.Arousal_Best__c = '2. Mild';
        sp.Arousal_Worst__c = '2. Mild';
        sp.Fear_Best__c = '2. Neutral';
        sp.Fear_Worst__c = '2. Neutral';
        sp.Social_Best__c = '1. Solicitation, sustained proximity';
        sp.Aggressive_Worst__c = '2. Hard stare, whale eye, rigid, freezes';
        sp.Overall_Score__c = '2. Catching On/ Fluency';
        update sp;

        Test.startTest();
            sp.IsSkipped__c = true;
            update sp;
        Test.stopTest();

        Session_Protocol__c updatedSP = [
            SELECT 
                Id,
                Aggressive_Worst__c,
                Arousal_Best__c,
                Arousal_Worst__c,
                Fear_Best__c,
                Fear_Worst__c,
                IsSkipped__c,
                Social_Best__c,
                Overall_Score__c,
                Preferred_Motivators__c
            FROM Session_Protocol__c
            WHERE Id =: sp.Id 
            LIMIT 1
        ];

        System.assertEquals(null, updatedSP.Aggressive_Worst__c);
        System.assertEquals(null, updatedSP.Arousal_Best__c);
        System.assertEquals(null, updatedSP.Arousal_Worst__c);
        System.assertEquals(null, updatedSP.Fear_Best__c);
        System.assertEquals(null, updatedSP.Fear_Worst__c);        
        System.assertEquals(null, updatedSP.Social_Best__c);
        System.assertEquals(null, updatedSP.Overall_Score__c);
        System.assertEquals(null, updatedSP.Preferred_Motivators__c);
        System.assertEquals(true, updatedSP.IsSkipped__c);
    }

    @isTest 
    static void beforeUpdate_addToPlan(){
        Treatment_Session__c session = TestDataFactory.createSession();
        Protocol__c protocol = new Protocol__c(
            Name = 'Test Protocol',
            IsActive__c = true
        );
        insert protocol;

        Session_Protocol__c sp = new Session_Protocol__c(
            ProtocolId__c = protocol.Id,
            TreatmentSessionId__c = session.Id
        );
        insert sp;

        Test.startTest();
            sp.Add_To_Plan__c = true;
            update sp;
        Test.stopTest();

        Plan_Protocol__c pr = [SELECT Id, Protocol__c FROM Plan_Protocol__c WHERE Treatment_Plan__c =: session.Treatment_Plan__c AND Protocol__c =: protocol.Id LIMIT 1];

        System.assert(pr != null, 'a Plan Protocol should have been returned');
        System.assertEquals(protocol.Id, pr.Protocol__c);
    }

    @isTest 
    static void beforeUpdate_removeFromPlan(){
        Session_Protocol__c protocol = TestDataFactory.createSessionProtocols()[0];
        Treatment_Session__c session = [SELECT Id, Treatment_Plan__c FROM Treatment_Session__c WHERE Id =: protocol.TreatmentSessionId__c LIMIT 1];
        Plan_Protocol__c pr = new Plan_Protocol__c(
            Protocol__c = protocol.ProtocolId__c,
            Treatment_Plan__c = session.Treatment_Plan__c
        );

        insert pr;

        Test.startTest();
            protocol.IsRemoved__c = true;
            update protocol;
        Test.stopTest();

        Plan_Protocol__c updatedPr = [SELECT Id, Protocol__c, IsRemoved__c FROM Plan_Protocol__c WHERE Id =: pr.Id LIMIT 1];
        System.assertEquals(true, updatedPr.IsRemoved__c);
    }    
}