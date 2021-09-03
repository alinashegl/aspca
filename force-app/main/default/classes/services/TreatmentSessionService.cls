/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentSessionService {
    public List<ServiceResponse> processRequest(List<ServiceRequest> requests) {
        List<ServiceResponse> responses = new List<ServiceResponse>();
        for(ServiceRequest request : requests) {
            responses.add(processReq(request));
        }
        return responses;
    }
    public void executeAll(List<ServiceRequest> requests) {
        for (ServiceRequest request : requests) {
            process(request);
            ServiceResponse response = new ServiceResponse(request);
            System.debug('executed request + ' + request);
        }
    }

    public void process(ServiceRequest req) {
        switch on req.Action {
            when 'validateSession' {
                handleValidity(req);
            }
        }
    }

    public static ServiceResponse processReq(ServiceRequest request) {
        ServiceResponse response = new ServiceResponse(request);
        switch on request.Action {
            when 'validateSession' {
                response = handleValidity(request);
            }
        }
        return response;
    }

    private static ServiceResponse handleValidity(ServiceRequest request) {
        ServiceResponse response = new ServiceResponse(request);
        Id recordId = (Id) request.Parameters.get('recordId');
        Set<Id> keys = new Set<Id>();
        keys.add(recordId);
        TreatmentSessionSelector selector = new TreatmentSessionSelector();
        List<Treatment_Session__c> quotes = selector.GetByIds(keys);
        Treatment_Session__c quote = quotes[0];
        Map<String, String> result = new Map<String, String>();
        ServiceRequest serviceRequest = new ServiceRequest();
        serviceRequest.Action = 'validateSession';
        serviceRequest.withParams('treatmentSession', quote);
        response = SessionProtocolService.processReq(serviceRequest);

        return response;
    }
}