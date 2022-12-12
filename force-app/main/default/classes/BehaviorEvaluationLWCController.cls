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
    public static Test_Config__mdt getEvalConfig(Id recordId){
        try {
            return Test_Config__mdt.getInstance(recordId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
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
