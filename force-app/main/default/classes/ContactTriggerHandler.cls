public class ContactTriggerHandler {
    public final static string STAFF_OOO_RECORDTYPE = 'Weekly OOO';
    
    public void afterInsertMethod(List<Contact> newRecords, Map<Id, Contact> newRecordsMap){
        createOutOfOfficeEntries(newRecordsMap);
    }
    
    public void afterUpdateMethod(List<Contact> newRecords, Map<Id, Contact> oldRecordsMap){
        updateOutOfOfficeEntries(newRecords, oldRecordsMap);
    }
    
    public static void createOutOfOfficeEntries(Map<Id, Contact> newRecordMap){
        List<OutOfOffice__c> weeklyOffList = new List<OutOfOffice__c>();
        Id recordTypeId = Schema.SObjectType.OutOfOffice__c.getRecordTypeInfosByName().get('Weekly OOO').getRecordTypeId();
        for(Id recordId : newRecordMap.keySet()){
            Contact c = newRecordMap.get(recordId);
            if(String.isNotBlank(c.WeeklyOff__c)){
                Date startDate = date.newinstance(c.CreatedDate.year(), c.CreatedDate.month(), c.CreatedDate.day());
                Date endDate = startDate.addMonths(6);
                List<String> days = c.WeeklyOff__c.split(';');
            	List<Date> dateList = calculateDates(startDate, endDate, days);
                for(Date offDate : dateList){
                    OutOfOffice__c weeklyOff = new OutOfOffice__c();
                    weeklyOff.Contact__c = c.Id;
                    weeklyOff.StartDate__c = weeklyOff.EndDate__c = offDate;
                    weeklyOff.Message__c = 'Week Off';
                    weeklyOff.RecordTypeId = recordTypeId;
                    weeklyOffList.add(weeklyOff);
                }
            }
        }
        
        if(!weeklyOffList.isEmpty()){
            insert weeklyOffList;
        }
    }
    
    public static void updateOutOfOfficeEntries(List<Contact> newRecords, Map<Id, Contact> oldRecordsMap){
        Set<Id> contactIds = new Set<Id>();
        Date reminderToBeDeletedFrom = System.today();
        Id recordTypeId = Schema.SObjectType.OutOfOffice__c.getRecordTypeInfosByName().get('Weekly OOO').getRecordTypeId();
        List<OutOfOffice__c> weeklyOffList = new List<OutOfOffice__c>();
        for(Contact c : newRecords){
            if(String.isNotBlank(c.WeeklyOff__c) && hasChanged(c,oldRecordsMap,'WeeklyOff__c')){
                Date startDate = date.newinstance(c.LastModifiedDate.year(), c.LastModifiedDate.month(), c.LastModifiedDate.day());
                contactIds.add(c.Id);
                reminderToBeDeletedFrom = startDate;
                Date endDate = startDate.addMonths(6);
                List<String> days = c.WeeklyOff__c.split(';');
            	List<Date> dateList = calculateDates(startDate, endDate, days);
                for(Date offDate : dateList){
                    OutOfOffice__c weeklyOff = new OutOfOffice__c();
                    weeklyOff.Contact__c = c.Id;
                    weeklyOff.RecordTypeId = recordTypeId;
                    weeklyOff.StartDate__c = weeklyOff.EndDate__c = offDate;
                    weeklyOff.Message__c = 'Weekly Off';
                    weeklyOffList.add(weeklyOff);
                }
            }
        }
        
        if(!contactIds.isEmpty()){
            delete [Select id, StartDate__c from OutOfOffice__c
                    WHERE Contact__c in: contactIds
                   AND RecordTypeId =: recordTypeId
                   AND StartDate__c >=: reminderToBeDeletedFrom];
        }
        
        if(!weeklyOffList.isEmpty()){
            insert weeklyOffList;
        }
    }
    
    public static boolean hasChanged(SObject newRecord, Map<Id, SObject > oldRecordMap, String fieldName) {
        return ((newRecord.get(fieldName) != null && oldRecordMap == null)
                || oldRecordMap != null && oldRecordMap.get(newRecord.Id).get(fieldName) != newRecord.get(fieldName))
            ? true : false;
    }
    
    public static List<Date> calculateDates(Date dtStartDate, Date stEndDate, List<String> dayList){
		List<Date> dateList = new List<Date>();
        while(dtStartDate < stEndDate){
            dtStartDate = dtStartDate.addDays(1);            
            datetime dt = datetime.newInstance(dtStartDate.year(), dtStartDate.month(), dtStartDate.day());
            if(dayList.contains(dt.format('EEEE'))){
                dateList.add(date.newinstance(dT.year(), dT.month(), dT.day()));
            }
        }
        return dateList;
    }
}