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
    public static EvalConfig getEvalConfig(Id recordId){
        try {
            EvalConfig configInfo = new EvalConfig();
            configInfo.testConfig = Test_Config__mdt.getInstance(recordId);
            configInfo.pdListOfLists = prepPicklistDescriptions(recordId);
            
            System.debug('configInfo.testConfig: ' + configINfo.testConfig.DeveloperName);
            // System.debug('picklistDescriptions: ' + picklistDescriptions);
            return configInfo;
        } catch (Exception e) {
            System.debug('Error: ' + e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static List<Picklist_Description_Config__mdt[]> prepPicklistDescriptions(Id recordId){
        Picklist_Description_Config__mdt[] picklistDescriptions = [
            SELECT Id, DeveloperName, MasterLabel, Field_API_Name__c, Field_Description__c, Field_Value__c, Object_API_Name__c, Picklist_Order__c, Value_Category__c, Test_Config__c
            FROM Picklist_Description_Config__mdt
            WHERE Test_Config__c = :recordId
            ORDER BY Value_Category__c ASC, Picklist_Order__c ASC
        ];

        Map<String, Picklist_Description_Config__mdt[]> pdMap = new Map<String, Picklist_Description_Config__mdt[]>();

        for(Picklist_Description_Config__mdt pd : picklistDescriptions){
            if(pdMap.containsKey(pd.Value_Category__c)){
                pdMap.get(pd.Value_Category__c).add(pd);
            } else {
                pdMap.put(pd.Value_Category__c, new Picklist_Description_Config__mdt[]{pd});
            }
        }

        List<Picklist_Description_Config__mdt[]> pdListOfLists = new List<Picklist_Description_Config__mdt[]>();
        for(String i : pdMap.keySet()){
            pdListOfLists.add(pdMap.get(i));
        }
        return pdListOfLists;
    }

    public class EvalConfig {
        @AuraEnabled public Test_Config__mdt testConfig;
        @AuraEnabled public List<Picklist_Description_Config__mdt[]> pdListOfLists;

    }

    // public class PicklistDescriptions{
    //     @AuraEnabled public Test_Config__mdt testConfig;
    // }

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
