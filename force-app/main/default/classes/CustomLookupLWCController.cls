public with sharing class CustomLookupLWCController {

    @AuraEnabled
    public static searchResponse search(String objectName, List<String> fields, String searchTerm, Integer offset, String whereClause, String fieldToQuery){
        System.debug('whereclause: ' + whereClause);

        searchResponse response = new searchResponse();
        Integer rowsToSkip = offset * 25;
        String searchKeyword = searchTerm + '*';
        String returningQuery = objectName+' ( Id, '+String.join(fields,',')+')';

        String whereString = ' WHERE ';
        if(whereClause != null){
            whereString += whereClause;
        }

        System.debug('shereSTring1: ' + whereString);

        whereString = fieldToQuery == null ? whereString : whereString + fieldToQuery;
        
        System.debug('shereSTring2: ' + whereString);

        String query = 'SELECT Id, '+String.join(fields,',')+' FROM ' + objectName + whereString + ' LIKE \'%' + searchTerm + '%\' LIMIT 25 OFFSET ' + rowsToSkip;
        System.debug('query ' + query);
        Integer  count = database.countQuery('SELECT count() FROM ' + objectName + whereString + ' LIKE \'%' + searchTerm + '%\'');

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
        System.debug('in getCurrentCrecord: ' + objectName + ': ' + recordId + ': ' + fields);

        String query = 'SELECT Id, '+String.join(fields,',')+' FROM ' + objectName + ' WHERE Id = \'' + recordId + '\' LIMIT 1';

        System.debug(' query '+query);
        sobject sob = Database.query(query)[0];
        System.debug('sob: ' + sob);
        return sob;
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
    public static SObject[] getRecentlyViewedRecords(String type, String whereClause){
        try {
            SObject[] objList = getRecordList(type, whereClause);

            System.debug('objList = ' + objList);
            return objList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static SObject[] getRecordList(String type, String whereClause){
        Set<Id> recordIds = getRecentlyViewedIds(type);
        SObject[] recentlyViewed = queryRecords(type, recordIds, whereClause);

        return recentlyViewed;
    }

    private static SObject[] queryRecords(String type, Set<Id> recordIds, String whereClause){
        String fields = fieldsToQuery(type);
        Id[] recIds = new Id[0];
        recIds.addAll(recordIds);

        String query = 'SELECT Id, ' + fields + ' FROM ' + type + ' WHERE ';
        query += whereClause == null ? 'Id IN: recIds' : whereClause + 'Id IN: recIds';

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
            'Contact' => 'Name',
            'Animal__c' => 'Animal_Name__c'
        };

        return objToFields.containsKey(type) ? objToFields.get(type) : 'Name';
    }

    @AuraEnabled(cacheable=true)
    public static List < sObject > fetchLookUpValues(String 
     searchKey,String 
    fieldName, String ObjectName,String keyField) {
      List < sObject > returnList = new List < sObject > ();
        String sQuery =  'select '+fieldName+','+keyField+ ' from '
        +ObjectName+' LIMIT 5000' ;
        List < sObject > lstOfRecords = Database.query(sQuery);
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}
