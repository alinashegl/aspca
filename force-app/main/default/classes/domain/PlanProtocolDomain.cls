/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class PlanProtocolDomain extends DomainActionBase {
    public override void ProcessAction(TriggerRequest request) {
        if (request.targetSObject == OpportunityLineItem.SObjectType) {
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

    public void beforeInsert (TriggerRequest request) {System.debug('PLAN PROTOCOL BEFORE INSERT IS EXECUTING'); }
    public void beforeUpdate (TriggerRequest request) {
        //System.debug('PLAN PROTOCOL BEFORE UPDATE IS EXECUTING === > ' + request.newRecords);

        //insert request.newRecords;
    }
    public void beforeDelete (TriggerRequest request) { System.debug('PLAN PROTOCOL BEFORE DELETE IS EXECUTING'); }
    public void afterInsert (TriggerRequest request) {
        System.debug('PLAN PROTOCOL AFTER INSERT IS EXECUTING');
        Map<Id, OpportunityLineItem> itemMap = (Map<Id, OpportunityLineItem>) request.newRecordMap;
        List<OpportunityLineItem> toDelete = new List<OpportunityLineItem>();
        Map<String, Id> uniqueNames = new Map<String, Id>();
        for (OpportunityLineItem item : itemMap.values()) {
            uniqueNames.put(item.Name, item.Id);
        }
        for (Id un : uniqueNames.values()) {
            OpportunityLineItem item = itemMap.get(un);
            for (OpportunityLineItem nItem : itemMap.values()) {
                if (nItem.Id != un) {
                    toDelete.add(nItem);
                }
            }
        }
        delete toDelete;
    }
    public void afterUpdate (TriggerRequest request) {
        System.debug('PLAN PROTOCOL AFTER UPDATE IS EXECUTING');
        Map<Id, OpportunityLineItem> itemMap = (Map<Id, OpportunityLineItem>) request.newRecordMap;
        List<OpportunityLineItem> toDelete = new List<OpportunityLineItem>();
        Map<String, Id> uniqueNames = new Map<String, Id>();
        for (OpportunityLineItem item : itemMap.values()) {
            uniqueNames.put(item.Name, item.Id);
        }
        List<String> strings = new List<String>(uniqueNames.keySet());
        for (String str : strings) {
            Id key = uniqueNames.get(str);
            for (OpportunityLineItem item : itemMap.values()) {
                if (item.id != key) {
                    toDelete.add(item);
                }
            }
            for (OpportunityLineItem dItem : toDelete) {
                if (dItem.Id == key) {
                    Integer k = toDelete.indexOf(dItem);
                    toDelete.remove(k);
                }
            }
        }
        System.debug(toDelete);
        delete toDelete;

    }
    public void afterDelete (TriggerRequest request) { System.debug('PLAN PROTOCOL AFTER INSERT IS EXECUTING'); }
}