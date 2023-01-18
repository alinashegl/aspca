public with sharing class CreateTaskLWCController {
    @AuraEnabled(cacheable=true)
    public static NewTaskWrapper getRecordInfo(Id recordId){
        System.debug('recordId: ' + recordId);
        try {
            NewTaskWrapper taskInfo = new NewTaskWrapper(); 
            if(recordId != null){
                Schema.SObjectType AnimalObject = Schema.Animal__c.getSObjectType();
                Schema.SObjectType record = recordId.getsobjecttype();
                If(record == AnimalObject){
                    taskInfo.animal =  [
                        SELECT 
                        Id, Behavior_Case_Worker__c, Current_Recent_Shelter_Location__c
                        FROM Animal__c
                        WHERE Id = :recordId
                        LIMIT 1
                    ];
                }
            }

            taskInfo.subjectOptions = getTaskSubjectPicklistValues();
            taskInfo.recordTypeOptions = getTaskRecordTypes();
            taskInfo.defaultRecordType = Util.getRecordTypeId('Task', 'General_Task');
            taskInfo.dueToday = Date.today();

            return taskInfo;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Id getBehCaseWorker(Id animalId){
        try {
            Animal__c dog = [SELECT Id, Behavior_Case_Worker__c FROM Animal__c WHERE Id = :animalId LIMIT 1];
            return dog.Behavior_Case_Worker__c != null ? dog.Behavior_Case_Worker__c : null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    

    @AuraEnabled
    public static string insertTask(Task task){
        try {
            System.debug('task: ' + task);
            Animal__c dog = [SELECT Id, Current_Recent_Shelter_Location__c FROM Animal__c WHERE Id = :task.Animal__c LIMIT 1];
            Contact genericCon;
            if(dog.Current_Recent_Shelter_Location__c != null){
                genericCon = AutoScheduleTasksUtil.genericContactMap.get(dog.Current_Recent_Shelter_Location__c);
            }

            task.WhatId = task.Animal__c;
            task.OwnerId = genericCon != null && genericCon.User__c != null ? genericCon.User__c : UserInfo.getUserId();
            task.Species__c = 'Dog';
            insert task;
            return URL.getSalesforceBaseUrl().toExternalForm() + '/' + task.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static RecordType[] getTaskRecordTypes(){
        return [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Task'];
    }

    private static String[] getTaskSubjectPicklistValues(){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.Subject.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }
        return pickListValuesList;
    }

    public class NewTaskWrapper{
        @AuraEnabled public Animal__c animal;
        @AuraEnabled public RecordType[] recordTypeOptions;
        @AuraEnabled public String[] subjectOptions;
        @AuraEnabled public Id defaultRecordType;
        @AuraEnabled public Date dueToday;
    }
}
