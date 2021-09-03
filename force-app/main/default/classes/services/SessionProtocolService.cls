/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class SessionProtocolService {
    public static List<ServiceResponse> processRequest(List<ServiceRequest> requests) {
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
            } when 'handleSession' {
                response = handleSession(request);
            }
        }
        return response;
    }

    private static ServiceResponse handleValidity(ServiceRequest request) {
        Treatment_Session__c quote = (Treatment_Session__c) request.Parameters.get('treatmentSession');

        Map<String,Map<String,String>> resultMap = new Map<String, Map<String, String>>();
        String success = 'SUCCESS';
        if (quote != null) {
            SessionProtocolSelector selector = new SessionProtocolSelector();
            List<Session_Protocol__c> lineItems = selector.GetByQuote(quote.Id);
            System.debug(lineItems);
            ProtocolSelector protocolSelector = new ProtocolSelector();

            for (Session_Protocol__c item : lineItems) {
                Map<String, String> result = new Map<String, String>();
                Set<Id> idset = new Set<Id>();
                idset.add(item.ProtocolId__c);
                Protocol__c product2 = protocolSelector.GetById(idset)[0];
                String invalid = 'INVALID';
                String none = 'None';
                try {
                    if (item.Fear_Best__c == none) {
                        result.put('Fear Best', invalid);
                    }
                    if (item.Fear_Worst__c == none) {
                        result.put('Fear Worst', invalid);
                    }
                    if (item.Arousal_Best__c == none) {
                        result.put('AROUSAL BEST', invalid);
                    }
                    if(item.Arousal_Worst__c == none) {
                        result.put('AROUSAL WORST', invalid);
                    }
                    if (item.Social_Best__c == none) {
                        result.put('SOCIAL BEST', invalid);
                    }
                    if (item.Aggressive_Worst__c == none) {
                        result.put('AGGRESSIVE WORST', invalid);
                    }
                    if (item.Overall_Score__c == none) {
                        result.put('OVERALL SCORE', invalid);
                    }
                }catch (Exception e) {
                    System.debug(e);
                    result.put('ERROR', String.valueOf(e));
                }
                resultMap.put(product2.Name, result);
            }
        }
        ServiceResponse response = new ServiceResponse(request);
        if (resultMap == null || resultMap.size() == 0) {
            resultMap.put(success, new Map<String, String>{ success => success});
        }
        response.Data = resultMap;
        return response;
    }

    private static ServiceResponse handleSession(ServiceRequest request) {
        Map<String, Map<String, Object>> resultMap = new Map<String, Map<String, Object>>();

        TreatmentSessionSelector treatmentSessionSelector = new TreatmentSessionSelector();
        Set<Id> idset = new Set<Id>();
        idset.add((Id) request.Parameters.get('record'));
        List<Treatment_Session__c> treatmentSessions = new List<Treatment_Session__c>();
        treatmentSessions = treatmentSessionSelector.GetByIds(idset);
        Treatment_Session__c session = treatmentSessions[0];
        SessionProtocolSelector sessionProtocolSelector = new SessionProtocolSelector();
        List<Session_Protocol__c> sessionProtocols = new List<Session_Protocol__c>();
        sessionProtocols = [SELECT Id, TreatmentSessionId__c, InView__c from Session_Protocol__c];
        List<Session_Protocol__c> partOfView = new List<Session_Protocol__c>();
        List<Session_Protocol__c> NotPartOfView = new List<Session_Protocol__c>();

        for (Session_Protocol__c protocol : sessionProtocols) {
            if (protocol.TreatmentSessionId__c == session.Id) {
                partOfView.add(protocol);
                protocol.InView__c = true;
            }else {
                NotPartOfView.add(protocol);
                protocol.InView__c = false;
            }
        }
        update partOfView;
        update NotPartOfView;

        ServiceResponse response = new ServiceResponse(request);
        resultMap.put('PART OF VIEW', new Map<String, Object>{'IN VIEW' => partOfView});
        resultMap.put('NOT IN VIEW', new Map<String, Object>{'NOT IN VIEW' => NotPartOfView});
        response.Data = resultMap;
        return response;
    }
}