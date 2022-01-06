public with sharing class TaskTriggerHandler {
    public static void updateHandler(Task[] taskList, Map<Id, Task> oldMap) {
        handleDaybackResourceUpdates(taskList, oldMap);
    }

    public static void handleDaybackResourceUpdates(Task[] taskList, Map<Id, Task> oldMap){
        Id[] recordTypeIds = AutoScheduleTasksUtil.getTaskRecordTypeIds();
        for(Task task : taskList){
            //skip any tasks that don't have the correct record type
            if(!recordTypeIds.contains(task.RecordTypeId) && task.Species__c == 'Dog') continue;

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
}
