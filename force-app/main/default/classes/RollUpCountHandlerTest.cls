@isTest
public class RollUpCountHandlerTest {

    @isTest
    static void testRollup(){
        Animal__c anm = TestDataFactory.createAnimal();
        Treatment_Plan__c plan = new Treatment_Plan__c(
            Problem_Behavior__c = 'Fear of People - Mild'
        );

        insert plan;

        Contact con = TestDataFactory.createContact();
		List<Treatment_Session__c> sessionList = new List<Treatment_Session__c>();
        Treatment_Session__c session = new Treatment_Session__c(
            Treatment_Plan__c = plan.Id,
            Session_Contact__c = con.Id,
            Session_Notes__c = 'Test',
            Animal__c = anm.Id
        );
        sessionList.add(session);
        
        Treatment_Session__c session2 = new Treatment_Session__c(
            Treatment_Plan__c = plan.Id,
            Session_Contact__c = con.Id,
            Session_Notes__c = 'Test',
            Animal__c = anm.Id
        );
        sessionList.add(session2);
        insert sessionList;
        
        update sessionList[0];
        
        delete sessionList[1];
        
        List<Treatment_Session__c> sList = [Select Id from Treatment_Session__c];
        System.assertEquals(sList.size(), 1);
    }
}