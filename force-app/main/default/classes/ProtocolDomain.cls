public with sharing class ProtocolDomain extends DomainActionBase {
    public override void ProcessAction(TriggerRequest request) {
        if (request.targetSObject == Protocol__c.SObjectType) {
            String triggerAction = request.action + request.process;

            switch on triggerAction {
                when 'BeforeInsert' { beforeInsert(request); }
                when 'BeforeUpdate' { beforeUpdate(request); }
                when 'BeforeDelete' { beforeDelete(request);}
                when 'AfterInsert' { afterInsert(request);}
                when 'AfterUpdate' { afterUpdate(request);}
                when 'AfterDelete' { afterDelete(request);}
            }
        }
        return;
    }

    @SuppressWarnings('ApexUnresolvableReference')
    public void beforeInsert(TriggerRequest request) {
        System.debug('PROTOCOL BEFORE INSERT IS EXECUTING');
    }
    
    public void beforeUpdate (TriggerRequest request) {
        System.debug('PROTOCOL BEFORE UPDATE IS EXECUTING');

    }

    public void beforeDelete (TriggerRequest request) { 
        System.debug('PROTOCOL BEFORE DELETE IS EXECUTING'); 
    }

    @SuppressWarnings('ApexUnresolvableReference')
    public void afterInsert(TriggerRequest request) {
        System.debug('PROTOCOL AFTER INSERT IS EXECUTING');
        Protocol__c[] newProtocols = (Protocol__c[]) request.newRecords;
        //insert the Protocol_Scale_Junction__c records
        insertProtocolScaleJunctions(newProtocols);

        System.debug('TREATMENT SESSION ROLLUP AFTER INSERT IS EXECUTING');
               
       List<Protocol__c> newRecords =  request.newRecords;
       Set<ID> setActiveProtocolIDs = new Set<ID>(); 
        for(Protocol__c objProtocol : newRecords){
            if(objProtocol.IsActive__c==true){
                setActiveProtocolIDs.add(objProtocol.id);
            }
        }
        if(!setActiveProtocolIDs.isEmpty()){
            List<Bundle_Entry__c> lstBundleEntry = new List<Bundle_Entry__c>();
                    Treatment_Bundle__c[] treatmentBundle = [SELECT id, Name FROM Treatment_Bundle__c WHERE Name ='Master' LIMIT 1];
                    if(!treatmentBundle.isEmpty()){
                        for(ID pID: setActiveProtocolIDs){
                            Bundle_Entry__c obj = new Bundle_Entry__c();
                            obj.Protocol__c= pID;
                            obj.Treatment_Bundle__c= treatmentBundle[0].id;
                            lstBundleEntry.add(obj);
                        }
                try {
                    insert lstBundleEntry;
                } catch(Exception e) {
                    System.debug(e.getMessage());
                }
            }
        }
    }

    public void afterUpdate (TriggerRequest request) {
        System.debug('PROTOCOL AFTER UPDATE IS EXECUTING');
        System.debug('TREATMENT SESSION ROLLUP BEFORE INSERT IS EXECUTING'); 
 		
        List<Protocol__c> newRecords =  request.newRecords;
		Map<Id, Protocol__c> oldRecordMap = (Map<Id, Protocol__c>) request.oldRecordMap;
        Set<ID> setInActiveProtocolIDs = new Set<ID>(); 
        Set<ID> setActiveProtocolIDs = new Set<ID>(); 
        for(Protocol__c objProtocol : newRecords){
            Protocol__c oldProtocol = oldRecordMap.get(objProtocol.ID);
            system.debug('#####NewProtocol '+objProtocol.IsActive__c);
            system.debug('#####oldProtocol '+oldProtocol.IsActive__c);
            if(objProtocol.IsActive__c==false && oldProtocol.IsActive__c==True ){
                setInActiveProtocolIDs.add(objProtocol.id);
            }
             if(objProtocol.IsActive__c==True && oldProtocol.IsActive__c==False ){
                setActiveProtocolIDs.add(objProtocol.id);
            }
        }
         if(!setInActiveProtocolIDs.isEmpty()){
            List<Bundle_Entry__c> lstBundleEntry = new List<Bundle_Entry__c>();
                   
                List<Bundle_Entry__c> listBundleEntries = [SELECT id, Name FROM Bundle_Entry__c WHERE Protocol__c IN: setInActiveProtocolIDs];
                if(!listBundleEntries.isEmpty()){                    
                    for(Bundle_Entry__c be: listBundleEntries){
                        Bundle_Entry__c obj = new Bundle_Entry__c();
                        obj.id= be.id;                        
                        lstBundleEntry.add(obj);
                    }
                try {
                    Delete lstBundleEntry;
                } catch(Exception e) {
                    System.debug(e.getMessage());
                }
            }
        }
        else if(!setActiveProtocolIDs.isEmpty()){
            List<Bundle_Entry__c> lstBundleEntry = new List<Bundle_Entry__c>();
                    Treatment_Bundle__c[] treatmentBundles = [SELECT id, Name FROM Treatment_Bundle__c WHERE Name ='Master' LIMIT 1];

                    if(treatmentBundles!=null && !treatmentBundles.isEmpty()){
                        Treatment_Bundle__c treatmentBundle = treatmentBundles[0];
                        for(ID pID: setActiveProtocolIDs){
                            Bundle_Entry__c obj = new Bundle_Entry__c();
                            obj.Protocol__c= pID;
                            obj.Treatment_Bundle__c= treatmentBundle.id;
                            lstBundleEntry.add(obj);
                        }
                try {
                    insert lstBundleEntry;
                } catch(Exception e) {
                    System.debug(e.getMessage());
                }
            }
        }
    }

    public void afterDelete (TriggerRequest request) { System.debug('PROTOCOL AFTER INSERT IS EXECUTING'); }


    private static void insertProtocolScaleJunctions(Protocol__c[] protocols){
        //get a list of default protocol scales
        Protocol_Scale__c[] scales = [SELECT Id FROM Protocol_Scale__c WHERE isActive__c = true AND isDefault__c = true];
        Protocol_Scale_Junction__c[] recordsToInsert = new Protocol_Scale_Junction__c[0];
        for(Protocol__c proto : protocols){
            if(proto.IsActive__c == true){
                for(Protocol_Scale__c scale : scales){
                    recordsToInsert.add(new Protocol_Scale_Junction__c(
                        Protocol__c = proto.Id,
                        Protocol_Scale__c = scale.Id
                    ));
                }
            }
        }
        insert recordsToInsert;
    }
}