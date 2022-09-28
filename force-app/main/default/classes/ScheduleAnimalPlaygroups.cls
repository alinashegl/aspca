public with sharing class ScheduleAnimalPlaygroups {
    public static Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.PLAYGROUP_TASK_RECORD_TYPE_NAME);
    
    //main method,called by AutoScheduleController class
    public static Task[] schedulePlaygroups(Id[] animalIds) {
        Task[] playgroupTasks = new Task[0];
        //get a map of all the active playgroup Calendar_Schedule_Config__mdt records
        Map<String, Calendar_Schedule_Config__mdt> calendarConfigMap = AutoScheduleTasksUtil.getCalendarConfig('Playgroup');

        //query the animals that meet the criteria and loops through them preparing the tasks for each one
        for(Animal__c animal : queryAnimals(animalIds)){
            /*
            * The configKey is used to associate the animal with the correct Calendar_Schedule_Config__mdt record
            * it is created by concatenating the animal's location and the first work from the animal's Playgroup_Priority_Level__c
            * which should be low, medium, high or daily
            */
            String configKey = animal.Current_Recent_Shelter_Location__c + '-' + animal.Playgroup_Priority_Level__c.split(' ')[0];
            if(calendarConfigMap.containsKey(configKey)){
                playgroupTasks.addAll(
                    prepTasks(animal, calendarConfigMap.get(configKey))
                );
            }
        }
        return playgroupTasks;
    }

    //queries and returns a list of animals, will query specific animals if the animalIds param is not null
    private static Animal__c[] queryAnimals(Id[] animalIds){
        String[] dogPopulations = AutoScheduleTasksUtil.dogPopulations;
        String queryString = 'SELECT Id, Playgroup_Priority_Level__c, Shelter_Location2__c, Animal_Name_Id__c, Current_Recent_Shelter_Location__c, Current_Location__c, ' +
            'Behavior_Case_Worker__r.Name, Behavior_Case_Worker__r.Is_Generic_Contact__c ' +
            'FROM Animal__c ' +
            'WHERE Playgroup_Priority_Level__c != null ' +
            'AND Current_Recent_Shelter_Location__c IN: dogPopulations ' +
            'AND Active_Animal__c = true ' +
            'AND Type_of_Animal__c = \'Dog\'';
        if(animalIds != null){
            queryString += ' AND Id IN: animalIds';
        }

        return Database.query(queryString);
    }

    /*
    * determines the dates that need tasks based on the animal and the Calendar_Schedule_Config__mdt record
    * loops through the dates and returns a list of tasks
    */
    private static Task[] prepTasks(Animal__c animal, Calendar_Schedule_Config__mdt config){
        //get the genericCon for the animal's location
        Contact genericCon = AutoScheduleTasksUtil.genericContactMap.get(animal.Current_Recent_Shelter_Location__c);
        Task[] newTasks = new Task[0];

        //determine which dates need tasks
        Date[] dateList = AutoScheduleTasksUtil.getDateList(config);

        //loop through the dates and prep the tasks, adding them to the list of newTasks to return
        for(Date day : dateList){
            Task newTask = new Task(
                WhatId = animal.Id,
                Animal__c = animal.Id,
                RecordTypeId = recordTypeId,
                ActivityDate = day,
                Description = 'Playgroup is needed for: ' + animal.Animal_Name_Id__c + ' (' + animal.Current_Recent_Shelter_Location__c + ')',
                IsReminderSet = true,
                Status = 'Not Started',
                WhoId = animal.Behavior_Case_Worker__c != null ? animal.Behavior_Case_Worker__c : genericCon.Id,
                OwnerId = genericCon == null ? null : genericCon.User__c,
                Subject = 'Playgroup',
                Species__c = 'Dog',
                Auto_Scheduled_Task__c = true
            );
            newTasks.add(newTask);
        }
        return newTasks;
    }
}