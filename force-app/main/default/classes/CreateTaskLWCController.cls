/**
 * This class is used by the createTask LWC to add the ability to create a task from the utilty bar
 */

public with sharing class CreateTaskLWCController {
    /**
     * Used to gather the default values
     * and picklist values needed for task fields
     * 
     * @param recordId Id of current record
     * 
     * @return newTaskWrapper 
     */
    @AuraEnabled(cacheable=true)
    public static NewTaskWrapper getRecordInfo(Id recordId){
        try {
            NewTaskWrapper taskInfo = new NewTaskWrapper();
            //the recordId can be null, in case the user is not currently on a record page
            if(recordId != null){
                //need verify if the recordId is an Animal__c Id or another object
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
            System.debug('Exception: ' + e.getMessage());
            System.debug('stack trace ' + e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Gets the Id of the Behvavior Case Worker assigned to the animal
     * 
     * @param anmialId Id of the animal
     * 
     * @return Id
     */
    @AuraEnabled
    public static Id getBehCaseWorker(Id animalId){
        try {
            if(animalId == null) return null;
            Animal__c dog = [SELECT Id, Behavior_Case_Worker__c FROM Animal__c WHERE Id = :animalId LIMIT 1];
            return dog.Behavior_Case_Worker__c != null ? dog.Behavior_Case_Worker__c : null;
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            System.debug('stack trace ' + e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /**
     * Inserts the task and returns the url to the new task
     * 
     * @param task the fields and values for the task to be inserted
     * 
     * @return URL to navigate to the task
     */
    @AuraEnabled
    public static string insertTask(Task task){
        try {
            //First query the anmal
            Animal__c dog = [SELECT Id, Current_Recent_Shelter_Location__c, Animal_Name_Id__c FROM Animal__c WHERE Id = :task.Animal__c LIMIT 1];

            //get the generic contact based on the animal's Current_Recent_Shelter_Location__c
            Contact genericCon;
            if(dog.Current_Recent_Shelter_Location__c != null){
                genericCon = AutoScheduleTasksUtil.genericContactMap.get(dog.Current_Recent_Shelter_Location__c);
            }

            task.WhatId = task.Animal__c;
            task.OwnerId = genericCon != null && genericCon.User__c != null ? genericCon.User__c : UserInfo.getUserId();
            task.Species__c = 'Dog';

            //If the task record type is General Task and the whoId is not null we want to set the Assigned_Resources__c field on the task
            if(task.RecordTypeId == (Util.getRecordTypeId('Task', 'General_Task')) && task.whoId != null){
                Contact con = [SELECT Id, Name FROM Contact WHERE Id = :task.WhoId LIMIT 1];
                task.Assigned_Resources__c = dog.Animal_Name_Id__c + ';' + con.Name;
            }
            insert task;
            return URL.getSalesforceBaseUrl().toExternalForm() + '/' + task.Id;
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            System.debug('stack trace ' + e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**** Private methods */

    /**
     * Queries the list of task record types
     * 
     * @return RecordType[]
     */
    private static RecordType[] getTaskRecordTypes(){
        return [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Task'];
    }

    /**
     * Compiles the list of picklist options for Task.Subject
     * 
     * @return String[] a list of picklist options
     */
    private static String[] getTaskSubjectPicklistValues(){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.Subject.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }
        return pickListValuesList;
    }

    //Class to hold the information needed by the createTask LWC
    public class NewTaskWrapper{
        @AuraEnabled public Animal__c animal;
        @AuraEnabled public RecordType[] recordTypeOptions;
        @AuraEnabled public String[] subjectOptions;
        @AuraEnabled public Id defaultRecordType;
        @AuraEnabled public Date dueToday;
    }
}