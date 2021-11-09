/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */
@IsTest
private class test_ExceptionHelper {
    @isTest
    private static void regressionCoverage() {

        Test.startTest();

        String test1 = ExceptionHelper.Format(new cq.CriteriaException('test 1'));
        String test2 = ExceptionHelper.FormatVerbose(new cq.CriteriaException('test 2'));

        Test.stopTest();
    }
}