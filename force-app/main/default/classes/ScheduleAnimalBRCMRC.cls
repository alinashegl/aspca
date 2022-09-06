public with sharing class ScheduleAnimalBRCMRC {
    public static Id recordTypeId = Util.getRecordTypeId('Task','MRC_BRC_Follow_UP');

    //main method,called by AutoScheduleController class
    public static Task[] scheduleBRCMRCTasks(Id[] animalIds){
        Task[] brcmrcTasks = new Task[0];

        //query the animals that meet the criteria and loops through them preparing the tasks for each one
        List<Animal__c> animalList = getAnimals(animalIds);
        for(Animal__c animal : animalList){
            //first determine what date would need a follow up task, if no follow up date, skip this animal
            Date followUpDate = calculateFollowUpDate(animal);
            if(followUpDate != null){
                brcmrcTasks.add(
                    prepTask(animal, followUpDate, true)
                );
            }
        }
        return brcmrcTasks;
    }
    
    public static void completeBRCMRCTasks(){
        List<Task> taskList = new List<Task>();
        List<Animal__c> animals = getAnimalsForTaskUpdate();
        //get the current user's infor in case t.Owner.Name is null
        String userName = UserInfo.getName();
        List<Task> tasks = [Select Id, Status,Owner.Name from Task where recordTypeId =:recordTypeId and WhatId IN : animals];
        
        for(Task t : tasks){
            t.status = 'Completed';
            t.Completed_By_Text__c = t.Owner.Name != null ? t.Owner.Name : userName;
            t.Completed_By__c = 'Auto-completion Based on Discharge';
            taskList.add(t);
        }
        update taskList;
    }
    
    /*
    * prepares and returns the new task
    */
    public static Task prepTask(Animal__c animal, Date taskDate, Boolean isAutoScheduled){
        //get the genericCon for the animal's location
        Contact genericCon = AutoScheduleTasksUtil.genericContactMap.get(animal.Current_Recent_Shelter_Location__c);

        //determine the task subject prefix
        String subjectPrefix = 'MRC';
        if(animal.BRC_Status__c == 'BRC Accepted' && animal.MRC_Status__c == 'MRC Accepted'){
            subjectPrefix = 'MRC/BRC';
        } else if(animal.BRC_Status__c == 'BRC Accepted'){
            subjectPrefix = 'BRC';
        }
        Task newTask = new Task(
            WhatId = animal.Id,
            Animal__c = animal.Id,
            RecordTypeId = recordTypeId,
            Record_Type__c = AutoScheduleTasksUtil.MRC_BRC_FOLLOW_UP_TASK_RECORD_TYPE_NAME,
            ActivityDate = taskDate,
            Description = subjectPrefix + ' Accepted follow up for: ' + animal.Animal_Name_Id__c,
            IsReminderSet = false,
            Status = 'Not Started',
            WhoId = animal.Behavior_Case_Worker__c != null ? animal.Behavior_Case_Worker__c : (genericCon != null ? genericCon.Id : null),
            Subject = subjectPrefix+' Accepted follow up for: ' + animal.Animal_Name_Id__c,
            Species__c = 'Dog',
            Auto_Scheduled_Task__c = isAutoScheduled
        );
        system.debug(animal.id+'-'+newTask);
		return newTask;
    }

    // once the date field is created that needs to be added in the query and that will be considered as reminder startdate
    private static Animal__c[] getAnimals(Id[] animalIds){
        Date tempEndDate = Date.today().addDays(-7);
        String recordTypeName = AutoScheduleTasksUtil.MRC_BRC_FOLLOW_UP_TASK_RECORD_TYPE_NAME;
        String queryString = 'SELECT Id, BRC_Status__c, MRC_Status__c, Animal_Name_Id__c, Current_Recent_Shelter_Location__c, ' +
            'Behavior_Case_Worker__c, Behavior_Case_Worker__r.Is_Generic_Contact__c, ' +
            'Behavior_Case_Worker__r.Name, ' +
            '(SELECT Id, ActivityDate FROM Activities__r WHERE Record_Type__c =: recordTypeName AND ActivityDate != null ORDER BY ActivityDate DESC LIMIT 1) ' +
            'FROM Animal__c ' +
            'WHERE (BRC_Status__c = \'BRC Accepted\' OR MRC_Status__c = \'MRC Accepted\')and (Current_Recent_Shelter_Location__c != \'BRC\' AND Current_Recent_Shelter_Location__c != \'MRC\')' + 
            'AND Active_Animal__c = true';

        if(animalIds != null){
            queryString += ' AND Id IN: animalIds';
        }

        return Database.query(queryString);
    }

    //returns a date that is 14 days after the last activityDate if it falls between startDate and endDate
    private static Date calculateFollowUpDate(Animal__c animal){
        Date followUpDate = null;
        if(!animal.Activities__r.isEmpty()){
            Date tempActivityDate = animal.Activities__r[0].ActivityDate.addDays(14);
            if(tempActivityDate >= AutoScheduleTasksUtil.startDate && tempActivityDate <= AutoScheduleTasksUtil.endDate){
                followUpDate = tempActivityDate;
            }
        }   
        else {
            followUpDate = date.today();
        }
        return followUpDate;
    }
    
    public static List<Animal__c> getAnimalsForTaskUpdate(){
        return [SELECT Id, BRC_Status__c, MRC_Status__c from Animal__c 
                WHERE (BRC_Status__c = 'BRC Declined' OR MRC_Status__c = 'MRC Declined')
                AND Active_Animal__c = true
                ];
    }
}