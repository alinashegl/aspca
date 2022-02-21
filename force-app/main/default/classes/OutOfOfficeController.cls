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
    // 
    public static void handleOutOfOfficeSchedule(){
        Date endDate = System.today().addDays(6);
        List<OutOfOffice__c> records = [Select Id, Contact__c, StartDate__c, EndDate__c FROM OutOfOffice__c
                                        WHERE  EndDate__c >= :System.today() 
                                        AND EndDate__c <= : endDate 
                                        Order by CreatedDate, Contact__c ASC];
        Map<Id, Date> contactByEndDate = new Map<Id, Date>();
        for(OutOfOffice__c out : records){
            contactByEndDate.put(out.Contact__c, out.EndDate__c);
        }
        
        for(Id contactId : contactByEndDate.keySet()){
            
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