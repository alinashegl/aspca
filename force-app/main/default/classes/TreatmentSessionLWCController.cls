public with sharing class TreatmentSessionLWCController {
    @AuraEnabled (cacheable=true)
    public static Session_Protocol__c[] getActiveProtocols(Id sessionId){
        try {
            return [
                SELECT 
                    Id, 
                    ProtocolId__r.Name,
                    Aggressive_Worst__c,
                    Arousal_Best__c,
                    Arousal_Worst__c,
                    Fear_Best__c,
                    Fear_Worst__c,
                    IsSkipped__c,
                    Social_Best__c,
                    Overall_Score__c,
                    Needs_Review__c,
                    Protocol_Name__c
                FROM Session_Protocol__c 
                WHERE TreatmentSessionId__c =: sessionId
                ORDER BY Protocol_Name__c ASC
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @testVisible
    private static Session_Protocol__c getProtocol(Id protocolId){
        if(protocolId == null) return null;
        return [
            SELECT 
                Id, 
                ProtocolId__r.Name,
                Aggressive_Worst__c,
                Arousal_Best__c,
                Arousal_Worst__c,
                Fear_Best__c,
                Fear_Worst__c,
                IsSkipped__c,
                IsRemoved__c,
                Social_Best__c,
                Overall_Score__c,
                Needs_Review__c,
                Protocol_Name__c,
                Protocol_Notes__c,
                Novel_Person_Notes__c,
                Manager_Review_Notes__c,
                Preferred_Motivators__c,
                ProtocolId__r.Protocol_Box_Link__c
            FROM Session_Protocol__c 
            WHERE Id =: protocolId
        ];
    }

    @AuraEnabled
    public static Session_Protocol__c getProtocolSkippedInfo(Id protocolId){
        Session_Protocol__c[] protocols = [SELECT Id, IsSkipped__c, IsRemoved__c, Add_to_Plan__c FROM Session_Protocol__c WHERE Id =: protocolId LIMIT 1];
        return !protocols.isEmpty() ? protocols[0] : null;
    }

    private static Session_Protocol__c[] getAssignedSessionProtocols(Id sessionId){
        if(sessionId == null) return null;
        return [SELECT Id, ProtocolId__c, Protocol_Name__c, IsSkipped__c, IsRemoved__c FROM Session_Protocol__c WHERE TreatmentSessionId__c =: sessionId ORDER BY Protocol_Name__c ASC];
    }

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

    @AuraEnabled
    public static Session_Protocol_Contact__c[] getProtocolContacts(Id protocolId){
        return [SELECT Id, Contact__c, Contact__r.Name, Novel_Not_Novel__c FROM Session_Protocol_Contact__c WHERE Session_Protocol__c =: protocolId];
    }

    @AuraEnabled
    public static Additional_Dog_Present__c[] getDogsPresent(Id protocolId){
        return [SELECT Id, Additional_Dog__c FROM Additional_Dog_Present__c WHERE Session_Protocol__c =: protocolId];
    }

    @AuraEnabled
    public static protocolInfo getActiveProtocolAndFields(Id protocolId){
        if(protocolId == null) return null;
        try {
            Session_Protocol__c sessionProtocol = getProtocol(protocolId);
            ProtocolInfo protocolInfo = new ProtocolInfo(sessionProtocol);

            System.debug('protocolInfo = ' + protocolInfo);
            return protocolInfo;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled (cacheable=true)
    public static protocolAssignment getProtocolLists(Id sessionId, Id planId){
        protocolAssignment assignments = new protocolAssignment();   
        if(sessionId != null)     {
            assignments.assignedSessionProtocols = getAssignedSessionProtocols(sessionId);
            assignments.unassignedProtocols = getUnassignedProtocolsFromSessionProtocols(assignments.assignedSessionProtocols);
            assignments.preferredMotivators = getSessionPreferredMotivator(sessionId);
        }
        else if(planId != null){
            assignments.assignedPlanProtocols = getAssignedPlanProtocols(planId);
            assignments.unassignedProtocols = getUnassignedProtocolsFromPlanProtocols(assignments.assignedPlanProtocols);
        }
        
        return assignments;
    }

    private static String getSessionPreferredMotivator(Id sessionId){
        return [SELECT Preferred_Motivators__c FROM Treatment_Session__c WHERE Id =: sessionId LIMIT 1].Preferred_Motivators__c;
    }

    private static Plan_Protocol__c[] getAssignedPlanProtocols(Id planId){
        return [SELECT Id, Protocol__c, Protocol__r.Name, Protocol_Description__c, IsRemoved__c FROM Plan_Protocol__c WHERE Treatment_Plan__c =: planId ORDER BY Protocol__r.Name ASC];
    }

    private static Protocol__c[] getUnassignedProtocolsFromPlanProtocols(Plan_Protocol__c[] assignedProtocols){
        Set<Id> assignedIds = new Set<Id>();
        for(Plan_Protocol__c sp : assignedProtocols){
            assignedIds.add(sp.Protocol__c);
        }
        return getUnassignedProtocols(assignedIds);
    }

    private static Protocol__c[] getUnassignedProtocolsFromSessionProtocols(Session_Protocol__c[] assignedProtocols){
        Set<Id> assignedIds = new Set<Id>();
        for(Session_Protocol__c sp : assignedProtocols){
            assignedIds.add(sp.ProtocolId__c);
        }
        return getUnassignedProtocols(assignedIds);
    }

    private static Protocol__c[] getUnassignedProtocols(Set<Id> protocolIdsToExclude){
        return [SELECT Id, Name FROM Protocol__c WHERE IsActive__c = true AND Id NOT IN :protocolIdsToExclude ORDER BY Name ASC];
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

    private static void updatePlanProtocols(String[] planProtocolIds){
        Plan_Protocol__c[] pProtocols = [SELECT Id, IsRemoved__c FROM Plan_Protocol__c WHERE Id IN: planProtocolIds];
        for(Plan_Protocol__c p : pProtocols){
            p.IsRemoved__c = !p.IsRemoved__c;
        }
        update pProtocols;
    }

    private static void addNewProtocolsToPlan(String[] protocolIds, String planId){
        // Treatment_Plan__c tPlan = [SELECT Id, Preferred_Motivators__c FROM Treatment_Plan__c WHERE Id =: planId LIMIT 1];
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

    public static void addNewProtocolsToSessionAndPlan(String[] protocolIds, String sessionId){
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

    public class protocolAssignment {
        @AuraEnabled public Session_Protocol__c[] assignedSessionProtocols { get; set; }
        @AuraEnabled public Plan_Protocol__c[] assignedPlanProtocols { get; set; }
        @AuraEnabled public Protocol__c[] unassignedProtocols { get; set; }
        @AuraEnabled public String preferredMotivators;
    }

    public class ProtocolInfo{
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String nameUrl {get; set;}
        @AuraEnabled public Boolean needsReview { get; set; }
        @AuraEnabled public Boolean isSkipped { get; set; }
        @AuraEnabled public Boolean isRemoved { get; set; }
        @AuraEnabled public picklistField[] picklistFields {get; set;}
        @AuraEnabled public String preferredMotivators { get; set; }
        @AuraEnabled public String novelPersonNotes { get; set; }
        @AuraEnabled public String protocolNotes { get; set; }
        @AuraEnabled public String managerReviewNotes { get; set; }
        @AuraEnabled public String boxLink {get; set;}


        ProtocolInfo(Session_Protocol__c sp){
            this.id = sp.Id;
            this.name = sp.Protocol_Name__c;
            this.nameUrl = '/' + sp.Id;
            this.needsReview = sp.Needs_Review__c;
            this.isSkipped = sp.IsSkipped__c;
            this.isRemoved = sp.IsRemoved__c;
            this.picklistFields = new PicklistField[0];
            this.preferredMotivators = sp.Preferred_Motivators__c;
            this.novelPersonNotes = sp.Novel_Person_Notes__c;
            this.protocolNotes = sp.Protocol_Notes__c;
            this.managerReviewNotes = sp.Manager_Review_Notes__c;
            this.boxLink = sp.ProtocolId__r.Protocol_Box_Link__c;

            String[] fieldList = new String[]{
                'Aggressive_Worst__c',
                'Arousal_Best__c',
                'Arousal_Worst__c',
                'Fear_Best__c',
                'Fear_Worst__c',
                'Social_Best__c',
                'Overall_Score__c'
            };

            for(String fieldAPI : fieldList){
                PicklistField pf = new PicklistField(fieldAPI, String.valueOf(sp.get(fieldAPI)));
                this.picklistFields.add(pf);
            }
        }
    }

    public class PicklistField{
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String apiName { get; set; }
        @AuraEnabled public String currentValue { get; set; }
        @AuraEnabled public String initialValue { get; set; }
        @AuraEnabled public selectionOption[] options { get; set; }

        PicklistField(String fieldAPI, String currentValue){
            this.apiName = fieldAPI;
            String objectAPI = 'Session_Protocol__c';
            this.currentValue = currentValue;
            this.initialValue = currentValue;
            this.name = String.valueOf(Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(FieldApi).getDescribe().getLabel());

            Schema.SObjectField fieldInfo = SchemaHelper.DetermineSObjectFieldByLabel(objectAPI, name);            
            String[] picklistValues = SchemaHelper.GetPicklistValues(fieldInfo);
            this.options = new SelectionOption[0];
            for(String option : picklistValues){
                this.options.add(new SelectionOption(option));
            }
        }
    }

    public class SelectionOption{
        @AuraEnabled public String label;
        @AuraEnabled public String value;

        selectionOption(String item){
            this.label = item;
            this.value = item;
        }
    }
}