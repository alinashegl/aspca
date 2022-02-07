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
                    history.ObjectId__c = record.Id;
                    history.ObjectName__c = getObjectLabel(record.Id);
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
    
    private static Map<String, Set<String>> objectFieldMap = new Map<String, Set<String>>{
        'animal__c' => new Set<String> {'handling_instructions__c', 'shelter_color_coding__c', 'play_style_notes__c','	Designated_Handler_Reason__c'},  
        'behavior_evaluation__c' => new Set<String> {'overall_evaluation_grade__c'}
    };    
}