public with sharing class CustomLookupLWCController {

    //query for the records
    @AuraEnabled
    public static searchResponse search(String objectName, List<String> fields, String searchTerm, Integer offset, String whereClause, String fieldToQuery){
        searchResponse response = new searchResponse();
        Integer rowsToSkip = offset * 25;
        String whereString = ' WHERE ';
        if(whereClause != null){
            whereString += whereClause + ' AND ';
        }
        whereString = fieldToQuery == null ? whereString : whereString + fieldToQuery;

        //put together they query string
        String query = 'SELECT Id, '+String.join(fields,',')+' FROM ' + objectName + whereString + ' LIKE \'%' + searchTerm + '%\' LIMIT 25 OFFSET ' + rowsToSkip;
        System.debug('query: ' + query);

        //query for the full list to get the count so we can display the total number of pages
        Integer  count = database.countQuery('SELECT count() FROM ' + objectName + whereString + ' LIKE \'%' + searchTerm + '%\'');

        //query the records
        response.recordList = Database.query(query);
        //divide the total number of records by 25 to convert to page numbers
        response.pageCount = Math.ceil(Decimal.valueOf(count).divide(25,1));

        return response;
    }

    @AuraEnabled (cacheable=true)
    public static sobject getCurrentRecord(String objectName, Id recordId, String[] fields){
        String query = 'SELECT Id, '+String.join(fields,',')+' FROM ' + objectName + ' WHERE Id = \'' + recordId + '\' LIMIT 1';
        sobject sob = Database.query(query)[0];
        return sob;
    }

    @AuraEnabled (cacheable=true)
    public static SObject[] getRecentlyViewedRecords(String objectAPI, String whereClause){
        try {
            SObject[] objList = getRecordList(objectAPI, whereClause);

            return objList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    //gets the list of recently viewed records for that objecta nd then queries the actual records based on the ids
    private static SObject[] getRecordList(String objectAPI, String whereClause){
        Set<Id> recordIds = getRecentlyViewedIds(objectAPI);
        SObject[] recentlyViewed = queryRecords(objectAPI, recordIds, whereClause);

        return recentlyViewed;
    }

    private static SObject[] queryRecords(String objectAPI, Set<Id> recordIds, String whereClause){
        String fields = fieldsToQuery(objectAPI);
        Id[] recIds = new Id[0];
        recIds.addAll(recordIds);

        String whereString = '';
        if(whereClause != null){
            whereString += whereClause + ' AND ';
        }

        String query = 'SELECT Id, ' + fields + ' FROM ' + objectAPI + ' WHERE ';
        query += whereClause == null ? 'Id IN: recIds' : whereString + 'Id IN: recIds';

        SObject[] records = Database.query(query);
        return records;
    }

    private static Set<Id> getRecentlyViewedIds(String objectAPI){
        Set<Id> recordIds = new Set<Id>();
        for(RecentlyViewed rv : [SELECT Id,Name,Type FROM RecentlyViewed WHERE Type = : objectAPI]){
            recordIds.add(rv.Id);
        }
        return recordIds;
    }

    private static String fieldsToQuery(String objectAPI){
        Map<String, String> objToFields = new Map<String, String>{
            'Contact' => 'Name',
            'Animal__c' => 'Animal_Name__c'
        };

        return objToFields.containsKey(objectAPI) ? objToFields.get(objectAPI) : 'Name';
    }

    public class searchResponse{
        @AuraEnabled public List<sObject> recordList {get; set;}
        @AuraEnabled public Double pageCount {get; set;}
    }
}