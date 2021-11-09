/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class SObjectDomain implements iSObjectDomain{
    private TriggerProcess triggerProcess;
    private TriggerRequest request;
    private Boolean disableTrigger = false;

    public SObjectDomain(TriggerRequest triggerRequest) {
        request = triggerRequest;
        if (request == null) { disableTrigger = true; }
    }

    private Boolean TriggersDisabled() {
        if (disableTrigger) { return disableTrigger; }
        Trigger_Config__c triggerConfig = Trigger_Config__c.getInstance();
        return (triggerConfig != null && triggerConfig.Disable_Triggers__c == true);
    }

    /**
     * Queries Domain_Action_Binding__mdt to find all DomainAction implementations
     * Then executes them in sequence, passing in the Trigger's state & data
     */
    public void ExecuteTriggerActions() {
        if (TriggersDisabled()) { return; }
        List<Domain_Action_Binding__mdt> bindings = cq.App.DomainActionBindings().GetForTrigger(request.targetSObject.getDescribe().getName(), request.action, request.process);
        for (Domain_Action_Binding__mdt binding : bindings) {
            String actionName = binding.DomainActionImplementation__c;
            //System.debug('Domain Action Bindings ==> ' + actionName);
            if (String.isBlank(actionName)) { continue; }
            Type actionType = Type.forName(actionName);
            //System.debug('Action Type ==> ' + actionType);
            if (actionType instanceOf iDomainAction) {
                iDomainAction dynamicAction = (iDomainAction) actionType.newInstance();
                //System.debug('Domain Action ==> ' + dynamicAction);
                ServiceResponse response = dynamicAction.Execute(
                        new ServiceRequest(actionName, request.process + ' ' + request.action).WithParams
                                ('TriggerRequest', request)
                );
                //System.debug(response);
                if (response.Status == RequestStatus.ERROR) {
                    LogHandler.Instance.Error(response.ThrownException);
                }
            }
        }
    }
}