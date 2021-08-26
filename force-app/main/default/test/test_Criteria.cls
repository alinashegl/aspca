/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class test_Criteria {
    @isTest
    private static void regressionCoverage() {
        Schema.SObjectField idField = Account.Id;
        Schema.SObjectField dateField = Contact.Birthdate;
        Schema.SObjectField dateTimeField = Contact.CreatedDate;
        Schema.SObjectField numberField = Account.NumberOfEmployees;
        Schema.SObjectField booleanField = Contact.DoNotCall;
        Schema.SObjectField stringField = Contact.Name;
        String idFieldName = idField.getDescribe().getName();
        String dateFieldName = dateField.getDescribe().getName();
        String dateTimeFieldName = dateTimeField.getDescribe().getName();
        String numberFieldName = numberField.getDescribe().getName();
        String booleanFieldName = booleanField.getDescribe().getName();
        String stringFieldName = stringField.getDescribe().getName();

        Id testAccountId = SchemaHelper.GenerateIdFor(Account.getSObjectType());
        Date testDate = System.Date.today();
        DateTime testDateTime = System.DateTime.now();
        Integer testNumber = 3;
        Boolean testBoolean = false;
        String testNameOne = 'Tom';
        Set<String> stringSet = new Set<String> {
                testNameOne, 'Brenda', 'Alice'
        };
        Set<Id> idSet = new Set<Id> {
                SchemaHelper.GenerateIdFor(Account.getSObjectType()),
                SchemaHelper.GenerateIdFor(Account.getSObjectType())
        };
        Set<Date> dateSet = new Set<Date> {
                testDate, testDate.addDays(-1)
        };
        Set<DateTime> dateTimeSet = new Set<DateTime> {
                testDateTime, testDateTime.addDays(-2)
        };
        Set<Decimal> decimalSet = new Set<Decimal> {
                0.1, 1.1, 2.1
        };
        Set<Integer> integerSet = new Set<Integer> {
                1, 2, 3, 5, 8
        };
        List<String> stringList = new List<String>(stringSet);
        List<Id> idList = new List<Id>(idSet);
        List<Date> dateList = new List<Date>(dateSet);
        List<DateTime> dateTimeList = new List<DateTime>(dateTimeSet);
        List<Decimal> decimalList = new List<Decimal>(decimalSet);
        List<Integer> integerList = new List<Integer>(integerSet);
        Set<Object> objectSet = new Set<Object>();
        for (String str : stringSet) {
            objectSet.add((Object)str);
        }
        List<Object> objectList = new List<Object>(objectSet);

        Test.startTest();

        System.assertEquals( Criteria.AndCriterias( new List<iCriteria> {
                Criteria.Equals( idField, testAccountId )
                , Criteria.Equals( stringField, testNameOne )
        } ).ForSoql()
                , '(' + idFieldName + ' = \'' + testAccountId + '\' AND ' + stringFieldName + ' = \'' + testNameOne + '\')' );

        System.assertEquals( Criteria.OrCriterias( new List<iCriteria> {
                Criteria.Equals( stringField, 'Bob' )
                , Criteria.Equals( stringField, testNameOne )
        } ).ForSoql()
                , '(' + stringFieldName + ' = \'Bob\' OR ' + stringFieldName + ' = \'' + testNameOne + '\')' );

        System.assertEquals( Criteria.Equals( stringField, (Object) stringList[0] ).ForSoql()
                , stringFieldName + ' = ' + SoqlHelper.FormatForSoql( stringField, (Object) stringList[0] ) );

        System.assertEquals( Criteria.Equals( idField, idList[0] ).ForSoql()
                , idFieldName + ' = ' + SoqlHelper.FormatForSoql( idField, idList[0] ) );

        System.assertEquals( Criteria.Equals( stringField, stringList[0] ).ForSoql()
                , stringFieldName + ' = ' + SoqlHelper.FormatForSoql( stringField, stringList[0] ) );

        System.assertEquals( Criteria.Equals( dateField, dateList[0] ).ForSoql()
                , dateFieldName + ' = ' + SoqlHelper.FormatForSoql( dateField, (Object) String.valueOf(dateList[0]) ) );

        System.assertEquals( Criteria.Equals( dateTimeField, dateTimeList[0] ).ForSoql()
                , dateTimeFieldName + ' = ' + SoqlHelper.FormatForSoql( dateTimeField, (Object) String.valueOf(dateTimeList[0]) ) );

        System.assertEquals( Criteria.Equals( numberField, decimalList[0] ).ForSoql()
                , numberFieldName + ' = ' + SoqlHelper.FormatForSoql( numberField, decimalList[0] ) );

        System.assertEquals( Criteria.Equals( numberField, integerList[0] ).ForSoql()
                , numberFieldName + ' = ' + SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( Criteria.NotEquals( stringField, (Object) stringList[0] ).ForSoql()
                , stringFieldName + ' != ' + SoqlHelper.FormatForSoql( stringField, stringList[0] ) );

        System.assertEquals( Criteria.NotEquals( idField, idList[0] ).ForSoql()
                , idFieldName + ' != ' + SoqlHelper.FormatForSoql( idField, idList[0] ) );

        System.assertEquals( Criteria.NotEquals( stringField, stringList[0] ).ForSoql()
                , stringFieldName + ' != ' + SoqlHelper.FormatForSoql( stringField, stringList[0] ) );

        System.assertEquals( Criteria.NotEquals( dateField, dateList[0] ).ForSoql()
                , dateFieldName + ' != ' + SoqlHelper.FormatForSoql( dateField, (Object) String.valueOf(dateList[0]) ) );

        System.assertEquals( Criteria.NotEquals( dateTimeField, dateTimeList[0] ).ForSoql()
                , dateTimeFieldName + ' != ' + SoqlHelper.FormatForSoql( dateTimeField, (Object) String.valueOf(dateTimeList[0]) ) );

        System.assertEquals( Criteria.NotEquals( numberField, decimalList[0] ).ForSoql()
                , numberFieldName + ' != ' + SoqlHelper.FormatForSoql( numberField, decimalList[0] ) );

        System.assertEquals( Criteria.NotEquals( numberField, integerList[0] ).ForSoql()
                , numberFieldName + ' != ' + SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( Criteria.GreaterThan( numberField, (Object) integerList[0] ).ForSoql()
                , numberFieldName + ' > ' + SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( Criteria.GreaterThan( dateField, dateList[0] ).ForSoql()
                , dateFieldName + ' > ' + SoqlHelper.FormatForSoql( dateField, (Object) String.valueOf(dateList[0]) ) );

        System.assertEquals( Criteria.GreaterThan( dateTimeField, dateTimeList[0] ).ForSoql()
                , dateTimeFieldName + ' > ' + SoqlHelper.FormatForSoql( dateTimeField, (Object) String.valueOf(dateTimeList[0]) ) );

        System.assertEquals( Criteria.GreaterThan( numberField, decimalList[0] ).ForSoql()
                , numberFieldName + ' > ' + SoqlHelper.FormatForSoql( numberField, decimalList[0] ) );

        System.assertEquals( Criteria.GreaterThan( numberField, integerList[0] ).ForSoql()
                , numberFieldName + ' > ' + SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( Criteria.LessThan( numberField, (Object) integerList[0] ).ForSoql()
                , numberFieldName + ' < ' + SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( Criteria.LessThan( dateField, dateList[0] ).ForSoql()
                , dateFieldName + ' < ' + SoqlHelper.FormatForSoql( dateField, (Object) String.valueOf(dateList[0]) ) );

        System.assertEquals( Criteria.LessThan( dateTimeField, dateTimeList[0] ).ForSoql()
                , dateTimeFieldName + ' < ' + SoqlHelper.FormatForSoql( dateTimeField, (Object) String.valueOf(dateTimeList[0]) ) );

        System.assertEquals( Criteria.LessThan( numberField, decimalList[0] ).ForSoql()
                , numberFieldName + ' < ' + SoqlHelper.FormatForSoql( numberField, decimalList[0] ) );

        System.assertEquals( Criteria.LessThan( numberField, integerList[0] ).ForSoql()
                , numberFieldName + ' < ' + SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( Criteria.GreaterThanOrEquals( numberField, (Object) integerList[0] ).ForSoql()
                , numberFieldName + ' >= ' + SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( Criteria.GreaterThanOrEquals( dateField, dateList[0] ).ForSoql()
                , dateFieldName + ' >= ' + SoqlHelper.FormatForSoql( dateField, (Object) String.valueOf(dateList[0]) ) );

        System.assertEquals( Criteria.GreaterThanOrEquals( dateTimeField, dateTimeList[0] ).ForSoql()
                , dateTimeFieldName + ' >= ' + SoqlHelper.FormatForSoql( dateTimeField, (Object) String.valueOf(dateTimeList[0]) ) );

        System.assertEquals( Criteria.GreaterThanOrEquals( numberField, decimalList[0] ).ForSoql()
                , numberFieldName + ' >= ' + SoqlHelper.FormatForSoql( numberField, decimalList[0] ) );

        System.assertEquals( Criteria.GreaterThanOrEquals( numberField, integerList[0] ).ForSoql()
                , numberFieldName + ' >= ' + SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( Criteria.LessThanOrEquals( numberField, (Object) integerList[0] ).ForSoql()
                , numberFieldName + ' <= ' + SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( Criteria.LessThanOrEquals( dateField, dateList[0] ).ForSoql()
                , dateFieldName + ' <= ' + SoqlHelper.FormatForSoql( dateField, (Object) String.valueOf(dateList[0]) ) );

        System.assertEquals( Criteria.LessThanOrEquals( dateTimeField, dateTimeList[0] ).ForSoql()
                , dateTimeFieldName + ' <= ' + SoqlHelper.FormatForSoql( dateTimeField, (Object) String.valueOf(dateTimeList[0]) ) );

        System.assertEquals( Criteria.LessThanOrEquals( numberField, decimalList[0] ).ForSoql()
                , numberFieldName + ' <= ' + SoqlHelper.FormatForSoql( numberField, decimalList[0] ) );

        System.assertEquals( Criteria.LessThanOrEquals( numberField, integerList[0] ).ForSoql()
                , numberFieldName + ' <= ' + SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( Criteria.ValueIn( stringField, objectSet ).ForSoql()
                , stringFieldName + ' IN ' + convertToString( stringField, objectSet ) );

        System.assertEquals( Criteria.ValueIn( idField, idSet ).ForSoql()
                , idFieldName + ' IN ' + convertToString( idField, idSet ) );

        System.assertEquals( Criteria.ValueIn( stringField, stringSet ).ForSoql()
                , stringFieldName + ' IN ' + convertToString( stringField, stringSet ) );

        System.assertEquals( Criteria.ValueIn( dateField, dateSet ).ForSoql()
                , dateFieldName + ' IN ' + convertToString( dateField, dateSet ) );

        System.assertEquals( Criteria.ValueIn( dateTimeField, dateTimeSet ).ForSoql()
                , dateTimeFieldName + ' IN ' + convertToString( dateTimeField, dateTimeSet ) );

        System.assertEquals( Criteria.ValueIn( numberField, decimalSet ).ForSoql()
                , numberFieldName + ' IN ' + convertToString( numberField, decimalSet ) );

        System.assertEquals( Criteria.ValueIn( numberField, integerSet ).ForSoql()
                , numberFieldName + ' IN ' + convertToString( numberField, integerSet ) );

        System.assertEquals( Criteria.ValueIn( stringField, objectList ).ForSoql()
                , stringFieldName + ' IN ' + convertToString( stringField, objectList ) );

        System.assertEquals( Criteria.ValueIn( idField, idList ).ForSoql()
                , idFieldName + ' IN ' + convertToString( idField, idList ) );

        System.assertEquals( Criteria.ValueIn( stringField, stringList ).ForSoql()
                , stringFieldName + ' IN ' + convertToString( stringField, stringSet ) );

        System.assertEquals( Criteria.ValueIn( dateField, dateList ).ForSoql()
                , dateFieldName + ' IN ' + convertToString( dateField, dateList ) );

        System.assertEquals( Criteria.ValueIn( dateTimeField, dateTimeList ).ForSoql()
                , dateTimeFieldName + ' IN ' + convertToString( dateTimeField, dateTimeList ) );

        System.assertEquals( Criteria.ValueIn( numberField, decimalList ).ForSoql()
                , numberFieldName + ' IN ' + convertToString( numberField, decimalList ) );

        System.assertEquals( Criteria.ValueIn( numberField, integerList ).ForSoql()
                , numberFieldName + ' IN ' + convertToString( numberField, integerList ) );

        System.assertEquals( Criteria.ValueNotIn( stringField, objectSet ).ForSoql()
                , stringFieldName + ' NOT IN ' + convertToString( stringField, objectSet ) );

        System.assertEquals( Criteria.ValueNotIn( idField, idSet ).ForSoql()
                , idFieldName + ' NOT IN ' + convertToString( idField, idSet ) );

        System.assertEquals( Criteria.ValueNotIn( stringField, stringSet ).ForSoql()
                , stringFieldName + ' NOT IN ' + convertToString( stringField, stringSet ) );

        System.assertEquals( Criteria.ValueNotIn( dateField, dateSet ).ForSoql()
                , dateFieldName + ' NOT IN ' + convertToString( dateField, dateSet ) );

        System.assertEquals( Criteria.ValueNotIn( dateTimeField, dateTimeSet ).ForSoql()
                , dateTimeFieldName + ' NOT IN ' + convertToString( dateTimeField, dateTimeSet ) );

        System.assertEquals( Criteria.ValueNotIn( numberField, decimalSet ).ForSoql()
                , numberFieldName + ' NOT IN ' + convertToString( numberField, decimalSet ) );

        System.assertEquals( Criteria.ValueNotIn( numberField, integerSet ).ForSoql()
                , numberFieldName + ' NOT IN ' + convertToString( numberField, integerSet ) );

        System.assertEquals( Criteria.ValueNotIn( stringField, objectList ).ForSoql()
                , stringFieldName + ' NOT IN ' + convertToString( stringField, objectList ) );

        System.assertEquals( Criteria.ValueNotIn( idField, idList ).ForSoql()
                , idFieldName + ' NOT IN ' + convertToString( idField, idList ) );

        System.assertEquals( Criteria.ValueNotIn( stringField, stringList ).ForSoql()
                , stringFieldName + ' NOT IN ' + convertToString( stringField, stringSet ) );

        System.assertEquals( Criteria.ValueNotIn( dateField, dateList ).ForSoql()
                , dateFieldName + ' NOT IN ' + convertToString( dateField, dateList ) );

        System.assertEquals( Criteria.ValueNotIn( dateTimeField, dateTimeList ).ForSoql()
                , dateTimeFieldName + ' NOT IN ' + convertToString( dateTimeField, dateTimeList ) );

        System.assertEquals( Criteria.ValueNotIn( numberField, decimalList ).ForSoql()
                , numberFieldName + ' NOT IN ' + convertToString( numberField, decimalList ) );

        System.assertEquals( Criteria.ValueNotIn( numberField, integerList ).ForSoql()
                , numberFieldName + ' NOT IN ' + convertToString( numberField, integerList ) );

        System.assertEquals( Criteria.BeginsWith( stringField, testNameOne ).ForSoql()
                , stringFieldName + ' LIKE \'' + testNameOne + '%\'' );

        System.assertEquals( Criteria.Contains( stringField, testNameOne ).ForSoql()
                , stringFieldName + ' LIKE \'%' + testNameOne + '%\'' );

        System.assertEquals( Criteria.EndsWith( stringField, testNameOne ).ForSoql()
                , stringFieldName + ' LIKE \'%' + testNameOne + '\'' );

        System.assertEquals( Criteria.DoesNotBeginWith( stringField, testNameOne ).ForSoql()
                , stringFieldName + ' NOT LIKE \'' + testNameOne + '%\'' );

        System.assertEquals( Criteria.DoesNotContain( stringField, testNameOne ).ForSoql()
                , stringFieldName + ' NOT LIKE \'%' + testNameOne + '%\'' );

        System.assertEquals( Criteria.DoesNotEndWith( stringField, testNameOne ).ForSoql()
                , stringFieldName + ' NOT LIKE \'%' + testNameOne + '\'' );

        System.assertEquals( Criteria.IsNull( stringField ).ForSoql()
                , stringFieldName + Criteria.EQUAL_TO + Criteria.NULL_TXT
                , 'Distance between strings should be 0. Actual is: '
                        + Criteria.IsNull( stringField ).ForSoql()
                        .getLevenshteinDistance(stringFieldName + Criteria.EQUAL_TO + Criteria.NULL_TXT));

        System.assertEquals( Criteria.IsNotNull( stringField ).ForSoql()
                , stringFieldName + Criteria.NOT_EQUAL + Criteria.NULL_TXT
                , 'Distance between strings should be 0. Actual is: '
                        + Criteria.IsNotNull( stringField ).ForSoql()
                        .getLevenshteinDistance(stringFieldName + Criteria.NOT_EQUAL + Criteria.NULL_TXT));

        Test.stopTest();
    }

    private static String convertToString(Schema.SObjectField field, Set<Id> values) {
        List<Object> objects = new List<Object>();
        for (Id value : values) { objects.add((Object) String.valueOf(value)); }
        return SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, Set<Object> values) {
        List<Object> objects = new List<Object>();
        for (Object value : values) { objects.add(value); }
        return SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, Set<String> values) {
        List<Object> objects = new List<Object>();
        for (String value : values) { objects.add((Object) value); }
        return SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, Set<Date> values) {
        List<Object> objects = new List<Object>();
        for (Date value : values) { objects.add((Object) String.valueOf(value)); }
        return SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, Set<DateTime> values) {
        List<Object> objects = new List<Object>();
        for (DateTime value : values) { objects.add((Object) String.valueOf(value)); }
        return SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, Set<Decimal> values) {
        List<Object> objects = new List<Object>();
        for (Decimal value : values) { objects.add((Object) String.valueOf(value)); }
        return SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, Set<Integer> values) {
        List<Object> objects = new List<Object>();
        for (Integer value : values) { objects.add((Object) String.valueOf(value)); }
        return SoqlHelper.FormatListForMatching( field, objects );
    }

    private static String convertToString(Schema.SObjectField field, List<Id> values) {
        List<Object> objects = new List<Object>();
        for (Id value : values) { objects.add((Object) String.valueOf(value)); }
        return SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, List<Object> values) {
        return SoqlHelper.FormatListForMatching( field, values );
    }
    private static String convertToString(Schema.SObjectField field, List<String> values) {
        List<Object> objects = new List<Object>();
        for (String value : values) { objects.add((Object) value); }
        return SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, List<Date> values) {
        List<Object> objects = new List<Object>();
        for (Date value : values) { objects.add((Object) String.valueOf(value)); }
        return SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, List<DateTime> values) {
        List<Object> objects = new List<Object>();
        for (DateTime value : values) { objects.add((Object) String.valueOf(value)); }
        return SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, List<Decimal> values) {
        List<Object> objects = new List<Object>();
        for (Decimal value : values) { objects.add((Object) String.valueOf(value)); }
        return SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, List<Integer> values) {
        List<Object> objects = new List<Object>();
        for (Integer value : values) { objects.add((Object) String.valueOf(value)); }
        return SoqlHelper.FormatListForMatching( field, objects );
    }
}