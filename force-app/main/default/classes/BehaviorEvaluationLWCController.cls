public with sharing class BehaviorEvaluationLWCController {
    @AuraEnabled (cacheable=true)
    public static EvalSummaryInfo getEvalTests(Id evalId) {
        try {
            EvalSummaryInfo info = new EvalSummaryInfo();
            info.eval = [
                SELECT Id
                FROM Behavior_Evaluation__c
                WHERE Id = :evalId
                LIMIT 1
            ];
            Behavior_Evaluation_Summary__c[] testList = [
                SELECT Id, ConfigId__c, Skip_Reason__c, Summary_Comments__c, Test_Comments__c, Test_Name__c
                FROM Behavior_Evaluation_Summary__c
                WHERE Behavior_Evaluation__c = : evalId
                AND Display_Order__c > 0
                AND ConfigId__c != null
                ORDER BY Display_Order__c ASC
                LIMIT 4
            ];
            info.tabList = new TabInfo[0];
            for(Behavior_Evaluation_Summary__c summary : testList){
                TabInfo tab = new TabInfo();
                tab.iconName = 'utility:warning';
                tab.status = 'warning';
                tab.id = summary.Id;
                tab.label = summary.Test_Name__c;
                tab.testSummary = summary;
                info.tabList.add(tab);

            }
            return info;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled (cacheable=true)
    public static EvalConfig getEvalConfig(Id recordId, Id evalId){
        try {
            EvalConfig configInfo = new EvalConfig();
            configInfo.testConfig = Test_Config__mdt.getInstance(recordId);
            String[] selectedValues = getSelectedValues(configInfo.testConfig.Picklist_API_Name__c, evalId);
            // configInfo.pdListOfLists = prepPicklistDescriptions(recordId, selectedValues);
            configInfo.pdListOfListsWithSelections = prepPicklistDescriptions(recordId, selectedValues);
            
            System.debug('configInfo.testConfig: ' + configINfo.testConfig.DeveloperName);
            return configInfo;
        } catch (Exception e) {
            System.debug('Error: ' + e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static String[] getSelectedValues(String fieldName, Id evalId){
        String query = 'SELECT Id, ' + fieldName + ' FROM Behavior_Evaluation__c WHERE Id = :evalId';
        Behavior_Evaluation__c[] evals = Database.Query(query);
        String[] selectionList;
        if(!evals.isEmpty()){
            String selections = (string) evals[0].get(fieldName);
            selectionList = selections == null ? null : selections.split(';');            
        }
        return selectionList;
    }

    private static List<PicklistDescriptions[]> prepPicklistDescriptions(Id recordId, String[] selectedValues){
        Picklist_Description_Config__mdt[] picklistDescriptions = [
            SELECT Id, DeveloperName, MasterLabel, Field_API_Name__c, Field_Description__c, Field_Value__c, Object_API_Name__c, Picklist_Order__c, Value_Category__c, Test_Config__c
            FROM Picklist_Description_Config__mdt
            WHERE Test_Config__c = :recordId
            ORDER BY Value_Category__c ASC, Picklist_Order__c ASC
        ];

        Map<String, Picklist_Description_Config__mdt[]> pdMap = new Map<String, Picklist_Description_Config__mdt[]>();
        Map<String, PicklistDescriptions[]> pdMapNew = new Map<String, PicklistDescriptions[]>();

        for(Picklist_Description_Config__mdt pd : picklistDescriptions){
            PicklistDescriptions pDescription = new PicklistDescriptions();
            pDescription.pDescriptionConfig = pd;
            pDescription.selected = selectedValues.contains(pd.Field_Value__c);
            if(pdMap.containsKey(pd.Value_Category__c)){
                pdMap.get(pd.Value_Category__c).add(pd);
                pdMapNew.get(pd.Value_Category__c).add(pDescription);

            } else {
                pdMap.put(pd.Value_Category__c, new Picklist_Description_Config__mdt[]{pd});
                pdMapNew.put(pd.Value_Category__c, new PicklistDescriptions[]{pDescription});
            }
        }

        List<Picklist_Description_Config__mdt[]> pdListOfLists = new List<Picklist_Description_Config__mdt[]>();
        List<PicklistDescriptions[]> pdListOfListsWithSelections = new List<PicklistDescriptions[]>();

        for(String i : pdMap.keySet()){
            pdListOfLists.add(pdMap.get(i));
            pdListOfListsWithSelections.add(pdMapNew.get(i));

        }
        return pdListOfListsWithSelections;
    }

    public class EvalConfig {
        @AuraEnabled public Test_Config__mdt testConfig;
        @AuraEnabled public List<Picklist_Description_Config__mdt[]> pdListOfLists;
        @AuraEnabled public List<PicklistDescriptions[]> pdListOfListsWithSelections;

    }

    public class PicklistDescriptions{
        @AuraEnabled public Picklist_Description_Config__mdt pDescriptionConfig;
        @AuraEnabled public Boolean selected;
    }

    public class EvalSummaryInfo{
        @AuraEnabled public Behavior_Evaluation__c eval;
        @AuraEnabled public TabInfo[] tabList;
    }

    public class TabInfo{
        @AuraEnabled public String iconName;
        @AuraEnabled public String status;
        @AuraEnabled public String label;
        @AuraEnabled public String id;
        @AuraEnabled public Behavior_Evaluation_Summary__c testSummary;
    }
}
