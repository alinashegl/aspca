public with sharing class ScheduleAnimalBehaviorTreatments {
    public static Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.BEH_TREATMENT_TASK_RECORD_TYPE_NAME);
    public static Task[] scheduleTreatments() {
        Task[] treatmentTasks = new Task[0];
        Map<String, Calendar_Schedule_Config__mdt> calendarConfigMap = AutoScheduleTasksUtil.getCalendarConfig('Treatment');
        for(Treatment_Plan__c treatment : [
            SELECT Id, Custom_Schedule__c, Treatment_Priority__c, Animal__c,
            Animal__r.Animal_Name_Id__c, Animal__r.Current_Recent_Shelter_Location__c, Animal__r.Current_Location__c, 
            Animal__r.Behavior_Case_Worker__c, Animal__r.Behavior_Case_Worker__r.Name, Animal__r.Behavior_Case_Worker__r.Is_Generic_Contact__c,
            Animal__r.Behavior_Case_Worker__r.User__c
            FROM Treatment_Plan__c
            WHERE Animal__r.Current_Recent_Shelter_Location__c IN ('MRC', 'CRC', 'ARC/CARE') 
            AND IsActive__c = TRUE
            AND Treatment_Priority__c NOT IN ('No Treatment', '')
            AND Animal__r.Type_of_Animal__c = 'Dog'
        ]){
            String configKey = treatment.Animal__r.Current_Recent_Shelter_Location__c + '-' + treatment.Treatment_Priority__c.split(' ')[0];
            if(treatment.Custom_Schedule__c != null){
                treatmentTasks.addAll(prepTasks(treatment, null));
            }
            else if(calendarConfigMap.containsKey(configKey)){
                treatmentTasks.addAll(prepTasks(treatment, calendarConfigMap.get(configKey)));
            }
        }
        return treatmentTasks;
    }

    private static Task[] prepTasks(Treatment_Plan__c treatment, Calendar_Schedule_Config__mdt config){
        Contact genericCon = AutoScheduleTasksUtil.genericContactMap.get(treatment.Animal__r.Current_Recent_Shelter_Location__c);
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
                RecordTypeId = recordTypeId,
                ActivityDate = dateMap.get(day),
                Description = 'Beh Treatment is needed for: ' + treatment.Animal__r.Animal_Name_Id__c + ' (' + treatment.Animal__r.Current_Recent_Shelter_Location__c + ')',
                IsReminderSet = true,
                Status = 'Not Started',
                WhoId = treatment.Animal__r.Behavior_Case_Worker__c != null ? treatment.Animal__r.Behavior_Case_Worker__c : genericCon.Id,
                OwnerId = genericCon.User__c,
                Subject = 'Treatment',
                Assigned_Resources__c = treatment.Animal__r.Behavior_Case_Worker__r.Is_Generic_Contact__c == false ? treatment.Animal__r.Behavior_Case_Worker__r.Name : null,
                Species__c = 'Dog'
            );
            newTasks.add(newTask);
        }
        return newTasks;
    }
}
