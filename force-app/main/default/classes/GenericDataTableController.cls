public with sharing class GenericDataTableController {
    @AuraEnabled 
    public static List<SObject> getRecords(String soql) {
		System.debug('soql::' + soql);
		return Database.query(soql);
    }
    
    @AuraEnabled(cacheable=true)
    public static List<SObject> getAllRecords(Integer rowLimit, Integer rowOffSet, String query) {
        query = query+ ' LIMIT '+rowLimit +' OFFSET '+rowOffSet;
        System.debug('query::' + query);
		return Database.query(query);
	}

    @AuraEnabled(cacheable=true) 
    public static Integer countRecords(String countSOQL) {
		if (String.isNotEmpty(countSOQL)) {
			system.debug(database.countQuery(countSOQL));
			return database.countQuery(countSOQL);
		}
		return 0;
	  }	
	  
	@AuraEnabled
	public static Map<String, String> getRecordTypeInfos(String objectName){
		Map<String, String> recordTypeMap = new Map<String, String>();
		SobjectType sobjType = Schema.getGlobalDescribe().get(objectName);
		Schema.DescribeSObjectResult objectResult = sobjType.getDescribe();
		Map<Id, Schema.RecordTypeInfo> recordTypeInfos = objectResult.getRecordTypeInfosById();
		for( Id recordTypeId : recordTypeInfos.keySet() ){
			Schema.RecordTypeInfo recordType = recordTypeInfos.get(recordTypeId);
			if(recordType.isAvailable() && recordType.Name!='Master'){ 
				recordTypeMap.put(recordTypeId, recordType.Name);
  			}
		}
        System.debug('recordTypeMap::' + recordTypeMap);
		return recordTypeMap;
	}
	
	@AuraEnabled
    public static GetMetaData getObjectMetaData(String recordId, String fieldName, String relatedObjectName){
        GetMetaData metadata = new GetMetaData();
        String sObjName = ((Id)recordId).getSObjectType().getDescribe().getName();
        metadata.objectName = sObjName;
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(sObjName);
        Schema.SObjectType relatedObjectType = Schema.getGlobalDescribe().get(relatedObjectName);
        Schema.SObjectField relatedField = (Schema.SObjectField)getSObjectField(relatedObjectType,fieldName);
        for(Schema.ChildRelationship relation : objectType.getDescribe().getChildRelationships()){
            if(relation.getChildSObject() == relatedObjectType && relation.getField() == relatedField){
                metadata.relationShipName = relation.getRelationShipName();
                break;
            }
        }  
        return metadata;
    }
    
    public static Object getSObjectField(SObjectType o, String fieldName){
        if(fieldName.contains('.')){
            String nextField = fieldName.substringAfter('.');
            String relation = fieldName.substringBefore('.');
            return getSObjectField(Schema.getGlobalDescribe().get(relation),nextField);
        }
        return o.getDescribe().fields.getMap().get(fieldName);
    }
    
    public class GetMetaData{
        @AuraEnabled public String objectName;
        @AuraEnabled public String relationShipName;
    }
}