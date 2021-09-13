/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class test_SchemaHelper {
    @IsTest
    private static void regressionCoverage() {
        Test.startTest();
        DescribeSObjectResult objectResult = SchemaHelper.GetDescribe(Account.getSObjectType());
        DescribeFieldResult fieldResult = SchemaHelper.GetDescribe(Account.Id);
        List<Integer> fieldHashesResult = SchemaHelper.GetFieldHashes(Account.getSObjectType());
        Id generatedIdResult = SchemaHelper.GenerateIdFor(Account.getSObjectType());
        Boolean userIsSetupObject = SchemaHelper.IsSetupSObject(User.getSObjectType());
        Test.stopTest();
    }
}