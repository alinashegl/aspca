/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class test_BehaviorEvaluationsSelector {
    @IsTest
    static void testGetAll() {

        Test.startTest();
        List<Behavior_Evaluation__c> evaluations = new BehaviorEvaluationsSelector().GetAll();
        Test.stopTest();

        System.assertEquals(true, evaluations.isEmpty());
    }

    @IsTest
    static void testGetById() {
        Behavior_Evaluation__c eval = TestDataFactory.createPuppyBehaviorEvaluation();
        Animal__c dog = [SELECT Id FROM Animal__c LIMIT 1];
        
        Test.startTest();
        List<Behavior_Evaluation__c> evaluations = new BehaviorEvaluationsSelector().GetById(new Set<Id>{eval.Id});
        Test.stopTest();

        System.assertEquals(false, evaluations.isEmpty());
    }

    @IsTest
    static void testGetSome() {
        Behavior_Evaluation__c eval = TestDataFactory.createPuppyBehaviorEvaluation();
        Animal__c dog = [SELECT Id FROM Animal__c LIMIT 1];
        
        Test.startTest();
        List<Behavior_Evaluation__c> evaluations = new BehaviorEvaluationsSelector().GetSome(1);
        Test.stopTest();

        System.assertEquals(false, evaluations.isEmpty());
    }
}