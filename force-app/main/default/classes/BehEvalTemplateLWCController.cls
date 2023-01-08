public with sharing class BehEvalTemplateLWCController {
    @AuraEnabled(cacheable=true)
    public static Beh_Eval_Tab_Template__c[] getVerticalTabs(Id templateId){
        try {
            return 
            [
                SELECT Id, Label__c FROM Beh_Eval_Tab_Template__c WHERE Behavior_Evaluation_Template__c = :templateId
            ];            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
