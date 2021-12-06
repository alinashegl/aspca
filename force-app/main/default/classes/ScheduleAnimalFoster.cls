public with sharing class ScheduleAnimalFoster {
    public static Task[] scheeduleFollowUps() {
        Task[] fosterTasks = new Task[0];
        Map<String, Calendar_Schedule_Config__mdt> calendarConfigMap = AutoScheduleTasksUtil.getCalendarConfig('Foster');
        Calendar_Schedule_Config__mdt defaultConfig = calendarConfigMap.get('Foster - All-Foster - Weekly');
        for(Animal__c animal : getAnimals()){
            if(needTasksThisWeek(animal)){
                fosterTasks.addAll(prepTasks(animal, defaultConfig));
            }
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
            ),
            (
                SELECT Id, ActivityDate
                FROM Tasks
                WHERE Subject = 'Foster Follow Up'
                ORDER BY ActivityDate DESC
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

    public static Boolean needTasksThisWeek(Animal__c animal){
        Boolean needsTasks = true;
        Facility_Outcome__c location = animal.Animal_Locations__r[0];
        if(location.Follow_Up_Frequency__c != null && location.Follow_Up_Frequency__c != 'Weekly' && !animal.Tasks.isEmpty()){
            
            if(Date.today().daysBetween(animal.Tasks[0].ActivityDate)> translateFrequency(location.Follow_Up_Frequency__c)){
                needsTasks = true;
            }
        }
        return true;
    }

    public static Integer translateFrequency(String frequency){
        if(frequency == 'Every Other Week'){
            return 7;
        }
        else {
            return 14;
        }
    }

    public static Task[] prepTasks(Animal__c animal, Calendar_Schedule_Config__mdt config){
        Id taskRTId = [SELECT Id FROM RecordType WHERE SobjectType = 'Task' AND DeveloperName =: AutoScheduleTasksUtil.FOSTER_TASK_RECORD_TYPE_NAME LIMIT 1].Id;
        Task[] newTasks = new Task[0];
        Map<String, Date> dateMap = new Map<String, Date>();

        Facility_Outcome__c location = animal.Animal_Locations__r[0];

        if(location.Follow_Up_Days__c == null){
            dateMap = AutoScheduleTasksUtil.getDateMap(config);
        } else {
            dateMap = AutoScheduleTasksUtil.getDateMap(location.Follow_Up_Days__c);
        }

        for(String day : dateMap.keySet()){
            Task newTask = new Task(
                WhatId = location.Id,
                Animal__c = animal.Id,
                RecordTypeId = taskRTId,
                ActivityDate = dateMap.get(day),
                Description = 'Foster Follow Up for: ' + animal.Animal_Name_Id__c + ' (' + animal.Current_Recent_Shelter_Location__c + ')',
                IsReminderSet = true,
                Status = 'Not Started',
                WhoId = animal.Behavior_Case_Worker__c != null ? animal.Behavior_Case_Worker__c : '0030100000IdslhAAB',
                Subject = 'Foster Follow Up'
                // ,Assigned_Resources__c = treatment.Animal__r.Animal_Name_Id__c + ';' + AutoScheduleTasksUtil.NO_RESOURCE_DEFAULT
            );
            newTasks.add(newTask);
        }
        return newTasks;

    }
}
