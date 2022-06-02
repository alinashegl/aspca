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
    }

    public void afterUpdate (TriggerRequest request) {
        System.debug('PROTOCOL AFTER UPDATE IS EXECUTING');
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
