public with sharing class BehEvalTemplateLWCController {
    @AuraEnabled(cacheable=true)
    public static Beh_Eval_Tab_Template__c[] getVerticalTabs(Id templateId){
        try {
            return 
            [
                SELECT Id, Label__c, Display_Order__c 
                FROM Beh_Eval_Tab_Template__c 
                WHERE Behavior_Evaluation_Template__c = :templateId
                ORDER BY Display_Order__c ASC
            ];            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Beh_Eval_Tab_Activitiy__c[]> getActivitySectionsForTab(Id tabId){
        try {
            Map<Decimal, Beh_Eval_Tab_Activitiy__c[]> sectionMap = new Map<Decimal, Beh_Eval_Tab_Activitiy__c[]>();
            for(Beh_Eval_Tab_Activitiy__c act : [
                SELECT Id, Section__c, Order__c 
                FROM Beh_Eval_Tab_Activitiy__c 
                WHERE Beh_Eval_Tab_Template__c = :tabId 
                ORDER BY Section__c ASC, Order__c ASC
            ]){
                if(sectionMap.containsKey(act.Section__c)){
                    sectionMap.get(act.Section__c).add(act);
                } else {
                    sectionMap.put(act.Section__c, new Beh_Eval_Tab_Activitiy__c[]{act});
                }
            }
            List<Beh_Eval_Tab_Activitiy__c[]> actListOfLists = new List<Beh_Eval_Tab_Activitiy__c[]>();
            for(Decimal i : sectionMap.keySet()){
                actListOfLists.add(sectionMap.get(i));
            }
            return actListOfLists;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string getActivities(Id tabId){
        try {
            
            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
