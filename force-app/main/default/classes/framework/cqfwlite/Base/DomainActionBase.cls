/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public inherited sharing abstract class DomainActionBase implements iDomainAction {
    public ServiceResponse Execute(ServiceRequest request) {
        //System.debug('@@ EXECUTING SERVICE REQUEST' + request);
        ServiceResponse response = new ServiceResponse(request);
        try {
            TriggerRequest triggerRequest = TriggerRequest.FromSvcRequest(request);
            ProcessAction(triggerRequest);
            response.Status = RequestStatus.SUCCESS;
        } catch (Exception ex) {
            response.Status = RequestStatus.ERROR;
            response.ThrownException = ex;
        }
        return response;
    }

    public abstract void ProcessAction(TriggerRequest request);
}

/*<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
 *<> EXAMPLE, MULTI-ACTION PARENT CLASS WITH SEVERAL NESTED CHILD CLASSES FOR EACH ACTION <>
 *<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

public inherited sharing class XXXX_AccountTriggers {
    public class FixName extends DomainActionBase {
        public override void ProcessAction(TriggerRequest request) {
            @@ safety check request.isBefore/isAfter and the other trigger properties to be sure this is proper
            @@ do stuff here for/with name
        }
    }

    public class FixEmail extends DomainActionBase {
        public override void ProcessAction(TriggerRequest request) {
            // safety check request.isBefore/isAfter and the other trigger properties to be sure this is proper
            // do stuff here for/with email
        }
    }
}

 *<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
 *<> EXAMPLE, MULTI-ACTION PARENT CLASS WITH SEVERAL NESTED CHILD CLASSES FOR EACH ACTION <>
 *<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>*/