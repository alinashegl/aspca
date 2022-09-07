public class OutOfOfficeController {
    @AuraEnabled
    public static List<Map<String, String>> getOutOfOfficeRTs(){
        Schema.DescribeSObjectResult R = OutOfOffice__c.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        List<Map<String, String>> rtInfo = new List<Map<String, String>>();
        for(Schema.RecordTypeInfo rti : RT){
            if(rti.isActive() && rti.getName() != 'Master' && rti.getName() != 'Weekly OOO'){
                rtInfo.add(new Map<String, String>{'value' => rti.getRecordTypeId(), 'label' => rti.getName()});
            }   
        }
        return rtInfo;
    }
    
    @AuraEnabled
    public static ContactResult getContactId(){
        ContactResult result = new ContactResult();
        List<Contact> contacts = [Select Id, Name from Contact where User__c =: UserInfo.getUserId()];
        if(contacts.size()>0){
            result.contactId = contacts[0].Id;
            result.contactName = contacts[0].Name;
            result.isSuccess = true;
        } else {
            result.message = 'Please reach out to Administrator to associate user and contact details';
        }
        return result;
    }
    
    
    // Method is used to run weekly check and create new entries in outofoffice based on enddates
    public static void handleOutOfOfficeSchedule(){
        Date endDate = System.today().addMonths(6);
        List<AggregateResult> records = [Select Contact__c, Max(EndDate__c) endDate FROM OutOfOffice__c WHERE Contact__r.WeeklyOff__c != NULL Group by Contact__c];
        Map<Id, Date> contactByEndDate = new Map<Id, Date>();
        for(AggregateResult out : records){
            Date dDate = (Date)out.get('endDate');
            if(dDate >= endDate.addDays(-6) && dDate <= endDate){
                contactByEndDate.put((Id)out.get('Contact__c'), dDate);
            }
        }
        System.debug(contactByEndDate);
        if(!((contactByEndDate.keySet()).isEmpty())){
            Map<Id, Contact> contactMap = new Map<Id, Contact>([Select Id, WeeklyOff__c from Contact Where Id IN : contactByEndDate.keySet()]);
            List<OutOfOffice__c> weeklyOffList = new List<OutOfOffice__c>();
            for(Id contactId : contactByEndDate.keySet()){
                Contact c = contactMap.get(contactId);
                if(String.isNotBlank(c.WeeklyOff__c)){
                    Date startDate = contactByEndDate.get(contactId).addDays(1);
                    Date endDate6Days = startDate.addDays(6);
                    List<String> days = c.WeeklyOff__c.split(';');
                    List<Date> dateList = ContactTriggerHandler.calculateDates(startDate, endDate6Days, days);
                    for(Date offDate : dateList){
                        OutOfOffice__c weeklyOff = new OutOfOffice__c();
                        weeklyOff.Contact__c = contactId;
                        weeklyOff.StartDate__c = weeklyOff.EndDate__c = offDate;
                        weeklyOff.Message__c = 'Week Off';
                        weeklyOffList.add(weeklyOff);
                    }
                }
            }
            
            if(!weeklyOffList.isEmpty()){
                //insert weeklyOffList;
            }
        }
    }
    
    public class ContactResult extends BaseResult{
        @AuraEnabled 
        public String contactId;
        @AuraEnabled
        public String contactName;
        public ContactResult(){
            super();
        }
    }
    
    public virtual class BaseResult{
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public String messageType;
        
        public BaseResult(){
            this.isSuccess = false;
            this.message = this.messageType = 'Error';
        }
        
    }
    
    
}