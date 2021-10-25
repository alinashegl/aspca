public with sharing class CustomLookupLWCController {

    @AuraEnabled
    public static searchResponse search(String objectName, List<String> fields, String searchTerm, Integer offset){
        searchResponse response = new searchResponse();
        Integer rowsToSkip = offset * 25;
        String searchKeyword = searchTerm + '*';
        String returningQuery = objectName+' ( Id, '+String.join(fields,',')+')';

        String query = 'SELECT Id, '+String.join(fields,',')+' FROM ' + objectName + ' WHERE Name LIKE \'%' + searchTerm + '%\' LIMIT 25 OFFSET ' + rowsToSkip;
        Integer  count = database.countQuery('SELECT count() FROM ' + objectName + ' WHERE Name LIKE \'%' + searchTerm + '%\'');

        System.debug(' query '+query);
        response.recordList = Database.query(query);
        response.pageCount = Math.ceil(Decimal.valueOf(count).divide(25,1));

        return response;
    }

    public class searchResponse{
        @AuraEnabled public List<sObject> recordList {get; set;}
        @AuraEnabled public Double pageCount {get; set;}
    }

    @AuraEnabled (cacheable=true)
    public static sobject getCurrentRecord(String objectName, Id recordId, String[] fields){
    // public static sobject getCurrentRecord(String objectName){
        System.debug('in getCurrentCrecord: ' + objectName + ': ' + recordId + ': ' + fields);
        String query = 'SELECT Id, '+String.join(fields,',')+' FROM ' + objectName + ' WHERE Id = \'' + recordId + '\' LIMIT 1';

        System.debug(' query '+query);
        sobject sob = Database.query(query)[0];
        System.debug('sob: ' + sob);
        return sob;

        // return null;
    }

    @AuraEnabled
    public static SObject[] queryAll(String objectAPI, Integer offset, String[] fields){
        try {
            Integer rowsToSkip = offset * 25;
            String query = 'SELECT Id, '+String.join(fields,',')+' FROM ' + objectAPI + ' LIMIT 25 OFFSET ' + rowsToSkip;
            System.debug(' query '+query);

            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled (cacheable=true)
    public static SObject[] getRecords(String type){
        try {
            SObject[] objList = getRecordList(type);

            System.debug('objList = ' + objList);
            return objList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static SObject[] getRecordList(String type){
        Set<Id> recordIds = getRecentlyViewedIds(type);
        SObject[] recentlyViewed = queryRecords(type, recordIds);

        return recentlyViewed;
    }

    private static SObject[] queryRecords(String type, Set<Id> recordIds){
        String fields = fieldsToQuery(type);
        Id[] recIds = new Id[0];
        recIds.addAll(recordIds);
        String query = 'SELECT Id, ' + fields + ' FROM ' + type + ' WHERE Id IN: recIds';
        System.debug('query String = '+ query);
        SObject[] records = Database.query(query);
        return records;

    }

    private static Set<Id> getRecentlyViewedIds(String type){
        Set<Id> recordIds = new Set<Id>();
        for(RecentlyViewed rv : [SELECT Id,Name,Type FROM RecentlyViewed WHERE Type = : type]){
            recordIds.add(rv.Id);
        }
        return recordIds;
    }

    private static String fieldsToQuery(String type){
        Map<String, String> objToFields = new Map<String, String>{
            'Contact' => 'Name'
        };

        return objToFields.containsKey(type) ? objToFields.get(type) : null;
    }
}
