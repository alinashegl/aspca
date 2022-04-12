/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class PlanProtocolDomain extends DomainActionBase {
    public override void ProcessAction(TriggerRequest request) {
        if (request.targetSObject == Plan_Protocol__c.SObjectType) {
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

    public void beforeInsert (TriggerRequest request) {
        System.debug('PLAN PROTOCOL BEFORE INSERT IS EXECUTING'); 
        //if protocol notes are added - update the Notes Last Modified Date field
        for(Plan_Protocol__c pp : (Plan_Protocol__c[]) request.newRecords){
            if(pp.Protocol_Notes__c != null){
                pp.Notes_Last_Modified_Date__c = date.today();
            }
        }
    }
    public void beforeUpdate (TriggerRequest request) {
        //if protocol notes are added/updated - update the Notes Last Modified Date field
        Map<Id, Plan_Protocol__c> oldMap = (Map<Id,Plan_Protocol__c>) request.oldRecordMap;
        for(Plan_Protocol__c pp : (Plan_Protocol__c[]) request.newRecords){
            if(pp.Protocol_Notes__c != oldMap.get(pp.Id).Protocol_Notes__c){
                pp.Notes_Last_Modified_Date__c = date.today();
            }
        }
    }
    public void beforeDelete (TriggerRequest request) { System.debug('PLAN PROTOCOL BEFORE DELETE IS EXECUTING'); }
    public void afterInsert (TriggerRequest request) {
        // System.debug('PLAN PROTOCOL AFTER INSERT IS EXECUTING');
        // Map<Id, OpportunityLineItem> itemMap = (Map<Id, OpportunityLineItem>) request.newRecordMap;
        // List<OpportunityLineItem> toDelete = new List<OpportunityLineItem>();
        // Map<String, Id> uniqueNames = new Map<String, Id>();
        // for (OpportunityLineItem item : itemMap.values()) {
        //     uniqueNames.put(item.Name, item.Id);
        // }
        // for (Id un : uniqueNames.values()) {
        //     OpportunityLineItem item = itemMap.get(un);
        //     for (OpportunityLineItem nItem : itemMap.values()) {
        //         if (nItem.Id != un) {
        //             toDelete.add(nItem);
        //         }
        //     }
        // }
        // delete toDelete;
    }
    public void afterUpdate (TriggerRequest request) {
        // System.debug('PLAN PROTOCOL AFTER UPDATE IS EXECUTING');
        // Map<Id, OpportunityLineItem> itemMap = (Map<Id, OpportunityLineItem>) request.newRecordMap;
        // List<OpportunityLineItem> toDelete = new List<OpportunityLineItem>();
        // Map<String, Id> uniqueNames = new Map<String, Id>();
        // for (OpportunityLineItem item : itemMap.values()) {
        //     uniqueNames.put(item.Name, item.Id);
        // }
        // List<String> strings = new List<String>(uniqueNames.keySet());
        // for (String str : strings) {
        //     Id key = uniqueNames.get(str);
        //     for (OpportunityLineItem item : itemMap.values()) {
        //         if (item.id != key) {
        //             toDelete.add(item);
        //         }
        //     }
        //     for (OpportunityLineItem dItem : toDelete) {
        //         if (dItem.Id == key) {
        //             Integer k = toDelete.indexOf(dItem);
        //             toDelete.remove(k);
        //         }
        //     }
        // }
        // System.debug(toDelete);
        // delete toDelete;

    }
    public void afterDelete (TriggerRequest request) { System.debug('PLAN PROTOCOL AFTER INSERT IS EXECUTING'); }
}