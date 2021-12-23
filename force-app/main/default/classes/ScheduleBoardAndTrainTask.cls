public with sharing class ScheduleBoardAndTrainTask {
    public static Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.BOARD_AND_TRAIN_RECORD_TYPE_NAME);
    public static Task[] scheduleFollowUps() {
        Task[] bntTasks = new Task[0];
        Map<String, Calendar_Schedule_Config__mdt> calendarConfigMap = AutoScheduleTasksUtil.getCalendarConfig('Board And Train');
        Calendar_Schedule_Config__mdt defaultConfig = calendarConfigMap.get('Board And Train All-Weekly');
        Animal__c[] animals = getAnimals();
        Map<Id, Task> animalToTaskMap = getTasks(animals);
        for(Animal__c animal : animals){
            if(needTasksThisWeek(animal, animalToTaskMap)){
                bntTasks.addAll(prepTasks(animal, defaultConfig));
            }
        }
        return bntTasks;
    }

    public static Animal__c[] getAnimals(){
        return [
            SELECT Id, Animal_Name_Id__c, Current_Recent_Shelter_Location__c, Current_Location__c, 
            Behavior_Case_Worker__c, Behavior_Case_Worker__r.Name, Behavior_Case_Worker__r.Is_Generic_Contact__c,
            (
                SELECT Id, Follow_Up_Days__c, Follow_Up_Frequency__c, CreatedDate
                FROM Animal_Locations__r
                WHERE Facility_Outcome__c = 'Board and Train'
                AND (End_Date__c = null OR End_Date__c >= TODAY)
                ORDER BY CreatedDate DESC
                LIMIT 1
            )
            FROM Animal__c
            WHERE Current_Location__c = 'Board and Train'
            AND Type_of_Animal__c = 'Dog'
            AND Id IN
            (
                SELECT Animal__c
                FROM Facility_Outcome__c
                WHERE Facility_Outcome__c = 'Board and Train'
                AND (End_Date__c = null OR End_Date__c >= TODAY)
            )
        ];
    }

    public static Map<Id,Task> getTasks(Animal__c[] animals){
        Map<Id,Task> taskMap = new Map<Id,Task>();
        Set<Id> animalIds = new Set<Id>();
        for(Animal__c anim : animals){
            animalIds.add(anim.Id);
        }

        for(Task t : [SELECT Id, ActivityDate, Animal__c FROM Task WHERE RecordTypeId =: recordTypeId AND Animal__c IN: animalIds ORDER BY ActivityDate DESC]){
            if(!taskMap.containsKey(t.Animal__c)){
                taskMap.put(t.Animal__c, t);
            }
        }

        return taskMap;
    }

    public static Boolean needTasksThisWeek(Animal__c animal, Map<Id, Task> taskMap){
        Boolean needsTasks = true;
        Facility_Outcome__c location = animal.Animal_Locations__r[0];
        if(location.Follow_Up_Frequency__c != null && location.Follow_Up_Frequency__c != 'Weekly' && taskMap.containsKey(animal.Id)){
            Task t = taskMap.get(animal.Id);
            if(t.ActivityDate.daysBetween(Date.Today()) < translateFrequency(location.Follow_Up_Frequency__c)){
                needsTasks = false;
            }
        }
        return needsTasks;
    }

    public static Integer translateFrequency(String frequency){
        Integer minDays = 0;
        switch on frequency {
            when 'Every Other Week' {
                minDays = 7;
            }	
            when 'Every Three Weeks' {
                minDays = 14;
            }
            when 'Monthly' {
                minDays = 23;
            }
            when 'Every Other Month' {
                minDays = 54;
            }
        }
        return minDays;
    }

    public static Task[] prepTasks(Animal__c animal, Calendar_Schedule_Config__mdt config){
        Contact genericCon = AutoScheduleTasksUtil.genericContactMap.get(animal.Current_Recent_Shelter_Location__c);
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
                RecordTypeId = recordTypeId,
                ActivityDate = dateMap.get(day),
                Description = 'Board and Train Follow Up for: ' + animal.Animal_Name_Id__c + ' (' + animal.Current_Recent_Shelter_Location__c + ')',
                IsReminderSet = true,
                Status = 'Not Started',
                WhoId = animal.Behavior_Case_Worker__c != null ? animal.Behavior_Case_Worker__c : genericCon.Id,
                OwnerId = genericCon.User__c,
                Subject = 'Board and Train Follow Up',
                Assigned_Resources__c = determineResources(animal),
                Species__c = 'Dog'
            );
            newTasks.add(newTask);
        }
        return newTasks;
    }

    private static String determineResources(Animal__c animal){
        String[] resourceList = new String[0];
        if(animal.Animal_Name_Id__c != null){
            resourceList.add(animal.Animal_Name_Id__c);
        }
        resourceList.add(animal.Behavior_Case_Worker__r.Is_Generic_Contact__c == false ? animal.Behavior_Case_Worker__r.Name : AutoScheduleTasksUtil.NO_CONTACT_RESOURCE);
        return string.join(resourceList, ';');
    }    
}
