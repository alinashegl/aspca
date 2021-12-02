public with sharing class AutoScheduleController {
    public static void handleScheduleTasks(){
        scheduleAnimalPlaygroups();
    }

    private static void scheduleAnimalPlaygroups(){
        Task[] tasksToInsert = new Task[0];
        Map<String, Calendar_Schedule_Config__mdt> calendarConfigMap = getCalendarConfig('Playgroup');
        for(Animal__c animal : [
            SELECT Id, Playgroup_Priority_Level__c, Shelter_Location2__c, Animal_Name_Id__c, Current_Recent_Shelter_Location__c, Current_Location__c, Behavior_Case_Worker__r.Name
            FROM Animal__c 
            WHERE Playgroup_Priority_Level__c != null 
            AND Current_Recent_Shelter_Location__c IN ('MRC', 'CRC')
        ]){
            String configKey = animal.Current_Recent_Shelter_Location__c + '-' + animal.Playgroup_Priority_Level__c.split(' ')[0];
            if(calendarConfigMap.containsKey(configKey)){
                tasksToInsert.addAll(prepTasks(animal, calendarConfigMap.get(configKey), 'Playgroup'));
            }
        }
        insert tasksToInsert;
    }

    private static Map<String, Calendar_Schedule_Config__mdt> getCalendarConfig(String taskType){
        Map<String, Calendar_Schedule_Config__mdt> configMap = new Map<String, Calendar_Schedule_Config__mdt>();
        for(Calendar_Schedule_Config__mdt config : [
            SELECT Frequency__c, Population__c, Monday__c, Tuesday__c, Wednesday__c, Thursday__c, Friday__c, Saturday__c, Sunday__c
            FROM Calendar_Schedule_Config__mdt 
            WHERE Task_Type__c =: taskType 
            AND IsActive__c = true
        ]){
            configMap.put(config.Population__c + '-' + config.Frequency__c, config);
        }

        return configMap;
    }

    private static Task[] prepTasks(Animal__c animal, Calendar_Schedule_Config__mdt config, String taskType){
        Id taskRTId = [SELECT Id FROM RecordType WHERE SobjectType = 'Task' AND DeveloperName =: taskType LIMIT 1].Id;
        Task[] newTasks = new Task[0];
        Map<String, Date> dateMap = getDateMap(config);
        for(String day : dateMap.keySet()){
            Task newTask = new Task(
                WhatId = animal.Id,
                Animal__c = animal.Id,
                RecordTypeId = taskRTId,
                ActivityDate = dateMap.get(day),
                Description = 'Playgroup is needed for: ' + animal.Animal_Name_Id__c + ' (' + animal.Current_Recent_Shelter_Location__c + ')',
                IsReminderSet = true,
                Status = 'Not Started',
                WhoId = animal.Behavior_Case_Worker__c != null ? animal.Behavior_Case_Worker__c : '0030100000IdslhAAB',
                Subject = 'Playgroup',
                Assigned_Resources__c = animal.Animal_Name_Id__c + ';' + (animal.Behavior_Case_Worker__r.Name != null ? animal.Behavior_Case_Worker__r.Name : 'Dwight Schrute')

            );
            newTasks.add(newTask);
        }

        return newTasks;
    }

    private static Map<String, Date> getDateMap(Calendar_Schedule_Config__mdt config){
        Map<String, Date> dateMap = new Map<String, Date>();
        Date myDate = Date.today();
        Date weekStart = myDate.toStartofWeek().addDays(2);
        System.debug('weekStart = ' + weekStart);
        Map<String, Integer> dayOfWeekMap = dayOfWeekMap();
        for(String day : dayOfWeekMap.keySet()){
            if(config.get(day) == true){
                System.Debug('has Day: ' + day);
                System.Debug('date: ' + dayOfWeekMap.get(day));
                dateMap.put(day, weekStart.addDays(dayOfWeekMap.get(day)));
            }
        }
        return dateMap;
    }

    private static Map<String, Integer> dayOfWeekMap(){
        return new Map<String, Integer>{
            'Tuesday__c' => 0,
            'Wednesday__c' => 1,
            'Thursday__c' => 2,
            'Friday__c' => 3,
            'Saturday__c' => 4,
            'Sunday__c' => 5,
            'Monday__c' => 6
        };
    }
}
