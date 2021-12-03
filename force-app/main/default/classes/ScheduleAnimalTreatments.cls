public with sharing class ScheduleAnimalTreatments {
    public static Task[] scheduleTreatments() {
        Task[] treatmentTasks = new Task[0];
        Map<String, Calendar_Schedule_Config__mdt> calendarConfigMap = AutoScheduleTasksUtil.getCalendarConfig('Treatment');
        for(Treatment_Plan__c treatment : [
            SELECT Id, Custom_Schedule__c, Treatment_Priority__c, Animal__c,
            Animal__r.Animal_Name_Id__c, Animal__r.Current_Recent_Shelter_Location__c, Animal__r.Current_Location__c, Animal__r.Behavior_Case_Worker__c, Animal__r.Behavior_Case_Worker__r.Name
            FROM Treatment_Plan__c
            WHERE Animal__r.Current_Recent_Shelter_Location__c IN ('MRC', 'CRC') 
            AND IsActive__c = TRUE
            AND Treatment_Priority__c NOT IN ('No Treatment', '')
        ]){
            String configKey = treatment.Animal__r.Current_Recent_Shelter_Location__c + '-' + treatment.Treatment_Priority__c.split(' ')[0];
            if(treatment.Custom_Schedule__c != null || calendarConfigMap.containsKey(configKey)){
                treatmentTasks.addAll(prepTasks(treatment, calendarConfigMap.containsKey(configKey) ? calendarConfigMap.get(configKey) : null));
            }
        }
        return treatmentTasks;
    }

    private static Task[] prepTasks(Treatment_Plan__c treatment, Calendar_Schedule_Config__mdt config){
        Id taskRTId = [SELECT Id FROM RecordType WHERE SobjectType = 'Task' AND DeveloperName =: AutoScheduleTasksUtil.TREATMENT_TASK_RECORD_TYPE_NAME LIMIT 1].Id;
        Task[] newTasks = new Task[0];
        Map<String, Date> dateMap = new Map<String, Date>();
        
        if(config != null){
            dateMap = AutoScheduleTasksUtil.getDateMap(config);
        } else {
            dateMap = AutoScheduleTasksUtil.getDateMap(treatment.Custom_Schedule__c);
        }

        for(String day : dateMap.keySet()){
            Task newTask = new Task(
                WhatId = treatment.Id,
                Animal__c = treatment.Animal__c,
                RecordTypeId = taskRTId,
                ActivityDate = dateMap.get(day),
                Description = 'Treatment is needed for: ' + treatment.Animal__r.Animal_Name_Id__c + ' (' + treatment.Animal__r.Current_Recent_Shelter_Location__c + ')',
                IsReminderSet = true,
                Status = 'Not Started',
                WhoId = treatment.Animal__r.Behavior_Case_Worker__c != null ? treatment.Animal__r.Behavior_Case_Worker__c : '0030100000IdslhAAB',
                Subject = 'Treatment'
                // ,Assigned_Resources__c = treatment.Animal__r.Animal_Name_Id__c + ';' + AutoScheduleTasksUtil.NO_RESOURCE_DEFAULT

            );
            newTasks.add(newTask);
        }
        return newTasks;
    }
}
