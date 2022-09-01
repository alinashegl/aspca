@isTest
private class test_CustomLookupLWCController {
    @isTest
    static void search_returnRecords_noSearchTerm(){
        TestDataFactory.insertAccounts();

        String objName = 'Account';
        String[] fields = new String[]{'Name'};
        String searchTerm = '';
        Integer offset = 0;
        String whereClause = null;
        String fieldToQuery = 'Name';

        test.startTest();
            CustomLookupLWCController.searchResponse response = CustomLookupLWCController.search(objName, fields, searchTerm, offset, whereClause, fieldToQuery);
        test.stopTest();

        System.assert(response != null);
        System.assertEquals(10, response.recordList.size());
        System.assertEquals(1, response.pageCount);
    }

    @isTest
    static void search_returnRecords_hasSearchTerm(){
        TestDataFactory.insertAccounts();
        Account[] accsToUpdate = [SELECT Id, Industry FROM Account LIMIT 5];
        for(Account acc : accsToUpdate){
            acc.Industry = 'Banking';
        }
        update accsToUpdate;

        String objName = 'Account';
        String[] fields = new String[]{'Name', 'Industry'};
        String searchTerm = 'Ban';
        Integer offset = 0;
        String whereClause = null;
        String fieldToQuery = 'Industry';

        test.startTest();
            CustomLookupLWCController.searchResponse response = CustomLookupLWCController.search(objName, fields, searchTerm, offset, whereClause, fieldToQuery);
        test.stopTest();

        System.assert(response != null);
        System.assertEquals(5, response.recordList.size());
        System.assertEquals(1, response.pageCount);
    }

    @isTest
    static void search_returnRecords_hasWhereClause(){
        TestDataFactory.insertAccounts();
        Account[] accsToUpdate = [SELECT Id, Industry FROM Account LIMIT 5];
        for(Account acc : accsToUpdate){
            acc.Industry = 'Banking';
        }
        update accsToUpdate;

        String objName = 'Account';
        String[] fields = new String[]{'Name', 'Industry'};
        String searchTerm = '';
        Integer offset = 0;
        String whereClause = 'Industry = \'Banking\'';
        String fieldToQuery = 'Industry';

        test.startTest();
            CustomLookupLWCController.searchResponse response = CustomLookupLWCController.search(objName, fields, searchTerm, offset, whereClause, fieldToQuery);
        test.stopTest();

        System.assert(response != null);
        System.assertEquals(5, response.recordList.size());
        System.assertEquals(1, response.pageCount);
    }

    @isTest
    static void search_noResults(){
        String objName = 'Account';
        String[] fields = new String[]{'Name', 'Industry'};
        String searchTerm = '';
        Integer offset = 0;
        String whereClause = 'Industry = \'Banking\'';
        String fieldToQuery = 'Industry';

        test.startTest();
            CustomLookupLWCController.searchResponse response = CustomLookupLWCController.search(objName, fields, searchTerm, offset, whereClause, fieldToQuery);
        test.stopTest();

        System.assert(response != null);
        System.assert(response.recordList.isEmpty());
        System.assertEquals(0, response.pageCount);
    }

    @isTest
    static void getCurrentRecord_hasRecord(){
        Contact con = TestDataFactory.createContact();
        String[] fields = new String[]{'FirstName', 'LastName'};

        test.startTest();
            Contact conResponse = (Contact) CustomLookupLWCController.getCurrentRecord('Contact', con.Id, fields);
        test.stopTest();

        System.assert(conResponse != null);
        System.assertEquals(con.Id, conResponse.Id);
    }

    @isTest
    static void getRecentlyViewedRecords_noRecords(){
        TestDataFactory.insertAccounts();
        Account[] accsToUpdate = [SELECT Id, Industry FROM Account LIMIT 5];
        for(Account acc : accsToUpdate){
            acc.Industry = 'Banking';
        }
        update accsToUpdate;

        String whereClause = 'Industry = \'Agriculture\'';

        test.startTest();
            SObject[] objsReturned = CustomLookupLWCController.getRecentlyViewedRecords('Account', whereClause);
        test.stopTest();

        System.assert(objsReturned != null);
        System.assert(objsReturned.isEmpty(), 'should have returned an empty list, but instead was: ' + objsReturned);
    }

    @isTest
    static void getRecentlyViewedRecords_hasRecords(){
        TestDataFactory.insertAccounts();
        Account[] accsToUpdate = [SELECT Id, Industry FROM Account LIMIT 5];
        for(Account acc : accsToUpdate){
            acc.Industry = 'Banking';
        }
        update accsToUpdate;

        String whereClause = 'Industry = \'Banking\'';

        test.startTest();
            SObject[] objsReturned = CustomLookupLWCController.getRecentlyViewedRecords('Account', whereClause);
        test.stopTest();

        System.assert(objsReturned != null);
        System.assertEquals(5, objsReturned.size());
    }

    @isTest
    static void getRecentlyViewedRecords_badWhereClause(){
        TestDataFactory.insertAccounts();
        Account[] accsToUpdate = [SELECT Id, Industry FROM Account LIMIT 5];
        for(Account acc : accsToUpdate){
            acc.Industry = 'Banking';
        }
        update accsToUpdate;

        String whereClause = 'WHERE Industry = \'Banking\'';

        String error;
        test.startTest();
        try{
            SObject[] objsReturned = CustomLookupLWCController.getRecentlyViewedRecords('Account', whereClause);
        } catch (exception e){
            error = e.getMessage();
        }
        test.stopTest();

        System.assert(error != null);
    }
}