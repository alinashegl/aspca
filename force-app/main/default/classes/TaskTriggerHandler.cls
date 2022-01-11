public class TaskTriggerHandler {
    public static Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.BEHAVIOR_MED_CHECK_TASK_RECORD_TYPE_NAME);
    
    public static void afterInsertHandler(List<Task> newRecords){
        checkBehaviorMedication(newRecords, null);
    }
    
    public static void afterUpdateHandler(List<Task> newRecords, Map<Id, Task> oldRecords){
    }
    
    public static void checkBehaviorMedication(List<Task> newRecords, Map<Id, Task> oldRecords){
        Map<Id, Task> taskMap = new Map<Id, Task>();
        String animal_prefix = Schema.SObjectType.Animal__c.getKeyPrefix();
        for(Task t : newRecords){
            if(t.WhatId != null && ((String)t.WhatId).startsWith(animal_prefix)){
                taskMap.put(t.whatId, t);
            }
        }
        Map<String, Task> existingTaskMap = getExistingTasks(taskMap);
        system.debug('existingTaskMap:'+existingTaskMap);
       	List<Task> newTasks = new List<Task>();
        TaskWrapper wrapper = getTreatmentTasks(taskMap);
        for(Task t : wrapper.taskMapByAnimal.values()){
            System.debug(String.valueOf(t.WhatId)+String.valueOf(t.Medication__c));
            if(!existingTaskMap.containsKey(String.valueOf(t.WhatId)+String.valueOf(t.Medication__c))){
                DateTime dT = t.CreatedDate;
                Date createdDate = date.newinstance(dT.year(), dT.month(), dT.day());
                List<Integer> dayEntries = new List<Integer>{0, 1, 3};
                    for(Integer i : dayEntries){
                        Date followupDate = DateTimeUtility.AddBusinessDays(createdDate, i);
                        Task newTask = prepTask(t, followupDate, wrapper);
                        if( newTask != null){
                            newTasks.add(newTask);
                        }
                    }
            }
        }
        
        if(newTasks.size() > 0){
            insert newTasks;
        }
    }
    
    public static TaskWrapper getTreatmentTasks(Map<Id, Task> taskMap){
        Map<Id, Animal__c> animalMap = new Map<Id, Animal__c>([SELECT Animal_Name_Id__c, Current_Recent_Shelter_Location__c,
                                                           Behavior_Case_Worker__c,Behavior_Case_Worker__r.Name, 
                                                           Behavior_Case_Worker__r.Is_Generic_Contact__c 
                                                           FROM ANimal__c where id in : taskMap.keySet()]);
        Map<Id, Task> taskMapByAnimalId = new Map<Id, Task>();
            
        List<Task> tasks = [SELECT Id, IsRecurrence, CreatedDate, ActivityDate, RecurrenceStartDateOnly, 
                            RecurrenceEndDateOnly, RecurrenceActivityId,WhatId, WhoId, OwnerId, 
                            Animal_Exam_Sheet_Lookup__c, Medication__r.Behavior_Medication__c, Medication__c
                            FROM Task WHERE RecordType.Name = 'Treatments'
                            AND Species__c = 'Dog' 
                            AND Medication__r.Behavior_Medication__c = true 
                            AND Id IN : taskMap.values()];
        
        for(Task t : tasks){
            taskMapByAnimalId.put(t.WhatId, t);
        }
        TaskWrapper twrapper = new TaskWrapper();
        twrapper.amimalMap = animalMap;
        twrapper.taskMapByAnimal = taskMapByAnimalId;
        return twrapper;
    }
    
    private static Task prepTask(Task t, Date taskDate, TaskWrapper wrapper){
        Task treatmentTask = wrapper.taskMapByAnimal.get(t.WhatId);
        Animal__c animal = wrapper.amimalMap.get(t.WhatId);
        Contact genericCon = AutoScheduleTasksUtil.genericContactMap.get(animal.Current_Recent_Shelter_Location__c);
        if(taskDate != null && animal.Behavior_Case_Worker__c == null && genericCon == null && String.isBlank(genericCon?.User__c)){
            return null;
        }
        System.debug(genericCon);
        Task newTask = new Task();
            newTask.WhatId = treatmentTask.Animal_Exam_Sheet_Lookup__c;
            newTask.Animal__c = animal.Id;
            newTask.RecordTypeId = recordTypeId;
            newTask.ActivityDate = taskDate;
            newTask.Description = 'Med Check is needed for: ' + animal.Animal_Name_Id__c + ' (' + animal.Current_Recent_Shelter_Location__c + ')';
            newTask.IsReminderSet = false;
            newTask.Status = 'Not Started';
            newTask.WhoId = animal.Behavior_Case_Worker__c != null ? animal.Behavior_Case_Worker__c : genericCon.Id;
            //newTask.OwnerId = genericCon.User__c;
            newTask.Subject = 'Behavior Medication Check';
            newTask.Medication__c = treatmentTask.Medication__c;
            newTask.Assigned_Resources__c = animal.Behavior_Case_Worker__r.Is_Generic_Contact__c == false ? animal.Behavior_Case_Worker__r.Name : null;
            newTask.Species__c = 'Dog';

        return newTask;
    }
    
    public static Map<String, Task> getExistingTasks(Map<Id, Task> taskMap){
        Map<String, Task> existingTaskMap = new Map<String, Task>();
        List<Task> tasks = [Select Animal__c, Medication__c from task where recordTypeId =: recordTypeId and Medication__c != null and Id not in : taskMap.values()];
        for(Task t : tasks){
            existingTaskMap.put(String.valueof(t.Animal__c)+String.valueOf(t.Medication__c), t);
        }
        return existingTaskMap;
    }
    
    public class TaskWrapper{
        public Map<Id, Animal__c> amimalMap;
        public Map<Id, Task> taskMapByAnimal;
    }
}