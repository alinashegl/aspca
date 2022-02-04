public with sharing class ScheduleAnimalFoster {
    public static Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.FOSTER_TASK_RECORD_TYPE_NAME);
    public static Task[] scheduleFollowUps(Id[] animalIds) {
        Task[] fosterTasks = new Task[0];
        Map<String, Calendar_Schedule_Config__mdt> calendarConfigMap = AutoScheduleTasksUtil.getCalendarConfig('Foster');
        Calendar_Schedule_Config__mdt defaultConfig = calendarConfigMap.get('Foster - All-Foster - Weekly');
        Animal__c[] animals = getAnimals(animalIds);
        Map<Id, Task> animalToTaskMap = getTasks(animals);
        for(Animal__c animal : animals){
            Task task = animalToTaskMap.containsKey(animal.Id) ? animalToTaskMap.get(animal.Id) : null;
            fosterTasks.addAll(prepTasks(animal, defaultConfig, task));
        }
        return fosterTasks;
    }

    public static Animal__c[] getAnimals(Id[] animalIds){
        String queryString = 'SELECT Id, Animal_Name_Id__c, Current_Recent_Shelter_Location__c, Current_Location__c, ' +
            'Behavior_Case_Worker__c, Behavior_Case_Worker__r.Name, Behavior_Case_Worker__r.Is_Generic_Contact__c, ' +
                '(SELECT Id, Follow_Up_Days__c, Follow_Up_Frequency__c, CreatedDate, Start_Date__c ' +
                'FROM Animal_Locations__r ' +
                'WHERE Facility_Outcome__c = \'Foster Home\' ' +
                'AND (End_Date__c = null OR End_Date__c >= TODAY) ' +
                'ORDER BY CreatedDate DESC ' +
                'LIMIT 1) ' +
            'FROM Animal__c ' +
            'WHERE Current_Location__c = \'Foster Home\' ' +
            'AND Type_of_Animal__c = \'Dog\' ' +
            'AND Id IN ' +
                '(SELECT Animal__c ' +
                'FROM Facility_Outcome__c ' +
                'WHERE Facility_Outcome__c = \'Foster Home\' ' +
                'AND (End_Date__c = null OR End_Date__c >= TODAY))';

        if(animalIds != null){
            queryString += ' AND Id IN: animalIds';
        }
                
        return Database.query(queryString);
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

    public static Date[] datesForTasks(Animal__c animal, Calendar_Schedule_Config__mdt config, Task task){
        Date startDateWeekStart = AutoScheduleTasksUtil.startOfASPCAWeek(AutoScheduleTasksUtil.startDate);
        Date endDateWeekStart = AutoScheduleTasksUtil.startOfASPCAWeek(AutoScheduleTasksUtil.endDate);
        Facility_Outcome__c location = animal.Animal_Locations__r[0];

        Date[] dateList = new Date[0];
        if(location.Follow_Up_Days__c == null){
            dateList = AutoScheduleTasksUtil.getDateList(config);
        } else {
            dateList = AutoScheduleTasksUtil.getDateList(location.Follow_Up_Days__c);
        }

        Date[] datesForTasks = new Date[0];
        if(location.Follow_Up_Frequency__c != null && location.Follow_Up_Frequency__c != 'Weekly'){
            Boolean createdTasksForCurrentWeek = false;
            Date activityDateWeekStart = task != null ? AutoScheduleTasksUtil.startOfASPCAWeek(task.ActivityDate) : location.Start_Date__c;

            if(activityDateWeekStart.daysBetween(startDateWeekStart) > AutoScheduleTasksUtil.translateFrequency(location.Follow_Up_Frequency__c)){
                for(Date d : dateList){
                    if(d > startDateWeekStart && d < startDateWeekStart.addDays(6)){
                        datesForTasks.add(d);
                        createdTasksForCurrentWeek = true;
                    }
                }
            }
            if(createdTasksForCurrentWeek == true){
                activityDateWeekStart = startDateWeekStart.addDays(7);
            }
            if(startDateWeekStart != endDateWeekStart && activityDateWeekStart.daysBetween(endDateWeekStart) > AutoScheduleTasksUtil.translateFrequency(location.Follow_Up_Frequency__c)){
                for(Date d : dateList){
                    if(d > endDateWeekStart && d < endDateWeekStart.addDays(6)){
                        datesForTasks.add(d);
                        createdTasksForCurrentWeek = true;
                    }
                }
            }
        } else {
            datesForTasks = dateList;
        }
        return datesForTasks;
    }

    public static Task[] prepTasks(Animal__c animal, Calendar_Schedule_Config__mdt config, Task task){
        Contact genericCon = AutoScheduleTasksUtil.genericContactMap.get(animal.Current_Recent_Shelter_Location__c);
        Task[] newTasks = new Task[0];
        Date[] dateList = datesForTasks(animal, config, task);
        
        Facility_Outcome__c location = animal.Animal_Locations__r[0];

        for(Date day : dateList){
            Task newTask = new Task(
                WhatId = location.Id,
                Animal__c = animal.Id,
                RecordTypeId = recordTypeId,
                ActivityDate = day,
                Description = 'Foster Follow Up for: ' + animal.Animal_Name_Id__c + ' (' + animal.Current_Recent_Shelter_Location__c + ')',
                IsReminderSet = true,
                Status = 'Not Started',
                WhoId = animal.Behavior_Case_Worker__c != null ? animal.Behavior_Case_Worker__c : genericCon.Id,
                OwnerId = genericCon.User__c,
                Subject = 'Foster Follow Up',
                Species__c = 'Dog',
                Auto_Scheduled_Task__c = true
            );
            newTasks.add(newTask);
        }
        return newTasks;
    }
}
