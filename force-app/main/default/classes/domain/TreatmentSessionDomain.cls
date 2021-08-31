/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentSessionDomain extends DomainActionBase {
    public override void ProcessAction(TriggerRequest request) {
        if (request.targetSObject == Quote.SObjectType) {
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
    public void beforeUpdate (TriggerRequest request) { System.debug('PLAN PROTOCOL BEFORE UPDATE IS EXECUTING'); }
    public void beforeDelete (TriggerRequest request) { System.debug('PLAN PROTOCOL BEFORE DELETE IS EXECUTING'); }
    public void afterInsert (TriggerRequest request) { System.debug('PLAN PROTOCOL AFTER INSERT IS EXECUTING'); }
    public void afterUpdate (TriggerRequest request) { System.debug('PLAN PROTOCOL AFTER INSERT IS EXECUTING'); }
    public void afterDelete (TriggerRequest request) { System.debug('PLAN PROTOCOL AFTER INSERT IS EXECUTING'); }

}