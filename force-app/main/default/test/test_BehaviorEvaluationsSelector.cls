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
    }
}