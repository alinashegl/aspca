public with sharing class ScheduleAnimalPlaygroups {
    public static Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.PLAYGROUP_TASK_RECORD_TYPE_NAME);
    public static Task[] schedulePlaygroups() {
        Task[] playgroupTasks = new Task[0];
        Map<String, Calendar_Schedule_Config__mdt> calendarConfigMap = AutoScheduleTasksUtil.getCalendarConfig('Playgroup');
        for(Animal__c animal : [
            SELECT Id, Playgroup_Priority_Level__c, Shelter_Location2__c, Animal_Name_Id__c, Current_Recent_Shelter_Location__c, Current_Location__c, 
            Behavior_Case_Worker__r.Name, Behavior_Case_Worker__r.Is_Generic_Contact__c
            FROM Animal__c 
            WHERE Playgroup_Priority_Level__c != null 
            AND Current_Recent_Shelter_Location__c IN: AutoScheduleTasksUtil.dogPopulations
            AND Type_of_Animal__c = 'Dog'
        ]){
            String configKey = animal.Current_Recent_Shelter_Location__c + '-' + animal.Playgroup_Priority_Level__c.split(' ')[0];
            if(calendarConfigMap.containsKey(configKey)){
                playgroupTasks.addAll(prepTasks(animal, calendarConfigMap.get(configKey)));
            }
        }
        return playgroupTasks;
    }

    private static Task[] prepTasks(Animal__c animal, Calendar_Schedule_Config__mdt config){
        Contact genericCon = AutoScheduleTasksUtil.genericContactMap.get(animal.Current_Recent_Shelter_Location__c);
        Task[] newTasks = new Task[0];
        Map<String, Date> dateMap = AutoScheduleTasksUtil.getDateMap(config);
        for(String day : dateMap.keySet()){
            Task newTask = new Task(
                WhatId = animal.Id,
                Animal__c = animal.Id,
                RecordTypeId = recordTypeId,
                ActivityDate = dateMap.get(day),
                Description = 'Playgroup is needed for: ' + animal.Animal_Name_Id__c + ' (' + animal.Current_Recent_Shelter_Location__c + ')',
                IsReminderSet = true,
                Status = 'Not Started',
                WhoId = animal.Behavior_Case_Worker__c != null ? animal.Behavior_Case_Worker__c : genericCon.Id,
                OwnerId = genericCon.User__c,
                Subject = 'Playgroup',
                Species__c = 'Dog'
            );
            newTasks.add(newTask);
        }
        return newTasks;
    }
}
