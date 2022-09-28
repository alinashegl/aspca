@isTest
private class test_SessionProtocolDomain {
    @isTest 
    static void beforeUpdate_isSkipped(){
        Session_Protocol_Scale__c scale = TestDataFactory.createSessionProtocolScales()[0];
        Session_Protocol__c sProtocol = [
            SELECT Id, Overall_Score__c, IsSkipped__c, Preferred_Motivators__c,
            ( SELECT Id, Protocol_Score__c, Protocol_Scale__r.Options__c
                FROM Session_Protocol_Scales__r
            )
            FROM Session_Protocol__c
            WHERE Id = :scale.Session_Protocol__c
            LIMIT 1
        ];
        Session_Protocol_Scale__c[] scales = new Session_Protocol_Scale__c[0];        
        for(Session_Protocol_Scale__c sps : sProtocol.Session_Protocol_Scales__r){
            String[] options = sps.Protocol_Scale__r.Options__c.split(';');
            sps.Protocol_Score__c = options[getRandomNumber(options.size())];
            scales.add(sps);
        }
        
        update scales;

        sProtocol.Overall_Score__c = '1. Beginning/Acquisition';
        sProtocol.Preferred_Motivators__c = 'Newspaper';
        update sProtocol;

        Test.startTest();
            sProtocol.IsSkipped__c = true;
            update sProtocol;
        Test.stopTest();

        Session_Protocol__c updatedSP = [
            SELECT Id, Overall_Score__c, IsSkipped__c, Preferred_Motivators__c, TreatmentSessionId__r.Session_Date__c,
            ( SELECT Id, Protocol_Scale_Name__c,  Protocol_Score_Number__c, Protocol_Score__c
                FROM Session_Protocol_Scales__r
            )
            FROM Session_Protocol__c
            WHERE Id = :sProtocol.Id
            LIMIT 1
        ];

        System.debug('updatedSP: ' +  updatedSP);

        System.assertEquals(null, updatedSP.Overall_Score__c);
        System.assertEquals(null, updatedSP.Preferred_Motivators__c);
        System.assertEquals(true, updatedSP.IsSkipped__c);

        for(Session_Protocol_Scale__c updatedScales : updatedSP.Session_Protocol_Scales__r){
            System.assertEquals(null, updatedScales.Protocol_Score__c);    
        }

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

    private static Integer getRandomNumber(Integer max){
        Double randomNumber = Math.random(); 
        Integer randomIndex = (randomNumber *(max-1)).intValue(); 
        //Output the element at the list index generated above
        return randomIndex;
    }
}