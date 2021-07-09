/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentPlanService {
    public void process(ServiceRequest req) {
        switch on req.Action {
            when 'validateTreatmentPlan' {
                handleValidity(req);
            }
        }
    }

    private static ServiceResponse handleValidity(ServiceRequest request) {
        System.debug('Handle Validity of Treatment Plan Is Executing');
        ServiceResponse response = new ServiceResponse(request);
        return response;
    }


}