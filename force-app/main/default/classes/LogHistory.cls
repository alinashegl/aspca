public without sharing class LogHistory {
    public static void LogHistory(Map<Id, SObject> oldRecordMap, List<SObject> records){
        if(oldRecordMap == null || records == null){
            return;
        }
        
        List<SObject> histories = new List<SObject>();
        for(SObject obj : records){
            histories.addAll(LogHistory(obj, oldRecordMap));
        }
        if(histories.size() > 0){
            insert histories;
        }
    }
    
    public static List<SObject> LogHistory(Sobject record, Map<Id, SObject> oldRecord){
        List<EntityHistory__c> histories = new List<EntityHistory__c>();
        String objectApiName = (getObjectName(record.Id)).toLowerCase();
        if(objectFieldMap.containsKey(objectApiName)){
            for(String fieldName : objectFieldMap.get(objectApiName)){
                if(hasChanged(record, oldRecord, fieldName)){
                    EntityHistory__c history = new EntityHistory__c();
                    history.RecordName__c = String.valueof(record.get('name')); 
                    if(objectApiName == 'behavior_evaluation__c'){
                        history.ParentId__c = String.valueof(record.get('animal__c'));
                    }
                    history.FieldName__c = getFieldLabel(objectApiName, fieldName);
                    history.OldValue__c = String.valueOf(oldRecord.get(record.Id).get(fieldName));
                    history.NewValue__c = String.valueOf(record.get(fieldName));
                    if(fieldName == 'current_behavior_grade__c' || fieldName == 'overall_evaluation_grade__c'){
                        history.OldValue__c = String.valueOf(oldRecord.get(record.Id).get(fieldName)) ;//+ ' - ' + String.valueOf(oldRecord.get(record.Id).get('grade_change_reason__c'));
                        history.NewValue__c = String.valueOf(record.get(fieldName)) + ' - ' + String.valueOf(record.get('grade_change_reason__c'));
                    }
                    history.ObjectId__c = record.Id;
                    history.ObjectName__c = getObjectLabel(record.Id);
                    if(history.ObjectName__c.equalsIgnoreCase('Animal')){
                        history.Animal__c = record.Id;
                    } else {
                        history.Animal__c = history.ParentId__c;
                    }
                    histories.add(history);
                }
            }
        }
        return histories;
    }
    
    public static boolean hasChanged(SObject newRecord, Map<Id, SObject > oldRecordMap, String fieldName) {
        return ((newRecord.get(fieldName) != null && oldRecordMap == null)
                || oldRecordMap != null && oldRecordMap.get(newRecord.Id).get(fieldName) != newRecord.get(fieldName))
            ? true : false;
    }
    
    public static String getObjectName(Id sId){
        return sId.getSObjectType().getDescribe().getName();
    }
    
    public static String getObjectLabel(Id sId){
        return sId.getSObjectType().getDescribe().getLabel();
    }
    
    public static String getFieldLabel(String ObjectApi, String FieldApi){
        return (String)Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(FieldApi).getDescribe().getLabel()+' \n';
    }
    
    @AuraEnabled(cacheable=true)
    public static List<EntityHistory__c> getAnimalHistory(String recordId, String searchKey, String dateFilter, String sortBy, String sortDirection) {
        
        String query = 'SELECT Id, RecordName__c, OwnerId, IsDeleted, Name, CreatedDate, CreatedBy.Name, FieldName__c, NewValue__c, OldValue__c, ObjectId__c, ObjectName__c FROM EntityHistory__c WHERE ObjectName__c = \'Animal\'';
        
        if ( recordId != null && recordId != '' ) {
            query += ' AND ObjectId__c = \''+recordId+'\'';
        }
        
        if ( dateFilter != null && dateFilter != '' ) {
            query += ' AND '+dateFilter;
        }
        
        if ( searchKey != null && searchKey != '' ) {
            String key = '%' + searchKey + '%';
            query += ' AND FieldName__c LIKE :key';
        }
        if ( sortBy != null && sortDirection != null ) {
            query += ' ORDER BY ' + sortBy + ' ' + sortDirection;
        }
        System.debug(query);
        return Database.query( query );
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<EntityHistory__c> getBehaviorEvaluationHistory(String recordId, String searchKey, String dateFilter, String sortBy, String sortDirection) {
        
        String query = 'SELECT Id, RecordName__c, OwnerId, IsDeleted, Name, CreatedDate, CreatedBy.Name, FieldName__c, NewValue__c, OldValue__c, ObjectId__c, ObjectName__c FROM EntityHistory__c WHERE ObjectName__c = \'Behavior Evaluation\'';
        
        if ( recordId != null && recordId != '' ) {
            query += ' AND ParentId__c = \''+recordId+'\'';
        }
        
        if ( dateFilter != null && dateFilter != '' ) {
            query += ' AND '+dateFilter;
        }
        
        if ( searchKey != null && searchKey != '' ) {
            String key = '%' + searchKey + '%';
            query += ' AND FieldName__c LIKE :key';
        }
        if ( sortBy != null && sortDirection != null ) {
            query += ' ORDER BY ' + sortBy + ' ' + sortDirection;
        }
        System.debug(query);
        return Database.query( query );
    }
    
    private static Map<String, Set<String>> objectFieldMap = new Map<String, Set<String>>{
        'animal__c' => new Set<String> {'handling_instructions__c', 'shelter_color_coding__c', 'play_style_notes__c','designated_handler_reason__c','current_behavior_grade__c','grade_change_reason__c','behavior_summary__c'},  
        'behavior_evaluation__c' => new Set<String> {'overall_evaluation_grade__c','grade_change_reason__c'}
    };    
        
        
}