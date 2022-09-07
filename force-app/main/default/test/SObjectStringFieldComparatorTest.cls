@isTest 
private class SObjectStringFieldComparatorTest {
    @isTest 
    static void compare() {
        SObjectStringFieldComparator ssCompare = new SObjectStringFieldComparator('Name');
        Object obj1 = new Contact(
            FirstName = 'first',
            LastName = 'last'
        );

        Object obj2 = new Contact(
            FirstName = 'first',
            LastName = 'last'
        );
        test.startTest();
        integer i = ssCompare.compare(obj1, obj2);

        test.stopTest();

        System.assertEquals(0, i);            
    }

    @isTest 
    static void compareInvalidObject() {
        SObjectStringFieldComparator ssCompare = new SObjectStringFieldComparator('Name');
        test.startTest();

        String errorMessage;
        try{
            integer i = ssCompare.compare(ssCompare, ssCompare);
        }
        catch(Exception e){
            errorMessage = e.getMessage();
        }

        test.stopTest();

        System.assertEquals(
            'Objects must both be SObject in order to be compared: SObjectStringFieldComparator:[fieldName=Name] AND SObjectStringFieldComparator:[fieldName=Name]', 
            errorMessage
        );            
    }

    @isTest 
    static void compareNumbers() {
        SObjectStringFieldComparator ssCompare = new SObjectStringFieldComparator('Age__c');
        Object obj1 = new Contact(
            FirstName = 'first',
            LastName = 'last',
            Age__c = 21
        );

        Object obj2 = new Contact(
            FirstName = 'first',
            LastName = 'last',
            Age__c = 22
        );

        test.startTest();
        integer i = ssCompare.compareNumbers(obj1, obj2);

        test.stopTest();

        System.assertEquals(-1, i);            
    }

    @isTest 
    static void compareNumbersInvalidObject() {
        SObjectStringFieldComparator ssCompare = new SObjectStringFieldComparator('Age__c');
        test.startTest();

        String errorMessage;
        try{
            integer i = ssCompare.compareNumbers(ssCompare, ssCompare);
        }
        catch(Exception e){
            errorMessage = e.getMessage();
        }

        test.stopTest();

        System.assertEquals(
            'Objects must both be SObject in order to be compared: SObjectStringFieldComparator:[fieldName=Age__c] AND SObjectStringFieldComparator:[fieldName=Age__c]', 
            errorMessage
        );            
    }
}