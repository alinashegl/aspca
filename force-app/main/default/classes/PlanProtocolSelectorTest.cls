@isTest
public class PlanProtocolSelectorTest {

    @isTest
    static void testplanprotocol(){
        case objCase = new Case(Status = 'On hold',Origin='Email',Agency_Case__c = 'test');
        insert objCase ;
        
        Animal__c objAnimal = new Animal__c(Case__c =objCase.id, Name='A-001-West',type_of_animal__c='Cat',breed__c='Coonhound',gender__c='MI',Animal_Age__c=12,Color__c='Brown',Intake_Date_Time__c= DateTime.now());
        insert objAnimal;
        
        Plan_Protocol__c[] planProtocols = TestDataFactory.createPlanProtocols(4);
        
        Treatment_Plan__c arcPlan = new Treatment_Plan__c(
            Animal__c = objAnimal.Id,
            Treatment_Priority__c = 'Low – 3 days'
        );
        PlanProtocolSelector pps = new PlanProtocolSelector();
        Set<SObjectField> fields = pps.GetDefaultFields();
        
        List<Plan_Protocol__c> results1 = pps.GetById(new Set<Id>{planProtocols[0].Id});
        List<Plan_Protocol__c> results2 = pps.GetByName(planProtocols[0].Name);
        List<Plan_Protocol__c> results3 = pps.GetByOpp(arcPlan.Id);
        
        System.assertNotEquals(null, results3);
        
        planProtocols[0].Protocol_Description__c = 'test';
        update planProtocols[0];
        
        delete planProtocols[0];
        
    }
}