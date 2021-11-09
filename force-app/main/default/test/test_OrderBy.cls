/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class test_OrderBy {
    @isTest
    private static void regressionCoverage() {
        String scenario1 = 'Name ASC';
        String scenario2 = 'Name DESC';

        Test.startTest();

        String result1 = OrderBy.Ascending(Account.Name).ForSoql();
        String result2 = OrderBy.Descending(Account.Name).ForSoql();

        Test.stopTest();

        System.assertEquals(result1, scenario1);
        System.assertEquals(result2, scenario2);
    }
}