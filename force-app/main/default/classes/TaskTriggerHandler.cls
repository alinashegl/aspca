public with sharing class TaskTriggerHandler {
    public static Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.BEHAVIOR_MED_CHECK_TASK_RECORD_TYPE_NAME);
    public static void updateHandler(Task[] taskList, Map<Id, Task> oldMap) {
        handleDaybackResourceUpdates(taskList, oldMap);
    }

    public static void onInsertHandler(Task[] taskList){
        handleAssignDaybackResources(taskList);
    }

    public static void afterInsertHandler(List<Task> newRecords){
        checkBehaviorMedication(newRecords, null);
    }

    public static void handleAssignDaybackResources(Task[] taskList){
        Map<Id, Task[]> animalToTaskMap = new Map<Id, Task[]>();
        Id[] taskRTIds = getRTIds();

        for(Task task : taskList){
            if(taskRTIds.Contains(task.RecordTypeId) && Task.Species__c == 'Dog' && task.Animal__c != null){
                if(animalToTaskMap.containsKey(task.Animal__c)){
                    animalToTaskMap.get(task.Animal__c).add(task);
                } else {
                    animalToTaskMap.put(task.Animal__c, new Task[]{task});
                }
            }
        }

        for(Animal__c animal : queryAnimals(new Id[animalToTaskMap.keySet()])){
            for(Task task : animalToTaskMap.get(animal.Id)){
                task.Assigned_Resources__c = AutoScheduleTasksUtil.determineResources(animal);
            }
        }
    }

    private static Animal__c[] queryAnimals(Id[] animalIds){
        return [SELECT Id,Animal_Name_Id__c, Behavior_Case_Worker__r.Is_Generic_Contact__c, Behavior_Case_Worker__r.Name FROM Animal__c WHERE Id IN: animalIds];
    }

    private static Id[] getRTIds(){
        Id[] rtIds = new Id[0];
        for(String rtName : AutoScheduleTasksUtil.taskRecordTypes){
            Id rtId = Util.getRecordTypeId('Task', rtName);
            if(rtId != null){
                rtIds.add(rtId);
            }
        }

        return rtIds;
    }

    public static void handleDaybackResourceUpdates(Task[] taskList, Map<Id, Task> oldMap){
        Id[] recordTypeIds = getRTIds();
        for(Task task : taskList){
            //skip any tasks that don't have the correct record type
            if(!recordTypeIds.contains(task.RecordTypeId) || task.Species__c != 'Dog') continue;

            Task oldTask = oldMap.get(task.Id);
            if(task.Assigned_Resources__c != oldTask.Assigned_Resources__c){
                //get a map of old and new resources to compare
                Map<String, String[]> newResourceMap = resourceMap(task.Assigned_Resources__c);
                Map<String, String[]> oldResourceMap = resourceMap(oldTask.Assigned_Resources__c);
                
                //if additional dog was added as a resource revert to original resources and date
                if(newResourceMap.containsKey('dog')){
                    if(newResourceMap.get('dog').size() > 1){
                        task.Assigned_Resources__c = oldTask.Assigned_Resources__c;
                        task.ActivityDate = oldTask.ActivityDate;
                        continue;
                    }
                }
                //if the dogs match don't do anything
                if(
                    oldResourceMap.containsKey('dog') &&    
                    newResourceMap.containsKey('dog') &&
                    newResourceMap.get('dog') == oldResourceMap.get('dog')
                ){
                    if(newResourceMap.containsKey('contact')){
                        task.Assigned_Resources__c = task.Animal_Name__c + ';' + cleanResources(newResourceMap.get('contact'));
                    }
                } else {
                    //if the dogs don't match and the orignal had a dog resource put it back
                    String[] resourceList = new String[0];
                    if(oldResourceMap.containsKey('dog')){
                        resourceList.add(task.Animal_Name__c);
                        task.ActivityDate = oldTask.ActivityDate;
                    }
                    //if there are new contacts add them as resources
                    if(newResourceMap.containsKey('contact')){
                        resourceList.addAll(newResourceMap.get('contact'));
                    }
                    //if no new contacts put the old contacts back
                    else if(oldResourceMap.containsKey('contact')){
                        resourceList.addAll(oldResourceMap.get('contact'));
                    }
                    task.Assigned_Resources__c = cleanResources(resourceList);
                }
            }
        }
    }

    //used to remove the 'no contact' resource if another contact resource has been added
    public static String cleanResources(String[] resourceList){
        if(resourceList.size() > 1 && resourceList.contains(AutoScheduleTasksUtil.NO_CONTACT_RESOURCE)){
            Integer index = resourceList.indexOf(AutoScheduleTasksUtil.NO_CONTACT_RESOURCE);
            resourceList.remove(index);
        }
        return String.join(resourceList,';');
    }

    public static Map<String, String[]> resourceMap(String resources){
        Map<String, String[]> resourceMap = new Map<String, String[]>();
        for(String resource : resources.split(';')){
            String type = (resource.contains('(') && resource.contains(')')) ? 'dog' : 'contact';
            if(resourceMap.containsKey(type)){
                resourceMap.get(type).add(resource);
            } else {
                resourceMap.put(type, new String[]{resource});
            }
        }
        return resourceMap;
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
            if(!existingTaskMap.containsKey(String.valueOf(t.WhatId)+String.valueOf(t.Medication__c)) && t.ActivityDate != null){
                Date activityDate = t.ActivityDate;
                List<Integer> dayEntries = new List<Integer>{0, 1, 3};
                    for(Integer i : dayEntries){
                        Date followupDate = activityDate.addDays(i);
                        System.debug('followUpDate'+followUpDate);
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
                                                           FROM ANimal__c where id in : taskMap.keySet()
                                                           AND Active_Animal__c = true
                                                           ]);
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
            newTask.Description = AutoScheduleTasksUtil.BMED_DESCRIPTION + animal.Animal_Name_Id__c + ' (' + animal.Current_Recent_Shelter_Location__c + ')';
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