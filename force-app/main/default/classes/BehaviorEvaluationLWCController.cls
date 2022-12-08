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
            info.testList = [
                SELECT Id, ConfigId__c, Skip_Reason__c, Summary_Comments__c, Test_Comments__c, Test_Name__c
                FROM Behavior_Evaluation_Summary__c
                WHERE Behavior_Evaluation__c = : evalId
                AND Display_Order__c > 0
                ORDER BY Display_Order__c ASC
                LIMIT 2
            ];
            info.tabList = new TabInfo[0];
            for(Behavior_Evaluation_Summary__c summary : info.testList){
                TabInfo tab = new TabInfo();
                tab.iconName = 'utility:warning';
                tab.status = 'warning';
                tab.Id = summary.Id;
                tab.label = summary.Test_Name__c;
                info.tabList.add(tab);
            }

            // info.config = Test_Config__mdt.getInstance(info.summary.configId__c);
            return info;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class EvalSummaryInfo{
        @AuraEnabled public Behavior_Evaluation__c eval;
        @AuraEnabled public Behavior_Evaluation_Summary__c[] testList;
        @AuraEnabled public TabInfo[] tabList;
    }

    public class TabInfo{
        @AuraEnabled public String iconName;
        @AuraEnabled public String status;
        @AuraEnabled public String label;
        @AuraEnabled public String id;
    }
}
