/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 * Tests: test_SessionProtocolDomain, test_SessionProtocolService
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
            // } when 'handleSession' {
                // response = handleSession(request);
            } when 'beforeInsertHandler' {
                response = beforeInsertHandler(request);
            }when 'beforeUpdateHandler' {
                response = beforeUpdateHandler(request);
            }when 'afterInsertHandler' {
                response = afterInsertHandler(request);
            }when 'afterUpdateHandler' {
                response = afterUpdateHandler(request);
            }when else {
                return null;
            }
        }
        return response;
    }

    @testVisible
    private static ServiceResponse handleValidity(ServiceRequest request) {
        Treatment_Session__c treatmentSession = (Treatment_Session__c) request.Parameters.get('treatmentSession');

        Map<String,Map<String,String>> resultMap = new Map<String, Map<String, String>>();
        String success = 'SUCCESS';
        if (treatmentSession != null) {
            List<SessionProtocol> lineItems = getByTreatmentSessionId(treatmentSession.Id);
            System.debug(lineItems);
            ProtocolSelector protocolSelector = new ProtocolSelector();

            for (SessionProtocol item : lineItems) {
                Map<String, String> result = new Map<String, String>();
                Set<Id> idset = new Set<Id>();
                idset.add(item.sProto.ProtocolId__c);
                Protocol__c protocol = protocolSelector.GetById(idset)[0];
                String invalid = 'INVALID';
                try {
                    if (item.fearBest.score == null) {
                        result.put('Fear Best', invalid);
                    }
                    if (item.fearWorst.score == null) {
                        result.put('Fear Worst', invalid);
                    }
                    if (item.arousalBest.score == null) {
                        result.put('AROUSAL BEST', invalid);
                    }
                    if(item.arousalWorst.score == null) {
                        result.put('AROUSAL WORST', invalid);
                    }
                    if (item.socialBest.score == null) {
                        result.put('SOCIAL BEST', invalid);
                    }
                    if (item.aggressiveWorst.score == null) {
                        result.put('AGGRESSIVE WORST', invalid);
                    }
                    if (item.sProto.Overall_Score__c == null) {
                        result.put('OVERALL SCORE', invalid);
                    }
                }catch (Exception e) {
                    System.debug(e);
                    result.put('ERROR', String.valueOf(e));
                }
                resultMap.put(protocol.Name, result);
            }
        }
        ServiceResponse response = new ServiceResponse(request);
        if (resultMap == null || resultMap.size() == 0) {
            resultMap.put(success, new Map<String, String>{ success => success});
        }
        response.Data = resultMap;
        return response;
    }

    private static ServiceResponse beforeInsertHandler(ServiceRequest request) {
        ServiceResponse response = new ServiceResponse(request);

        System.debug('**request.Parameters: ' + request.Parameters);

        if(request.Parameters.get('protocols') != null){
            Plan_Protocol__c[] planProtocols = prepNewPlanProtocols((Session_Protocol__c[]) request.Parameters.get('protocols'));
            insert planProtocols;

            response.Data = planProtocols;
        }

        if(request.Parameters.get('plan') != null){
            Treatment_Plan__c plan = (Treatment_Plan__c) request.Parameters.get('plan');
            Treatment_Session__c session = (Treatment_Session__c) request.Parameters.get('session');
            ProtocolSelector protocolSelector = new ProtocolSelector();
            Protocol__c[] protocols = protocolSelector.getByPlan(plan.Id);
            System.debug('protocols: ' + protocols);
            List<Session_Protocol__c> sProtocols = new List<Session_Protocol__c>();

            for(Protocol__c proto : protocols){
                if(!proto.Plan_Protocols__r[0].IsRemoved__c){
                    Plan_Protocol__c planProto = proto.Plan_Protocols__r[0];
                    Session_Protocol__c sProto = new Session_Protocol__c(
                        TreatmentSessionId__c = session.Id,
                        ProtocolId__c = proto.Id,
                        Bundle_Entry__c = planProto.Bundle_Entry__c,
                        Preferred_Motivators__c = session.Preferred_Motivators__c
                    );
                    sProtocols.add(sProto);
                }
            }

            insert sProtocols;
            response.Data = sProtocols;
        }
        return response;
    }

    private static ServiceResponse afterInsertHandler(ServiceRequest request){
        System.debug('in afterInserHandler');
        ServiceResponse response = new ServiceResponse(request);
        Session_Protocol__c[] sessionProtocols = (Session_Protocol__c[]) request.Parameters.get('protocols');
        ProtocolSelector protocolSelector = new ProtocolSelector();

        //need a set of protocolIds so we can query them and create a map
        Set<Id> protocolIds = new Set<Id>();
        for(Session_Protocol__c sp : sessionProtocols){
            protocolIds.add(sp.ProtocolId__c);
        }

        System.debug('protocolIds: ' + protocolIds);
        
        //query the protocols and their related Protocol Scale Junctions and put into a map
        Map<Id, Protocol__c> protocolMap = new Map<Id, Protocol__c>(protocolSelector.getProtocolWithChildProtocolScaleJunctionByIds(protocolIds));
        System.debug('protocolMap: ' + protocolMap);

        Session_Protocol_Scale__c[] protocolScales = new Session_Protocol_Scale__c[0];
        for(Session_Protocol__c sProto : sessionProtocols){
            if(protocolMap.containsKey(sProto.ProtocolId__c)){
                for(Protocol_Scale_Junction__c junc : protocolMap.get(sProto.ProtocolId__c).Protocol_Scale_Junctions__r){
                    Session_Protocol_Scale__c protoScale = new Session_Protocol_Scale__c(
                        Protocol_Scale__c = junc.Protocol_Scale__c,
                        Required__c = junc.Protocol_Scale__r.Required__c,
                        Session_Protocol__c = sProto.Id
                    );
                    protocolScales.add(protoScale);
                }
            }
        }

        insert protocolScales;
        response.Data = sessionProtocols;

        return response;
    }

    private static ServiceResponse beforeUpdateHandler(ServiceRequest request) {
        List<Session_Protocol__c> protocols = (List<Session_Protocol__c>) request.Parameters.get('protocols');

        Plan_Protocol__c[] newPlanProtocols = prepNewPlanProtocols(protocols);
        Plan_Protocol__c[] planProtocolsToRemove = removeHandler(protocols);

        update planProtocolsToRemove;
        ServiceResponse response = new ServiceResponse(request);

        insert newPlanProtocols;
        response.Data = newPlanProtocols;

        return response;
    }

    private static ServiceResponse afterUpdateHandler(ServiceRequest request){
        List<Session_Protocol__c> protocols = (List<Session_Protocol__c>) request.Parameters.get('protocols');
        ServiceResponse response = new ServiceResponse(request);
        clearProtocolScores(protocols);

        return response;
    }

    private static Plan_Protocol__c[] prepNewPlanProtocols(Session_Protocol__c[] sessionProtocols){
        TreatmentSessionSelector sessionSelector = new TreatmentSessionSelector();
        Session_Protocol__c[] sessionProtocolsToAddToPlan = new Session_Protocol__c[0];
        Set<Id> idstoQuery = new Set<Id>();
        for(Session_Protocol__c protocol : sessionProtocols) {
            if(protocol.Add_to_Plan__c == true){
                idstoQuery.add(protocol.TreatmentSessionId__c);
                sessionProtocolsToAddToPlan.add(protocol);
            }
        }
        Map<Id, Treatment_Session__c> sessionMap = new Map<Id, Treatment_Session__c>(sessionSelector.GetByIds(idstoQuery));
        Map<Id, Id[]> planIdToProtocolIdsMap = getProtocolIdMap(sessionMap.values());

        Plan_Protocol__c[] planProtocols = new Plan_Protocol__c[0];
        for (Session_Protocol__c protocol : sessionProtocolsToAddToPlan) {

            Plan_Protocol__c planProtocol = new Plan_Protocol__c();
            Treatment_Session__c session = sessionMap.get(protocol.TreatmentSessionId__c);
            Id[] existingProtocolIds = planIdToProtocolIdsMap.containsKey(session.Treatment_Plan__c) ? planIdToProtocolIdsMap.get(session.Treatment_Plan__c) : null;

            if(existingProtocolIds.isEmpty() || (!existingProtocolIds.isEmpty() && !existingProtocolIds.contains(protocol.ProtocolId__c))){
                planProtocol.Treatment_Plan__c = session.Treatment_Plan__c;
                planProtocol.Bundle_Entry__c = protocol.Bundle_Entry__c != null ? protocol.Bundle_Entry__c : null ;
                planProtocol.Protocol__c = protocol.ProtocolId__c;
                planProtocols.add(planProtocol);
            }
            
        }
        return planProtocols;
    }

    private static Map<Id, Id[]> getProtocolIdMap(Treatment_Session__c[] sessions){
        Set<Id> treatmentPlanIds = new Set<Id>();
        for(Treatment_Session__c session : sessions){
            treatmentPlanIds.add(session.Treatment_Plan__c);
        }
        Map<Id, Id[]> planIdToProtocolIdsMap = new Map<Id, Id[]>();
        for(Plan_Protocol__c pp : [SELECT Id, Treatment_Plan__c, Protocol__c FROM Plan_Protocol__c WHERE Treatment_Plan__c IN : treatmentPlanIds]){
            if(planIdToProtocolIdsMap.containsKey(pp.Treatment_Plan__c)){
                planIdToProtocolIdsMap.get(pp.Treatment_Plan__c).add(pp.Protocol__c);
            } else {
                planIdToProtocolIdsMap.put(pp.Treatment_Plan__c, new Id[]{pp.Protocol__c});
            }
        }
        return planIdToProtocolIdsMap;
    }

    private static Plan_Protocol__c[] removeHandler(Session_Protocol__c[] sessionProtocols) {
        Session_Protocol__c[] sProtocolsToRemove = new Session_Protocol__c[0];
        Set<Id> treatmentSessionIds = new Set<Id>();
        for(Session_Protocol__c sp : sessionProtocols){
            sProtocolsToRemove.add(sp);
            treatmentSessionIds.add(sp.TreatmentSessionId__c);
        }

        Map<Id, Plan_Protocol__c> protocolIdToPlanProtocolMap = getProtocolIdToPlanProtocolMap(treatmentSessionIds);

        Plan_Protocol__c[] pProtocols = new Plan_Protocol__c[0];
        for(Session_Protocol__c sp : sProtocolsToRemove){
            Plan_Protocol__c protocol2 = new Plan_Protocol__c();
            if(protocolIdToPlanProtocolMap.keySet().contains(sp.ProtocolId__c)) {
                protocol2 = protocolIdToPlanProtocolMap.get(sp.ProtocolId__c);
                protocol2.IsRemoved__c = sp.IsRemoved__c;
                pProtocols.add(protocol2);
            }
        }

        System.debug('removeHandler response: ' + pProtocols);
        return pProtocols;
    }

    private static Map<Id, Plan_Protocol__c> getProtocolIdToPlanProtocolMap(Set<Id> treatmentSessionIds){
        Set<Id> treatmentPlanIds = new Set<Id>();
        for(Treatment_Session__c treatmentSession : [SELECT Id, Treatment_Plan__c FROM Treatment_Session__c WHERE Id IN : treatmentSessionIds ]){
            treatmentPlanIds.add(treatmentSession.Treatment_Plan__c);
        }

        Map<Id, Plan_Protocol__c> protocolIdToPlanProtocolMap = new Map<Id, Plan_Protocol__c>();

        for (Plan_Protocol__c planProtocol : [SELECT Id, Treatment_Plan__c, Protocol__c FROM Plan_Protocol__c WHERE Treatment_Plan__c IN : treatmentPlanIds]) {
            protocolIdToPlanProtocolMap.put(planProtocol.Protocol__c, planProtocol);
        }

        return protocolIdToPlanProtocolMap;
    }

    private static void clearProtocolScores(Session_Protocol__c[] protocols){
        Set<Id> skippedProtoIds = new Set<Id>();
        for(Session_Protocol__c proto : protocols){
            if(proto.IsSkipped__c == true){
                skippedProtoIds.add(proto.Id);
            }
        }

        if(!skippedProtoIds.isEmpty()){
            Session_Protocol_Scale__c[] scales = [
                SELECT Id, Protocol_Score__c 
                FROM Session_Protocol_Scale__c 
                WHERE Session_Protocol__c IN :skippedProtoIds
            ];
            for(Session_Protocol_Scale__c sps : scales){
                if(sps.Protocol_Score__c != null){
                    sps.Protocol_Score__c = null;
                }
            }

            update scales;
        }
    }

    private static List<SessionProtocol> getByTreatmentSessionId(Id treatmentSessionId){
        SessionProtocol[] sProtocolList = new SessionProtocol[0];
        for(Session_Protocol__c sp : [
            SELECT Id, 
            Bundle_Entry__c,
            CreatedById,
            CreatedDate,
            LastModifiedById,
            LastModifiedDate,
            Overall_Score__c,
            Novel_Person_Notes__c,
            Novel_Person__c,
            Protocol_Notes__c,
            Protocol_Box_Link__c,
            IsSkipped__c,
            IsRemoved__c,
            IsDeleted ,
            ProtocolId__c ,
            TreatmentSessionId__c ,
            TreatmentSessionId__r.Session_Date__c,
            Add_to_Plan__c,
            (SELECT Id, Protocol_Score__c, Protocol_Scale_Name__c, Protocol_Score_Number__c, Protocol_Scale__r.Category__c
                FROM Session_Protocol_Scales__r 
                ORDER BY Protocol_Scale__r.Column_Number__c ASC, 
                Protocol_Scale__r.Column_Order__c ASC
            )
            FROM Session_Protocol__c
            WHERE TreatmentSessionId__c =:treatmentSessionId
        ]){
            sProtocolList.add(new SessionProtocol(sp));
        }

        return sProtocolList;
    }
}