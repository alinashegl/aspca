@isTest
private class test_TreatmentSessionLWCController {
    @isTest
    static void getActiveProtocols_hasProtocols(){
        Session_Protocol_Scale__c[] sessionProtocolScales = TestDataFactory.createSessionProtocolScales();
        
        Treatment_Session__c session = [SELECT Id FROM Treatment_Session__c LIMIT 1];
        Session_Protocol__c[] sessionProtocols = [SELECT Id, TreatmentSessionId__c, (SELECT Id FROM Session_Protocol_Scales__r) FROM Session_Protocol__c];
        
        Test.startTest();
        TreatmentSessionLWCController.SessionInfo returnedInfo = TreatmentSessionLWCController.getActiveProtocolsForSession(session.Id);
        Test.stopTest();

        System.assertEquals(sessionProtocols.size(), returnedInfo.sessionProtocolInfos.size());
    }

    @isTest
    static void getActiveProtocols_noProtocols(){
        Treatment_Plan__c plan = new Treatment_Plan__c(
            Problem_Behavior__c = 'Fear of People - Mild'
        );

        insert plan;

        Contact con = TestDataFactory.createBehaviorCaseWorkerContact();

        Treatment_Session__c session = new Treatment_Session__c(
            Treatment_Plan__c = plan.Id,
            Session_Contact__c = con.Id
        );
        insert session;

        Test.startTest();
        TreatmentSessionLWCController.SessionInfo returnedInfo = TreatmentSessionLWCController.getActiveProtocolsForSession(session.Id);
        Test.stopTest();

        System.assert(returnedInfo != null, 'should have returned a session info with blank lists, but was null');
        System.assert(returnedInfo.requiredProtocols.isEmpty(), 'requiredProtocols should be an empty list, but was: ' + returnedInfo.requiredProtocols);
        System.assert(returnedInfo.sessionProtocolInfos.isEmpty(),'sessionProtocolInfos should be an empty list, but was: ' + returnedInfo.sessionProtocolInfos);
    }

    @isTest
    static void getChildList_hasContacts(){
        Session_Protocol_Contact__c[] sContacts = TestDataFactory.createSessionProtocolContact();

        Test.startTest();
            SObject[] returnedContacts = TreatmentSessionLWCController.getChildList(sContacts[0].Session_Protocol__c, 'Session_Protocol_Contact__c');
        Test.stopTest();

        Session_Protocol_Contact__c[] spsList = [SELECT Id FROM Session_Protocol_Contact__c WHERE Session_Protocol__c =: sContacts[0].Session_Protocol__c];

        System.assertEquals(spsList.size(), returnedContacts.size());
    }

    @isTest
    static void getChildList_invalidObjectApi(){
        Session_Protocol_Contact__c[] sContacts = TestDataFactory.createSessionProtocolContact();

        Test.startTest();
            SObject[] returnedContacts = TreatmentSessionLWCController.getChildList(sContacts[0].Session_Protocol__c, 'OpportunityContact');
        Test.stopTest();

        System.assert(returnedContacts.isEmpty());
    }

    @isTest
    static void getChildList_hasDogs(){
        Additional_Dog_Present__c[] aDogs = TestDataFactory.createAdditionalDogs();

        Test.startTest();
            SObject[] returnedDogs = TreatmentSessionLWCController.getChildList(aDogs[0].Session_Protocol__c, 'Additional_Dog_Present__c');
        Test.stopTest();

        System.assertEquals(1, returnedDogs.size());
    }

    @isTest
    static void getChildList_noChildren(){
        Session_Protocol__c[] protocolList = TestDataFactory.createSessionProtocols();

        Test.startTest();
            SObject[] returnedContacts = TreatmentSessionLWCController.getChildList(protocolList[0].Id, 'Additional_Dog_Present__c');
        Test.stopTest();

        System.assert(returnedContacts.isEmpty());
    }

    @isTest
    static void getProtocol_hasProtocol(){
        Session_Protocol__c[] protocolList = TestDataFactory.createSessionProtocols();

        Test.startTest();
            Session_Protocol__c returnedProtocol = TreatmentSessionLWCController.getProtocol(protocolList[0].Id);
        Test.stopTest();

        System.assert(returnedProtocol != null);
    }

