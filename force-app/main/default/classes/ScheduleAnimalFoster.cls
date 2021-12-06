public with sharing class ScheduleAnimalFoster {
    public static Task[] scheeduleFollowUps() {
        Task[] fosterTasks = new Task[0];
        Map<String, Calendar_Schedule_Config__mdt> calendarConfigMap = AutoScheduleTasksUtil.getCalendarConfig('Foster');
        Calendar_Schedule_Config__mdt defaultConfig = calendarConfigMap.get('Foster - All-Foster - Weekly');
        for(Animal__c animal : getAnimals()){
            fosterTasks.addAll(prepTasks(animal, defaultConfig));
        }

        return fosterTasks;
    }

    public static Animal__c[] getAnimals(){
        return [
            SELECT Id, Animal_Name_Id__c, Current_Recent_Shelter_Location__c, Current_Location__c, 
            Behavior_Case_Worker__c, Behavior_Case_Worker__r.Name,
            (
                SELECT Id, Follow_Up_Days__c, Follow_Up_Frequency__c, CreatedDate
                FROM Animal_Locations__r
                WHERE Facility_Outcome__c = 'Foster Home'
                AND (End_Date__c = null OR End_Date__c >= TODAY)
                ORDER BY CreatedDate DESC
                LIMIT 1
            )
            FROM Animal__c
            WHERE Current_Location__c = 'Foster Home'
            AND Id IN
            (
                SELECT Animal__c
                FROM Facility_Outcome__c
                WHERE Facility_Outcome__c = 'Foster Home'
                AND (End_Date__c = null OR End_Date__c >= TODAY)
            )
        ];
    }

    public static Task[] prepTasks(Animal__c animal, Calendar_Schedule_Config__mdt config){
        Id taskRTId = [SELECT Id FROM RecordType WHERE SobjectType = 'Task' AND DeveloperName =: AutoScheduleTasksUtil.FOSTER_TASK_RECORD_TYPE_NAME LIMIT 1].Id;
        Task[] newTasks = new Task[0];
        Map<String, Date> dateMap = new Map<String, Date>();

        Facility_Outcome__c location = animal.Animal_Locations__r[0];

        
        // Map<String, Date> dateMap = new Map<String, Date>();
        
        // if(config != null){
        //     dateMap = AutoScheduleTasksUtil.getDateMap(config);
        // } else {
        //     dateMap = AutoScheduleTasksUtil.getDateMap(treatment.Custom_Schedule__c);
        // }

        // for(String day : dateMap.keySet()){
        //     Task newTask = new Task(
        //         WhatId = treatment.Id,
        //         Animal__c = treatment.Animal__c,
        //         RecordTypeId = taskRTId,
        //         ActivityDate = dateMap.get(day),
        //         Description = 'Treatment is needed for: ' + treatment.Animal__r.Animal_Name_Id__c + ' (' + treatment.Animal__r.Current_Recent_Shelter_Location__c + ')',
        //         IsReminderSet = true,
        //         Status = 'Not Started',
        //         WhoId = treatment.Animal__r.Behavior_Case_Worker__c != null ? treatment.Animal__r.Behavior_Case_Worker__c : '0030100000IdslhAAB',
        //         Subject = 'Treatment'
        //         // ,Assigned_Resources__c = treatment.Animal__r.Animal_Name_Id__c + ';' + AutoScheduleTasksUtil.NO_RESOURCE_DEFAULT

        //     );
        //     newTasks.add(newTask);
        // }
        return newTasks;

    }
}
