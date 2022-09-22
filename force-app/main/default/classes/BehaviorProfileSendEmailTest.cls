@isTest
public class BehaviorProfileSendEmailTest {

    @testSetup
    static void setupData(){
        List<Behavior_Evaluation__c> evaluations = TestDataFactory.createMultipleBehaviorEvaluation(2, 'Dog Fighting');
    }
    
    @isTest
    static void testSendEmail(){
        Behavior_Evaluation__c beh = [Select Id from Behavior_Evaluation__c LIMIT 1];
        BehaviorProfileSendEmail.EmailRequest req = new BehaviorProfileSendEmail.EmailRequest();
        req.behEvaluations = beh; 
        BehaviorProfileSendEmail.sendEmail(new List<BehaviorProfileSendEmail.EmailRequest>{req});
    }
}