    @isTest
    static void getProtocol_noProtocol(){
        Treatment_Session__c treatmentSession = TestDataFactory.createSession();

        Test.startTest();
            Session_Protocol__c returnedProtocol = TreatmentSessionLWCController.getProtocol(null);
        Test.stopTest();

        System.assert(returnedProtocol == null);
    }

    @isTest
    static void getActiveProtocolAndFieldsNew_hasProtocol(){
        // Session_Protocol__c[] protocolList = TestDataFactory.createSessionProtocols();
        
        Session_Protocol_Scale__c[] sessionProtocolScales = TestDataFactory.createSessionProtocolScales();
        
        // Treatment_Session__c session = [SELECT Id FROM Treatment_Session__c LIMIT 1];
        Session_Protocol__c[] protocolList = [SELECT Id, TreatmentSessionId__c FROM Session_Protocol__c];


        Test.startTest();
        TreatmentSessionLWCController.ProtocolInfo protocolInfo = TreatmentSessionLWCController.getActiveProtocolAndFields(protocolList[0].Id);
        Test.stopTest();

        System.assert(protocolInfo != null);
    }

    @isTest
    static void getActiveProtocolAndFieldsNew_noProtocol(){
        Treatment_Session__c treatmentSession = TestDataFactory.createSession();

        Test.startTest();
        TreatmentSessionLWCController.ProtocolInfo protocolInfo = TreatmentSessionLWCController.getActiveProtocolAndFields(null);
        Test.stopTest();

        System.assert(protocolInfo == null);
    }

    @isTest 
    static void getProtocolListBySessionId(){
        Treatment_Session__c treatmentSession = TestDataFactory.createSession();

        Test.startTest();
        TreatmentSessionLWCController.protocolAssignment protocolAssignments = TreatmentSessionLWCController.getProtocolLists(treatmentSession.Id, null);
        Test.stopTest();

        System.assert(protocolAssignments.assignedSessionProtocolsLists != null, 'No Session Protocols were returned');
        System.assert(protocolAssignments.unassignedProtocolsLists != null, 'No Unassigned Protocols were returned');
    }

    @isTest 
    static void getProtocolListByPlanId(){
        Plan_Protocol__c[] planProtocols = TestDataFactory.createPlanProtocols(4);

        Test.startTest();
        TreatmentSessionLWCController.protocolAssignment protocolAssignments = TreatmentSessionLWCController.getProtocolLists(null, planProtocols[0].Treatment_Plan__c);
        Test.stopTest();

        System.assert(protocolAssignments.assignedPlanProtocolsLists != null, 'No Plan Protocols were returned');
    }

    @isTest 
    static void updateProtocolAssignments_session(){
        Treatment_Session__c treatmentSession = TestDataFactory.createSession();
        Session_Protocol__c[] sProtocols = [SELECT Id, IsSkipped__c, IsRemoved__c FROM Session_Protocol__c WHERE TreatmentSessionId__c =: treatmentSession.Id];
        Session_Protocol__c skippedProtocol = sProtocols[0];
        skippedProtocol.IsSkipped__c = true;
        Session_Protocol__c removedProtocol = sProtocols[1];
        removedProtocol.IsRemoved__c = true;
        Protocol__c pr = new Protocol__c(
            Name = 'testProtocol'
        );
        insert pr;

        test.startTest();
            String response = TreatmentSessionLWCController.updateProtocolAssignments(
                new Session_Protocol__c[]{skippedProtocol, removedProtocol},
                new String[]{pr.Id},
                null,
                treatmentSession.Id,
                null
            );
        test.stopTest();
        System.assertEquals('success', response);
        System.assertEquals(true, [SELECT Id, IsSkipped__c FROM Session_Protocol__c WHERE Id =: skippedProtocol.Id LIMIT 1].IsSkipped__c);
        Session_Protocol__c removedProtocolUpdated = [SELECT Id, IsRemoved__c, ProtocolId__c FROM Session_Protocol__c WHERE Id =: removedProtocol.Id LIMIT 1];
        System.assertEquals(true, removedProtocolUpdated.IsRemoved__c);
        Session_Protocol__c newSessionProtocol = [SELECT Id FROM Session_Protocol__c WHERE ProtocolId__c =: pr.Id LIMIT 1];
        System.assert(newSessionProtocol != null, 'New Session Protocol for new protocol was not created');
        Plan_Protocol__c newPP = [SELECT Id FROM Plan_Protocol__c WHERE Protocol__c =: pr.Id];
        System.assert(newPP != null, 'No Plan Protocol was returned');
        System.assertEquals(true, [SELECT Id, IsRemoved__c FROM Plan_Protocol__c WHERE Protocol__c =: removedProtocolUpdated.ProtocolId__c LIMIT 1].IsRemoved__c);
    }

