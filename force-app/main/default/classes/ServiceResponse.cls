/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class ServiceResponse {
    public ServiceRequest Request { get; set; }
    public RequestStatus Status { get; set; }
    public Exception ThrownException { get; set; }
    public Object Data { get; set; }

    public ServiceResponse(ServiceRequest request) {
        Request = request;
    }

    public ServiceResponse(ServiceRequest req, RequestStatus stat) {
        Request = req;
        Status = stat;
    }
    public  ServiceResponse(ServiceRequest req, RequestStatus stat, Exception ex) {
        Request = req;
        Status = stat;
        ThrownException = ex;
    }

    public ServiceResponse(ServiceRequest req, RequestStatus stat, Object dt) {
        Request = req;
        Status = stat;
        Data = dt;
    }

    public class CriteriaException extends Exception {}
    public class SelectorBindingException extends Exception {}
}