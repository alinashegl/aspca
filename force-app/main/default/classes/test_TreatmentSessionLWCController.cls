@isTest
private class test_TreatmentSessionLWCController {
    @isTest
    static void getActiveProtocols_hasProtocols(){
        Treatment_Session__c session = TestDataFactory.createSession();
        Session_Protocol__c[] sessionProtocols = [SELECT Id, TreatmentSessionId__c FROM Session_Protocol__c WHERE TreatmentSessionId__c =: session.Id];

        Test.startTest();
            Session_Protocol__c[] returnedList = TreatmentSessionLWCController.getActiveProtocols(session.Id);
        Test.stopTest();

        System.assertEquals(sessionProtocols.size(), returnedList.size());
    }

    @isTest
    static void getActiveProtocols_noProtocols(){
        Treatment_Plan__c plan = new Treatment_Plan__c();
        insert plan;

        Treatment_Session__c session = new Treatment_Session__c(
            Treatment_Plan__c = plan.Id
        );
        insert session;

        Test.startTest();
            Session_Protocol__c[] returnedList = TreatmentSessionLWCController.getActiveProtocols(session.Id);
        Test.stopTest();

        System.assert(returnedList.isEmpty(), 'list should have been empty: ' + returnedList);
    }

    @isTest
    static void getChildList_hasContacts(){
        Session_Protocol_Contact__c[] sContacts = TestDataFactory.createSessionProtocolContact();

        Test.startTest();
            SObject[] returnedContacts = TreatmentSessionLWCController.getChildList(sContacts[0].Session_Protocol__c, 'Session_Protocol_Contact__c');
        Test.stopTest();

        System.assertEquals(1, returnedContacts.size());

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
        Session_Protocol__c[] protocolList = TestDataFactory.createSessionProtocols();

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
}