    @isTest 
    static void updateProtocolAssignments_plan(){
        Plan_Protocol__c[] planProtocols = TestDataFactory.createPlanProtocols(2);
        Protocol__c pr = new Protocol__c(
            Name = 'testProtocol'
        );
        insert pr;

        test.startTest();
            String response = TreatmentSessionLWCController.updateProtocolAssignments(
                null,
                new String[]{pr.Id},
                new String[]{planProtocols[0].Id},
                null,
                planProtocols[0].Treatment_Plan__c
            );
        test.stopTest();
        System.assertEquals('success', response);
        System.assertEquals(true, [SELECT Id, IsRemoved__c FROM Plan_Protocol__c WHERE Id =: planProtocols[0].Id LIMIT 1].IsRemoved__c);
        Plan_Protocol__c newPP = [SELECT Id FROM Plan_Protocol__c WHERE Protocol__c =: pr.Id];
        System.assert(newPP != null, 'No Plan Protocol was returned');
    }    

    @isTest
    static void getProtocolSkppedInfo_notSKipped(){
        Session_Protocol__c[] protocols = TestDataFactory.createSessionProtocols();

        test.startTest();
            Session_Protocol__c skippedInfo = TreatmentSessionLWCController.getProtocolSkippedInfo(protocols[0].Id);
        test.stopTest();

        System.assertEquals(false, skippedInfo.IsSkipped__c);
    }

    @isTest
    static void getProtocolSkppedInfo_sKipped(){
        Session_Protocol__c[] protocols = TestDataFactory.createSessionProtocols();
        protocols[0].isSkipped__c = true;
        update protocols[0];

        test.startTest();
            Session_Protocol__c skippedInfo = TreatmentSessionLWCController.getProtocolSkippedInfo(protocols[0].Id);
        test.stopTest();

        System.assertEquals(true, skippedInfo.IsSkipped__c);
    }

    @isTest
    static void getProtocolStatus_Success(){
        Session_Protocol__c[] protocols = TestDataFactory.createSessionProtocols();
        Session_Protocol__c sp = [SELECT Id, Status_Text__c FROM Session_Protocol__c WHERE Id = :protocols[0].Id LIMIT 1];

        test.startTest();
            String status = TreatmentSessionLWCController.getProtocolStatus(protocols[0].Id);
        test.stopTest();

        System.assertEquals(sp.Status_Text__c, status);
    }

    @isTest
    static void getProtocolStatus_NoProtocol(){
        test.startTest();
            String status = TreatmentSessionLWCController.getProtocolStatus(null);
        test.stopTest();

        System.assertEquals(null, status);
    }

    @isTest 
    static void getSpsInfoNoFieldsSuccess(){
        Session_Protocol_Scale__c[] spsList = TestDataFactory.createSessionProtocolScales();

        Test.startTest();
        TreatmentSessionLWCController.SpsInfo spsInfo = TreatmentSessionLWCController.getSpsInfo(spsList[0].Id, null);
        Test.stopTest();

        System.assertNotEquals(null, spsInfo);
    }

    @isTest 
    static void getSpsInfoWithFieldsSuccess(){
        Session_Protocol_Scale__c[] spsList = TestDataFactory.createSessionProtocolScales();
        Session_Protocol_Scale__c scale = spsList[0];
        scale.Duration__c = '1:15';
        update scale;

        Test.startTest();
        TreatmentSessionLWCController.SpsInfo spsInfo = TreatmentSessionLWCController.getSpsInfo(spsList[0].Id, New String[]{'Duration__c'});
        Test.stopTest();

        System.assertNotEquals(null, spsInfo);
        System.assertEquals('1:15', spsInfo.fields[0].value);
    }
}