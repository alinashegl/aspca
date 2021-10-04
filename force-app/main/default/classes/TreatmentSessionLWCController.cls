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
                Preferred_Motivators__c
            FROM Session_Protocol__c 
            WHERE Id =: protocolId
        ];
    }

    private static Session_Protocol__c[] getAssignedProtocols(Id sessionId){
        if(sessionId == null) return null;
        return [SELECT Id, ProtocolId__c, Protocol_Name__c, IsSkipped__c, IsRemoved__c FROM Session_Protocol__c WHERE TreatmentSessionId__c =: sessionId];
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

    @AuraEnabled (cacheable=true)
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
    public static protocolAssignment getProtocolLists(Id sessionId){
        protocolAssignment assignments = new protocolAssignment();
        assignments.assignedProtocols = getAssignedProtocols(sessionId);
        assignments.unassignedProtocols = getUnassignedProtocols(assignments.assignedProtocols);
        return assignments;
    }

    private static Protocol__c[] getUnassignedProtocols(Session_Protocol__c[] assignedProtocols){
        Set<Id> assignedIds = new Set<Id>();
        for(Session_Protocol__c sp : assignedProtocols){
            assignedIds.add(sp.ProtocolId__c);
        }
        return [SELECT Id, Name FROM Protocol__c WHERE Id NOT IN :(assignedIds)];

    }

    public class protocolAssignment {
        @AuraEnabled public Session_Protocol__c[] assignedProtocols { get; set; }
        @AuraEnabled public Protocol__c[] unassignedProtocols { get; set; }
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