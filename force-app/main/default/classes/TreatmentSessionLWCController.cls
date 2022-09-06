public with sharing class TreatmentSessionLWCController {
    /*
    used by TreatmentSessionMain lwc to get the list of active and required
    protocols and scores to display in the table
    the list of requiredProtocols are the column headings
    */
    @AuraEnabled (cacheable=true)
    public static SessionInfo getActiveProtocolsForSession(Id sessionId){
        Set<String> requiredProtocols = new Set<String>();
        SessionProtocolInfo[] protocolInfos = new SessionProtocolInfo[0];
        try {
            for(Session_Protocol__c sp : [
                SELECT 
                    Id,
                    IsSkipped__c,
                    Needs_Review__c,
                    Protocol_Name__c,
                    Status__c,
                    IsRemoved__c,
                    (
                        SELECT Id, 
                            Protocol_Score__c,
                            Protocol_Scale__r.Options__c,
                            Protocol_Scale__r.Name,
                            Protocol_Scale__r.Category__c,
                            Protocol_Scale__r.Required__c,
                            Protocol_Scale__r.Column_Order__c,
                            Protocol_Scale__r.Column_Number__c
                        FROM Session_Protocol_Scales__r
                        WHERE Protocol_Scale__r.Column_Order__c != null
                        ORDER BY Protocol_Scale__r.Column_Number__c ASC, Protocol_Scale__r.Column_Order__c ASC
                    )
                FROM Session_Protocol__c 
                WHERE TreatmentSessionId__c =: sessionId
                ORDER BY Protocol_Name__c ASC
            ]){
                SessionProtocolInfo info = new SessionProtocolInfo(sp);
                protocolInfos.add(info);
                for(Session_Protocol_Scale__c sps : sp.Session_Protocol_Scales__r){
                    if(sps.Protocol_Scale__r.Column_Order__c != null){
                        requiredProtocols.add(sps.Protocol_Scale__r.Name);
                    }
                }
            }

            SessionInfo sInfo = new SessionInfo();
            sInfo.requiredProtocols = new String[(requiredProtocols)];
            sInfo.sessionProtocolInfos = protocolInfos;
            return sInfo;
        } catch (Exception e) {
            System.debug('error: ' + e.getMessage());
            System.debug('stackTrace: ' + e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    //used by treatmentSessionProtocol lwc to get the updated status of the protocol
    @AuraEnabled
    public static string getProtocolStatus(Id protocolId){
        try {
            if(protocolId != null){
                return [SELECT Status_Text__c FROM Session_Protocol__c WHERE Id =: protocolId LIMIT 1].Status_Text__c;
            } else {
                return null;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /*
    used by treatmentModifySessionProtocol lwc
    returns skipped/removed/add to plan session protocol by session protocol Id
    */
    @AuraEnabled
    public static Session_Protocol__c getProtocolSkippedInfo(Id protocolId){
        Session_Protocol__c[] protocols = [SELECT Id, IsSkipped__c, IsRemoved__c, Add_to_Plan__c, New_Protocol__c FROM Session_Protocol__c WHERE Id =: protocolId LIMIT 1];
        return !protocols.isEmpty() ? protocols[0] : null;
    }

    /*
    used by treatmentSessionChild lwc to return the child records of protocol Contacts or Additional Dogs Present
    that are related to a session protocol
    */
    @AuraEnabled (cacheable=true)
    public static sObject[] getChildList(Id protocolId, String objectApi){
        if(protocolId == null || objectApi == null) return null;
        try {
            sObject[] childList = new sObject[0];
            if(objectApi == 'Session_Protocol_Contact__c'){
                childList = getProtocolContacts(protocolId);
            }
            else if(objectApi == 'Additional_Dog_Present__c'){
                childList = getDogsPresent(protocolId);
            }
            return childList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    //used by the treatmentSessionProtocol lwc to get the info needed for a specific protocol
    @AuraEnabled
    public static protocolInfo getActiveProtocolAndFields(Id protocolId){
        if(protocolId == null) return null;
        try {
            Session_Protocol__c sessionProtocol = getProtocol(protocolId);
            ProtocolInfo protocolInfo = new ProtocolInfo(sessionProtocol);
            return protocolInfo;

        } catch (Exception e) {
            System.debug('error: ' + e.getMessage());
            System.debug('callstack: ' + e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    /*
    used by treatmentModifySession lwc to get the lists of assigned and unassigned protocols
    works for both session specific and plan specific
    */
    @AuraEnabled (cacheable=true)
    public static protocolAssignment getProtocolLists(Id sessionId, Id planId){
        protocolAssignment assignments = new protocolAssignment();   
        if(sessionId != null)     {
            assignments.assignedSessionProtocolsLists = getAssignedSessionProtocolsLists(sessionId);
            assignments.unassignedProtocolsLists = getUnassignedProtocolsListsFromSessionProtocols(assignments.assignedSessionProtocolsLists);
            assignments.preferredMotivators = getSessionPreferredMotivator(sessionId);
        }
        else if(planId != null){
            assignments.assignedPlanProtocolsLists = getAssignedPlanProtocolsLists(planId);
            assignments.unassignedProtocolsLists = getUnassignedProtocolsListsFromPlanProtocols(assignments.assignedPlanProtocolsLists);
        }
        
        return assignments;
    }

    @AuraEnabled
    public static String updateProtocolAssignments(Session_Protocol__c[] protocolsToUpdate, String[] protocolIds, String[] planProtocolIds, String sessionId, String planId){
        try{
            if(sessionId != null){
                update protocolsToUpdate;
                addNewProtocolsToSessionAndPlan(protocolIds, sessionId);
            } 
            else if(planId != null){
                updatePlanProtocols(planProtocolIds);
                addNewProtocolsToPlan(protocolIds, planId);
            }
            return 'success';
        } catch (Exception e){
            return 'Error occured: ' + e.getMessage();
        }
    }

    @AuraEnabled
    public static SpsInfo getSpsInfo (Id id, String[] fields){
        String query = 'SELECT Id';
        if(fields != null && !fields.isEmpty()){
            query += ', ' + String.join(fields, ',');
        }
        query += ',Protocol_Score__c FROM Session_Protocol_Scale__c WHERE Id = :id';

        Session_Protocol_Scale__c[] spsList = Database.query(query);
        Session_Protocol_Scale__c sps = spsList.isEmpty() ? null : spsList[0];
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType spsSchema = schemaMap.get('Session_Protocol_Scale__c');
        Map<String, Schema.SObjectField> fieldMap = spsSchema.getDescribe().fields.getMap();

        SpsInfo info = new SpsInfo();

        if(sps != null){            
            info.currentScore = sps.Protocol_Score__c;
            info.fields = new SpsFieldsWrapper[0];
            if(fields != null && !fields.isEmpty()){
                for(String field : fields){
                    SpsFieldsWrapper spsField = new SpsFieldsWrapper();
                    spsField.fieldName = field;
                    spsField.value = (String) sps.get(field);
                    spsField.fieldLabel = fieldMap.get(field).getDescribe().getLabel();
                    info.fields.add(spsField);
                }
            }
        }

        return info;
    }

    /******Private methods*********/

    //query session protocol by Id
    @testVisible
    private static Session_Protocol__c getProtocol(Id protocolId){
        if(protocolId == null) return null;
        try {
            return [
                SELECT 
                    Id, 
                    IsSkipped__c,
                    Needs_Review__c,
                    Protocol_Name__c,
                    Status__c,
                    Status_Text__c,
                    IsRemoved__c,
                    Preferred_Motivators__c,
                    Novel_Person_Notes__c,
                    Protocol_Notes__c,
                    Manager_Review_Notes__c,
                    ProtocolId__c,
                    ProtocolId__r.Protocol_Box_Link__c,                    
                    ProtocolId__r.Name,
                    TreatmentSessionId__r.Treatment_Plan__c,
                    TreatmentSessionId__r.Animal__r.Current_Recent_Shelter_Location__c,
                    (
                        SELECT Id, 
                            Protocol_Score__c,
                            Protocol_Scale__r.Options__c,
                            Protocol_Scale__r.Name,
                            Protocol_Scale__r.Category__c,
                            Protocol_Scale__r.Required__c,
                            Protocol_Scale__r.Column_Order__c,
                            Protocol_Scale__r.Column_Number__c,
                            Protocol_Scale__r.Fields_to_include__c
                        FROM Session_Protocol_Scales__r
                        ORDER BY Protocol_Scale__r.Column_Number__c NULLS LAST, Protocol_Scale__r.Column_Order__c NULLS LAST
                    )
                FROM Session_Protocol__c 
                WHERE Id =: protocolId
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /*
    used by getProtocolLists()
    returns a list of lists of session protocols by the session Id.  the list of lists is used to display the protocols in groups by category
    */
    private static List<List<Session_Protocol__c>> getAssignedSessionProtocolsLists(Id sessionId){
        if(sessionId == null) return null;
        Map<String, Session_Protocol__c[]> protocolsMap = new Map<String, Session_Protocol__c[]>();
        for(Session_Protocol__c protocol : [SELECT Id, ProtocolId__c, Protocol_Name__c, IsSkipped__c, IsRemoved__c, ProtocolId__r.Protocol_Categories__c, New_Protocol__c FROM Session_Protocol__c WHERE TreatmentSessionId__c =: sessionId ORDER BY ProtocolId__r.Protocol_Categories__c ASC, Protocol_Name__c ASC]){
            if(protocolsMap.containsKey(protocol.ProtocolId__r.Protocol_Categories__c)){
                protocolsMap.get(protocol.ProtocolId__r.Protocol_Categories__c).add(protocol);
            }
            else {
                protocolsMap.put(protocol.ProtocolId__r.Protocol_Categories__c, new Session_Protocol__c[]{protocol});
            }
        }

        List<List<Session_Protocol__c>> assignedSessionProtocolsLists = new List<List<Session_Protocol__c>>();
        for(String category : protocolsMap.keySet()){
            assignedSessionProtocolsLists.add(protocolsMap.get(category));
        }

        return assignedSessionProtocolsLists;
    }

    //queries the list of related session protocol contacts by session protocol Id
    private static Session_Protocol_Contact__c[] getProtocolContacts(Id protocolId){
        return [SELECT Id, Contact__c, Contact__r.Name, Novel_Not_Novel__c FROM Session_Protocol_Contact__c WHERE Session_Protocol__c =: protocolId];
    }

    //queries the list of related Additional Dogs Present by session protocol Id
    private static Additional_Dog_Present__c[] getDogsPresent(Id protocolId){
        return [SELECT Id, Additional_Dog__c FROM Additional_Dog_Present__c WHERE Session_Protocol__c =: protocolId];
    }

    private static String getSessionPreferredMotivator(Id sessionId){
        return [SELECT Preferred_Motivators__c FROM Treatment_Session__c WHERE Id =: sessionId LIMIT 1].Preferred_Motivators__c;
    }

    private static void updatePlanProtocols(String[] planProtocolIds){
        Plan_Protocol__c[] pProtocols = [SELECT Id, IsRemoved__c FROM Plan_Protocol__c WHERE Id IN: planProtocolIds];
        for(Plan_Protocol__c p : pProtocols){
            p.IsRemoved__c = !p.IsRemoved__c;
        }
        update pProtocols;
    }


    private static void addNewProtocolsToPlan(String[] protocolIds, String planId){
        Plan_Protocol__c[] newPProtocols = new Plan_Protocol__c[0];
        for(String pId : protocolIds){
            Plan_Protocol__c pp = new Plan_Protocol__c(
                Protocol__c = pId,
                Treatment_Plan__c = planId
            );
            newPProtocols.add(pp);
        }

        insert newPProtocols;
    }

    private static List<List<Plan_Protocol__c>> getAssignedPlanProtocolsLists(Id planId){
        Map<String, Plan_Protocol__c[]> protocolsMap = new Map<String, Plan_Protocol__c[]>();
        for(Plan_Protocol__c protocol : [SELECT Id, Protocol__c, Protocol__r.Name, Protocol_Description__c, IsRemoved__c, Protocol__r.Protocol_Categories__c, New_Protocol__c FROM Plan_Protocol__c WHERE Treatment_Plan__c =: planId ORDER BY Protocol__r.Protocol_Categories__c, Protocol__r.Name ASC]){
            if(protocolsMap.containsKey(protocol.Protocol__r.Protocol_Categories__c)){
                protocolsMap.get(protocol.Protocol__r.Protocol_Categories__c).add(protocol);
            }
            else {
                protocolsMap.put(protocol.Protocol__r.Protocol_Categories__c, new Plan_Protocol__c[]{protocol});
            }
        }

        List<List<Plan_Protocol__c>> assignedPlanProtocolsLists = new List<List<Plan_Protocol__c>>();
        for(String category : protocolsMap.keySet()){
            assignedPlanProtocolsLists.add(protocolsMap.get(category));
        }

        return assignedPlanProtocolsLists;
    }

    private static List<List<Protocol__c>> getUnassignedProtocolsListsFromPlanProtocols(List<List<Plan_Protocol__c>> assignedProtocols){
        Set<Id> assignedIds = new Set<Id>();
        for(List<Plan_Protocol__c> protocolList : assignedProtocols){
            for(Plan_Protocol__c sp : protocolList){
                assignedIds.add(sp.Protocol__c);
            }
        }
        return getUnassignedProtocols(assignedIds);
    }

    private static List<List<Protocol__c>> getUnassignedProtocolsListsFromSessionProtocols(List<List<Session_Protocol__c>> assignedProtocolsLists){
        Set<Id> assignedIds = new Set<Id>();
        for(List<Session_Protocol__c> protocolList : assignedProtocolsLists){
            for(Session_Protocol__c protocol: protocolList){
                assignedIds.add(protocol.ProtocolId__c);
            }
        }
        return getUnassignedProtocols(assignedIds);
    }

    private static List<List<Protocol__c>> getUnassignedProtocols(Set<Id> protocolIdsToExclude){
        Map<String, Protocol__c[]> protocolsMap = new Map<String, Protocol__c[]>();
        Set<Id> masterBundleProtocolIds = new Set<Id>();
        for(Bundle_Entry__c entry : [
            SELECT Id, Protocol__c
            FROM Bundle_Entry__c 
            WHERE Treatment_Bundle__r.IsActive__c = true 
            AND Treatment_Bundle__r.IsMaster__c = true
            AND Protocol__c NOT IN: protocolIdsToExclude
        ]){
            masterBundleProtocolIds.add(entry.Protocol__c);
        }
        for(Protocol__c protocol : [SELECT Id, Name, Protocol_Categories__c FROM Protocol__c WHERE Id IN :masterBundleProtocolIds ORDER BY Protocol_Categories__c ASC, Name ASC]){
            if(protocolsMap.containsKey(protocol.Protocol_Categories__c)){
                protocolsMap.get(protocol.Protocol_Categories__c).add(protocol);
            }
            else {
                protocolsMap.put(protocol.Protocol_Categories__c, new Protocol__c[]{protocol});
            }
        }

        List<List<Protocol__c>> protocolsLists = new List<List<Protocol__c>>();
        for(String category : protocolsMap.keySet()){
            protocolsLists.add(protocolsMap.get(category));
        }

        return protocolsLists;
    }

    private static void addNewProtocolsToSessionAndPlan(String[] protocolIds, String sessionId){
        Treatment_Session__c session = [SELECT Id, Preferred_Motivators__c FROM Treatment_Session__c WHERE Id =: sessionId LIMIT 1];
        Session_Protocol__c[] newSProtocols = new Session_Protocol__c[0];

        for(String pId : protocolIds){
            Session_Protocol__c sp = new Session_Protocol__c(
                ProtocolId__c = pId,
                TreatmentSessionId__c = sessionId,
                Add_to_Plan__c = true,
                Preferred_Motivators__c = session.Preferred_Motivators__c,
                Session_Date__c = date.today()
            );
            newSProtocols.add(sp);
        }

        insert newSProtocols;
    }

    /************** Inner Classes************/

    //Used by getActiveProtocolsForSession()
    public class SessionInfo{
        @AuraEnabled public String[] requiredProtocols;
        @AuraEnabled public SessionProtocolInfo[] sessionProtocolInfos;
    }

    public class SessionProtocolInfo {
        @AuraEnabled public Id id;
        @AuraEnabled public String name;
        @AuraEnabled public Boolean skipped;
        @AuraEnabled public Boolean needsReview;
        @AuraEnabled public String status;
        @AuraEnabled public ScaleInfo[] scaleInfos;
        @AuraEnabled public String overallScore;

        public SessionProtocolInfo(Session_Protocol__c sp){
            this.id = sp.Id;
            this.name = sp.Protocol_Name__c;
            this.skipped = sp.IsSkipped__c;
            this.needsReview = sp.Needs_Review__c;
            this.status = sp.Status__c;
            this.scaleInfos = new ScaleInfo[0];
            for(Session_Protocol_Scale__c scale : sp.Session_Protocol_Scales__r){
                this.scaleInfos.add(new ScaleInfo(scale));
                if(scale.Protocol_Scale__r.Name == 'Overall Score'){
                    this.overallScore = scale.Protocol_Score__c;
                }
            }
        }
    }

    public class ScaleInfo {
        @AuraEnabled public Decimal columnOrder;
        @AuraEnabled public String category;
        @AuraEnabled public Boolean required;
        @AuraEnabled public String score;
        @AuraEnabled public String[] options;        

        public ScaleInfo(Session_Protocol_Scale__c scale){
            this.columnOrder = scale.Protocol_Scale__r.Column_Order__c;
            this.category = scale.Protocol_Scale__r.Category__c;
            this.required = scale.Protocol_Scale__r.Required__c;
            this.score = scale.Protocol_Score__c;
            if(scale.Protocol_Scale__r.Options__c != null){
                this.options = scale.Protocol_Scale__r.Options__c.split(';');            
            }
        }
    }   

    public class protocolAssignment {
        @AuraEnabled public List<List<Session_Protocol__c>> assignedSessionProtocolsLists { get; set; }
        @AuraEnabled public List<List<Protocol__c>> unassignedProtocolsLists { get; set; }
        @AuraEnabled public List<List<Plan_Protocol__c>> assignedPlanProtocolsLists { get; set; }
        @AuraEnabled public String preferredMotivators;
    }

    public class ProtocolInfo{
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String nameUrl {get; set;}
        @AuraEnabled public String status {get;set;}
        @AuraEnabled public String statusText {get;set;}
        @AuraEnabled public Boolean needsReview { get; set; }
        @AuraEnabled public Boolean isSkipped { get; set; }
        @AuraEnabled public Boolean isRemoved { get; set; }
        @AuraEnabled public ScoringColumn[] columns {get; set;}
        @AuraEnabled public String preferredMotivators { get; set; }
        @AuraEnabled public String novelPersonNotes { get; set; }
        @AuraEnabled public String protocolNotes { get; set; }
        @AuraEnabled public String managerReviewNotes { get; set; }
        @AuraEnabled public String boxLink {get; set;}
        @AuraEnabled public String planProtocolId {get; set;}
        @AuraEnabled public String planProtocolNotes {get; set;}
        @AuraEnabled public Boolean isNonMRC {get;set;}

        ProtocolInfo(Session_Protocol__c sp){
            this.id = sp.Id;
            this.name = sp.Protocol_Name__c;
            this.nameUrl = '/' + sp.Id;
            this.status = sp.Status__c;
            this.needsReview = sp.Needs_Review__c;
            this.isSkipped = sp.IsSkipped__c;
            this.isRemoved = sp.IsRemoved__c;
            this.statusText = sp.Status_Text__c;
            this.preferredMotivators = sp.Preferred_Motivators__c;
            this.novelPersonNotes = sp.Novel_Person_Notes__c;
            this.protocolNotes = sp.Protocol_Notes__c;
            this.managerReviewNotes = sp.Manager_Review_Notes__c;
            this.boxLink = sp.ProtocolId__r.Protocol_Box_Link__c;
            this.isNonMRC = sp.TreatmentSessionId__r?.Animal__r?.Current_Recent_Shelter_Location__c.toUpperCase().contains('MRC');

            Plan_Protocol__c[] pp = [SELECT Id, Protocol_Notes__c FROM Plan_Protocol__c WHERE Treatment_Plan__c = :sp.TreatmentSessionId__r.Treatment_Plan__c AND Protocol__c = :sp.ProtocolId__c LIMIT 1];
            if(!pp.isEmpty()){
                this.planProtocolId = pp[0].Id;
                this.planProtocolNotes = pp[0].Protocol_Notes__c;
            }
            
            Map<Decimal, ScoreOptions[]> scoringOptionsMap = new Map<Decimal, ScoreOptions[]>();
            for(Session_Protocol_Scale__c sps : sp.Session_Protocol_Scales__r){   
                System.debug('**sps: ' + sps);
                ScoreOptions options = new ScoreOptions(sps);

                if(sps.Protocol_Scale__r.Fields_to_include__c != null){
                    options.additionalFields = new String[0];
                    String[] tempList = sps.Protocol_Scale__r.Fields_to_include__c.split(';');
                    for(String field : tempList){
                        options.additionalFields.add(field.trim());
                    }                    
                }

                if(scoringOptionsMap.containsKey(sps.Protocol_Scale__r.Column_Number__c)){
                    scoringOptionsMap.get(sps.Protocol_Scale__r.Column_Number__c).add(options);
                } else {
                    scoringOptionsMap.put(sps.Protocol_Scale__r.Column_Number__c, new ScoreOptions[]{options});
                }
            }

            this.columns = new ScoringColumn[0];
            for(Decimal num : scoringOptionsMap.keySet()){
                ScoringColumn column = new ScoringColumn();
                column.columnNum = num;
                column.options = scoringOptionsMap.get(num);
                column.scaleConfig = Behavior_Config__mdt.getInstance(scoringOptionsMap.get(num)[0].category + '_Dog');
                this.columns.add(column);
            }
        }
    }

    public class ScoringColumn{
        @AuraEnabled public Decimal columnNum {get; set;}
        @AuraEnabled public behavior_config__mdt scaleConfig {get; set;}
        @AuraEnabled public ScoreOptions[] options {get; set;}
    }

    public class ScoreOptions{
        @AuraEnabled public Id id {get; set;}
        @AuraEnabled public String name {get; set;}
        @AuraEnabled public Decimal order {get; set;}
        @AuraEnabled public selectionOption[] options { get; set; }
        @AuraEnabled public String currentSelection {get; set;}
        @AuraEnabled public String category {get; set;}
        @AuraEnabled public String[] additionalFields {get; set;}

        private ScoreOptions(Session_Protocol_Scale__c sps){
            this.id = sps.Id;
            this.name = sps.Protocol_Scale__r.Name;
            this.order = sps.Protocol_Scale__r.Column_Order__c;
            this.currentSelection = sps.Protocol_Score__c;
            this.category = sps.Protocol_Scale__r.Category__c;

            this.options = new selectionOption[0];
            for(String option : sps.Protocol_Scale__r.Options__c.split(';')){
                this.options.add(new SelectionOption(option));
            }
        }
    }

    public class SelectionOption{
        @AuraEnabled public String label;
        @AuraEnabled public String value;

        selectionOption(String item){
            item = item.trim();
            this.label = item;
            this.value = item;
        }
    }

    @testVisible
    private class SpsInfo {
        @AuraEnabled public String currentScore {get;set;}
        @AuraEnabled public SpsFieldsWrapper[] fields {get;set;}
    }

    private class SpsFieldsWrapper{
        @AuraEnabled public String fieldName {get;set;}
        @AuraEnabled public String fieldLabel {get;set;}
        @AuraEnabled public String value {get;set;}
    }
}