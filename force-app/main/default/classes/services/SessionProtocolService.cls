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
            } when 'beforeInsertHandler' {
                response = beforeInsertHandler(request);
            }when 'beforeUpdateHandler' {
                response = beforeUpdateHandler(request);
            }when 'removeHandler' {
                response = removeHandler(request);
            }when else {
                return null;
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

    private static ServiceResponse beforeInsertHandler(ServiceRequest request) {
        Treatment_Plan__c plan = (Treatment_Plan__c) request.Parameters.get('plan');
        Treatment_Session__c session = (Treatment_Session__c) request.Parameters.get('session');
        PlanProtocolSelector planProtocolSelector = new PlanProtocolSelector();
        List<Plan_Protocol__c> planProtocols = planProtocolSelector.GetByOpp(plan.Id);
        List<Session_Protocol__c> protocols = new List<Session_Protocol__c>();
        
        for (Plan_Protocol__c lPlanProtocol : planProtocols) {
            Session_Protocol__c protocol = new Session_Protocol__c();
            protocol.TreatmentSessionId__c = session.Id;
            protocol.ProtocolId__c = lPlanProtocol.Protocol__c;
            protocol.Bundle_Entry__c = lPlanProtocol.Bundle_Entry__c;
            protocol.Preferred_Motivators__c = session.Preferred_Motivators__c;
            protocols.add(protocol);
        }
        insert protocols;

        ServiceResponse response = new ServiceResponse(request);
        response.Data = protocols;
        return response;
    }

    private static ServiceResponse beforeUpdateHandler(ServiceRequest request) {
        List<Session_Protocol__c> protocols = (List<Session_Protocol__c>) request.Parameters.get('protocols');
        TreatmentSessionSelector sessionSelector = new TreatmentSessionSelector();
        Set<Id> idstoQuery = new Set<Id>();
        for(Session_Protocol__c oProtocol : protocols) {
            idstoQuery.add(oProtocol.TreatmentSessionId__c);
        }
        List<Plan_Protocol__c> planProtocolList = new List<Plan_Protocol__c>();
        Map<Id, Treatment_Session__c> sessionMap = new Map<Id, Treatment_Session__c>(sessionSelector.GetByIds(idstoQuery));
        List<Plan_Protocol__c> planProtocols = new List<Plan_Protocol__c>();
        for (Session_Protocol__c protocol : protocols) {
            if(protocol.Add_to_Plan__c = true) {
                Plan_Protocol__c planProtocol = new Plan_Protocol__c();
                Treatment_Session__c session = sessionMap.get(protocol.TreatmentSessionId__c);
                List<Plan_Protocol__c> planProtocols2 = [SELECT Id, Treatment_Plan__c, Protocol__c FROM Plan_Protocol__c WHERE Treatment_Plan__c =: session.Treatment_Plan__c];
                Set<Id> protocolIds = new Set<Id>();
                for(Plan_Protocol__c pp2 : planProtocols2) {
                    protocolIds.add(pp2.Protocol__c);
                }
                if(!protocolIds.contains(protocol.ProtocolId__c)) {
                    planProtocol.Treatment_Plan__c = session.Treatment_Plan__c;
                    planProtocol.Bundle_Entry__c = protocol.Bundle_Entry__c != null ? protocol.Bundle_Entry__c : null ;
                    planProtocol.Protocol__c = protocol.ProtocolId__c;
                    planProtocols.add(planProtocol);
                }
            }

            if (protocol.IsRemoved__c = true) {
                ServiceRequest serviceRequest = new ServiceRequest();
                serviceRequest.withParams('record', protocol);
                serviceRequest.Action = 'removeHandler';
                serviceRequest.Name = 'removeHandler';
                ServiceResponse serviceResponse = SessionProtocolService.processReq(serviceRequest);
                Plan_Protocol__c protocol2 = (Plan_Protocol__c) serviceResponse.Data;
                protocol2.IsRemoved__c = true;
                planProtocolList.add(protocol2);
            }

        }
        update planProtocolList;
        ServiceResponse response = new ServiceResponse(request);


        insert planProtocols;
        response.Data = planProtocols;

        return response;

    }

    private static ServiceResponse removeHandler(ServiceRequest request) {
        Session_Protocol__c protocol = (Session_Protocol__c) request.Parameters.get('record');

        Treatment_Session__c plan = [SELECT Id FROM Treatment_Session__c WHERE Id =: protocol.TreatmentSessionId__c ];

        Map<Id, Plan_Protocol__c> planProtocolMap = new Map<Id, Plan_Protocol__c>([SELECT Id, Treatment_Plan__c,
                Protocol__c FROM Plan_Protocol__c WHERE Treatment_Plan__c =: plan.Id]);

        Map<Id, Plan_Protocol__c> protocolIdToPlanProtocolMap = new Map<Id, Plan_Protocol__c>();
        for (Plan_Protocol__c planProtocol : planProtocolMap.values()) {
            protocolIdToPlanProtocolMap.put(planProtocol.Protocol__c, planProtocol);
        }
        Plan_Protocol__c protocol2 = new Plan_Protocol__c();
        if(protocolIdToPlanProtocolMap.keySet().contains(protocol.ProtocolId__c)) {
            protocol2 = protocolIdToPlanProtocolMap.get(protocol.ProtocolId__c);
        }
        ServiceResponse response = new ServiceResponse(request);
        response.Data = protocol2;
        return response;
    }
}