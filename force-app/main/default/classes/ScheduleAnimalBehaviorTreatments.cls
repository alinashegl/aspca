public with sharing class ScheduleAnimalBehaviorTreatments {
    public static Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.BEH_TREATMENT_TASK_RECORD_TYPE_NAME);
    
    //main method,called by AutoScheduleController class
    public static Task[] scheduleTreatments(Id[] animalIds) {
        Task[] treatmentTasks = new Task[0];

        //get a map of all the active Treatment Calendar_Schedule_Config__mdt records
        Map<String, Calendar_Schedule_Config__mdt> calendarConfigMap = AutoScheduleTasksUtil.getCalendarConfig('Treatment');
        
        //query the treatment plans that meet the criteria and loops through them preparing the tasks for each one
        for(Treatment_Plan__c treatment : queryTreatmentPlans(animalIds)){
            /*
            * The configKey is used to associate the animal with the correct Calendar_Schedule_Config__mdt record
            * it is created by concatenating the animal's location and the first work from the animal's Treatment_Priority__c
            * which should be low, medium, high or daily
            */
            String configKey = treatment.Animal__r.Current_Recent_Shelter_Location__c + '-' + treatment.Treatment_Priority__c.split(' ')[0];

            //if treatment plan has a custom schedule we need to follow that, otherwise use the default schedule from the config record
            if(treatment.Custom_Schedule__c != null){
                treatmentTasks.addAll(
                    prepTasks(treatment, null)
                );
            }
            else if(calendarConfigMap.containsKey(configKey)){
                treatmentTasks.addAll(
                    prepTasks(treatment, calendarConfigMap.get(configKey))
                );
            }
        }
        return treatmentTasks;
    }

    //queries and returns a list of Treatment_Plan__c's, will query for specific animals if the animalIds param is not null
    private static Treatment_Plan__c[] queryTreatmentPlans(Id[] animalIds){
        String[] dogPopulations = AutoScheduleTasksUtil.dogPopulations;
        String queryString = 'SELECT Id, Custom_Schedule__c, Treatment_Priority__c, Animal__c, ' +
            'Animal__r.Animal_Name_Id__c, Animal__r.Current_Recent_Shelter_Location__c, Animal__r.Current_Location__c, ' +
            'Animal__r.Behavior_Case_Worker__c, Animal__r.Behavior_Case_Worker__r.Name, Animal__r.Behavior_Case_Worker__r.Is_Generic_Contact__c, ' +
            'Animal__r.Behavior_Case_Worker__r.User__c ' +
            'FROM Treatment_Plan__c ' +
            'WHERE Animal__r.Current_Recent_Shelter_Location__c IN: dogPopulations ' +
            'AND IsActive__c = TRUE ' +
            'AND Treatment_Priority__c NOT IN (\'No Treatment\', \'\') ' +
            'AND Animal__r.Type_of_Animal__c = \'Dog\'';
        if(animalIds != null){
            queryString += ' AND Animal__c IN: animalIds';
        }

        return Database.query(queryString);
    }

    /*
    * determines the dates that need tasks based on the animal, Treatment_Plan__c and the Calendar_Schedule_Config__mdt record
    * loops through the dates and returns a list of tasks
    */
    private static Task[] prepTasks(Treatment_Plan__c treatment, Calendar_Schedule_Config__mdt config){
        //get the genericCon for the animal's location
        Contact genericCon = AutoScheduleTasksUtil.genericContactMap.get(treatment.Animal__r.Current_Recent_Shelter_Location__c);
        Task[] newTasks = new Task[0];

        /*
        * Determine which dates need tasks
        * If a Calendar_Schedule_Config__mdt was passed in, use it, otherwise use the custom schedule on the Treatment_Plan__c
        */
        Date[] dateList = new Date[0];
        if(config != null){
            dateList = AutoScheduleTasksUtil.getDateList(config);
        } else {
            dateList = AutoScheduleTasksUtil.getDateList(treatment.Custom_Schedule__c);
        }

        //loop through the dates and prep the tasks, adding them to the list of newTasks to return
        for(Date day : dateList){
            Task newTask = new Task(
                WhatId = treatment.Id,
                Animal__c = treatment.Animal__c,
                RecordTypeId = recordTypeId,
                ActivityDate = day,
                Description = 'Beh Treatment is needed for: ' + treatment.Animal__r.Animal_Name_Id__c + ' (' + treatment.Animal__r.Current_Recent_Shelter_Location__c + ')',
                IsReminderSet = true,
                Status = 'Not Started',
                WhoId = treatment.Animal__r.Behavior_Case_Worker__c != null ? treatment.Animal__r.Behavior_Case_Worker__c : genericCon.Id,
                OwnerId = genericCon == null ? null : genericCon.User__c,
                Subject = 'Treatment',
                Species__c = 'Dog',
                Auto_Scheduled_Task__c = true
            );
            newTasks.add(newTask);
        }
        return newTasks;
    }
}