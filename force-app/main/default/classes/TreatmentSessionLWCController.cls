public with sharing class TreatmentSessionLWCController {
    @AuraEnabled
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
                AND IsRemoved__c = false
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static protocolInfo getActiveProtocolsAndFields(Id sessionId){
        try {

            Session_Protocol__c[] pr = getActiveProtocols(sessionId);
            protocol protocol = new Protocol(pr[0]);

            ProtocolInfo info = new ProtocolInfo();
            info.protocols = new Protocol[]{protocol};
            info.fearBestField = getPicklistValues('Fear_Best__c', String.valueOf(pr[0].get('Fear_Best__c')));
            info.fearWorstField = getPicklistValues('Fear_Worst__c', String.valueOf(pr[0].get('Fear_Worst__c')));

            return info;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static Session_Protocol__c getProtocol(Id protocolId){
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
                WHERE Id =: protocolId
                AND IsRemoved__c = false
            ];
    }

    @AuraEnabled
    public static protocolNew getActiveProtocolAndFieldsNew(Id protocolId){
        try {
            Session_Protocol__c sessionProtocol = getProtocol(protocolId);
            // protocolNew protocolInfo = new ProtocolNew();
            // for(Session_Protocol__c sProtocol : sessionProtocols){
                ProtocolNew protocolInfo = new ProtocolNew(sessionProtocol);
            // }

            // ProtocolInfo info = new ProtocolInfo();
            // info.protocols = new Protocol[]{protocol};
            // info.fearBestField = getPicklistValues('Fear_Best__c', String.valueOf(pr[0].get('Fear_Best__c')));
            // info.fearWorstField = getPicklistValues('Fear_Worst__c', String.valueOf(pr[0].get('Fear_Worst__c')));

            System.debug('protocolInfo = ' + protocolInfo);
            return protocolInfo;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static fieldInfo getPicklistValues(String fieldApi, String currentselection){
        picklistValue[] picklistValues = new picklistValue[0];
        DescribeSObjectResult objResult = Schema.getGlobalDescribe().get('Session_Protocol__c').getDescribe();
        DescribeFieldResult fieldResult = objResult.fields.getMap().get(fieldApi).getDescribe();
		Schema.PicklistEntry[] values = fieldResult.getPicklistValues();
        FieldInfo fieldInfo = new FieldInfo(values, currentselection);

		// for(Schema.PicklistEntry pickListVal : values){
        //     pickListValue pval = new PicklistValue(picklistVal, currentselection);

        //     picklistValues.add(pVal);
		// }

        System.debug('fieldInfo = ' + fieldInfo);
		return fieldInfo;
    }

    public static Schema.PicklistEntry[] getPicklistValuesNew(String fieldApi){
        picklistValue[] picklistValues = new picklistValue[0];
        DescribeSObjectResult objResult = Schema.getGlobalDescribe().get('Session_Protocol__c').getDescribe();
        DescribeFieldResult fieldResult = objResult.fields.getMap().get(fieldApi).getDescribe();
		Schema.PicklistEntry[] values = fieldResult.getPicklistValues();

        System.debug('values = ' + values);
		return values;
    }    

    /*******For radio button start */
    // public class protocolInfoNew{
    //     @AuraEnabled public protocolNew[] protocols;
    // }

    public class ProtocolNew{
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public Boolean needsReview { get; set; }
        @AuraEnabled public Boolean isSkipped { get; set; }
        @AuraEnabled public picklistField[] picklistFields {get; set;}

        ProtocolNew(Session_Protocol__c sp){
            this.id = sp.Id;
            this.name = sp.Protocol_Name__c;
            this.needsReview = sp.Needs_Review__c;
            this.isSkipped = sp.IsSkipped__c;
            this.picklistFields = new PicklistField[0];

            String[] fieldList = new String[]{
                'Fear_Best__c',
                'Fear_Worst__c',
                'Arousal_Best__c',
                'Arousal_Worst__c',
                'Aggressive_Worst__c',
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
        @AuraEnabled public selectionOption[] options { get; set; }

        PicklistField(String fieldAPI, String currentValue){
            this.apiName = fieldAPI;
            String objectAPI = 'Session_Protocol__c';
            this.name = String.valueOf(Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(FieldApi).getDescribe().getLabel());
            this.currentValue = currentValue;
            Schema.PicklistEntry[] options = TreatmentSessionLWCController.getPicklistValuesNew(fieldApi);
            this.options = new SelectionOption[0];
            for(Schema.PicklistEntry option : options){
                // SelectionOption newOption = new SelectionOption(option);
                this.options.add(new SelectionOption(option));
            }
        }
    }

    public class SelectionOption{
        @AuraEnabled public String label;
        @AuraEnabled public String value;

        selectionOption(Schema.PicklistEntry item){
            this.label = item.label;
            this.value = item.label;
        }
    }

    /*******For radio button end */    

    public class protocolInfo{
        @AuraEnabled public protocol[] protocols;
        @AuraEnabled public fieldInfo fearBestField;
        @AuraEnabled public fieldInfo fearWorstField;
    }

    public class protocol{
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String aggresiveWorst { get; set; }
        @AuraEnabled public String arousalBest { get; set; }
        @AuraEnabled public String arousalWorst { get; set; }
        @AuraEnabled public String fearBest { get; set; }
        @AuraEnabled public String fearWorst { get; set; }
        @AuraEnabled public String socialBest { get; set; }
        @AuraEnabled public String overallScore { get; set; }
        @AuraEnabled public Boolean needsReview { get; set; }
        @AuraEnabled public Boolean isSkipped { get; set; }

        public protocol(){}

        public protocol(Session_Protocol__c pr){
            this.id = pr.Id;
            this.name = pr.ProtocolId__r.Name;
            this.fearBest = pr.Fear_Best__c;
            this.fearWorst = pr.Fear_Worst__c;
        }
    }

    public class FieldInfo{
        @AuraEnabled public picklistValue[] picklistValues;
        @AuraEnabled public String currentSelection;

        public fieldInfo(Schema.PicklistEntry[] values, String currentSelection){
            this.picklistValues = new PicklistValue[0];
            for(Schema.PicklistEntry value: values){
                this.picklistValues.add(new Picklistvalue(value));

            }
            this.currentSelection = currentSelection;
        }
    }

    public class PicklistValue{
        @AuraEnabled public String label;
        @AuraEnabled public String value;

        picklistValue(Schema.PicklistEntry item){
            this.label = item.label;
            this.value = item.label;
        }
    }
}



