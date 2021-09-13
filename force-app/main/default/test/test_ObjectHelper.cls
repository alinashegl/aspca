/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class test_ObjectHelper {

    @IsTest
    private static void regressionCoverage() {
        Test.startTest();

        String result1 = ObjectHelper.ConvertToNumberForSoql(42);
        String result2 = ObjectHelper.ConvertToBooleanForSoql(true);
        String result3 = ObjectHelper.ConvertToDateForSoql(DateTime.now().date());
        String result4 = ObjectHelper.ConvertToDateTimeForSoql(DateTime.now());
        String result5 = ObjectHelper.ConvertToStringForSoql(99);

        Test.stopTest();
    }
}