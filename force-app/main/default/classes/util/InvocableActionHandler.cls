/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

global with sharing class InvocableActionHandler{
    global class InvocableActionRequest {
        @InvocableVariable(required=true)
        global String action;

        @InvocableVariable(required=true)
        global String name;

        @InvocableVariable(required=true)
        global Id recordId;

        @InvocableVariable(required=true)
        global String targetSObject;
    }

    global class InvocableActionResponse {
        @InvocableVariable(required=true)
        global String RequestName;

        @InvocableVariable(required=true)
        global String ResponseValue;
    }

    @InvocableMethod(label='Invoke Action' Description='Invoke an apex action using this method. Ensure the target sObject, recordId, request action, and request name are part of the request in order to function correctly. Look at InvocableActionHandler for implementation instructions')
    public static List<InvocableActionResponse> invocableAction(List<InvocableActionRequest> requests) {
        List<InvocableActionResponse> responses = new List<InvocableActionHandler.InvocableActionResponse>();
        for(InvocableActionRequest request : requests) {
            responses.add(process(request));
        }
        return responses;
    }

    public static InvocableActionResponse process(InvocableActionRequest request) {
        System.debug(request);
        InvocableActionResponse resp = new InvocableActionResponse();
        switch on request.targetSObject {
            when 'Quote' {
                switch on request.action {
                    when 'validateSession' {
                        // resp = quoteRequest(request);
                    }
                }
            }when 'Treatment_Plan__c' {
                switch on request.action {
                    when 'assignPlan' {
                        // resp = assignPlanFromEval(request);
                    }
                }
            }
        }
        return resp;
    }

    // private static InvocableActionResponse quoteRequest(InvocableActionRequest request) {
    //     ServiceRequest serviceRequest = new ServiceRequest();
    //     serviceRequest.Name = request.name;
    //     serviceRequest.Action = request.action;
    //     serviceRequest.withParams('recordId', request.recordId);

    //     ServiceResponse serviceResponse = TreatmentSessionService.processReq(serviceRequest);
    //     InvocableActionResponse response = new InvocableActionResponse();
    //     response.RequestName = 'Validate Treatment Session';
    //     Map<String, Map<String, String>> responsesStrings = (Map<String, Map<String, String>>) serviceResponse.Data;
    //     String resp = '<p>';
    //     String brk = '<br>';
    //     for (String str : responsesStrings.keySet()) {
    //         if (responsesStrings.size() == 1 && str == 'SUCCESS') {
    //             resp = str;
    //         }else if(responsesStrings.size() > 1){
    //             resp = resp + str + brk + '---------------' + brk;
    //             Map<String, String> stringMap = responsesStrings.get(str);
    //             for (String rng : stringMap.keySet()) {
    //                 resp = resp + rng + ' = ' + stringMap.get(rng) + brk;
    //             }
    //         }
    //         resp = resp + brk + brk;
    //     }
    //     response.ResponseValue = resp;
    //     return response;
    // }

    // private static InvocableActionResponse assignPlanFromEval(InvocableActionRequest request) {
    //     //TreatmentPlanService service = new TreatmentPlanService();

    //     ServiceRequest serviceRequest = new ServiceRequest();
    //     serviceRequest.Action = 'assignPlan';
    //     serviceRequest.withParams('recordId', request.recordId);
    //     serviceRequest.Name = 'AssignPlanFlow';
    //     ServiceResponse serviceResponse = TreatmentPlanService.process(serviceRequest);

    //     InvocableActionResponse response = new InvocableActionResponse();
    //     System.debug(request);
    //     response.RequestName = request.name;
    //     response.ResponseValue = (String) serviceResponse.Data;

    //     System.debug(response);
    //     return response;

    // }
}