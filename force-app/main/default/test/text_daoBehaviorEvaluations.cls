/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class text_daoBehaviorEvaluations
{
    @IsTest
    static void testFindAll()
    {
        Test.startTest();
        dao_BehaviorEvaluations daoBehaviorEvaluations = new dao_BehaviorEvaluations();
        List<Behavior_Evaluation__c> evaluations = daoBehaviorEvaluations.findAll();
        Test.stopTest();
    }
}