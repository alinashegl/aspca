public with sharing class ScheduleAnimalBRCMRC {
    public static Id recordTypeId = Util.getRecordTypeId('Task','MRC_BRC_Follow_UP');
    public static Task[] scheduleBRCMRCTasks(){
        Task[] brcmrcTasks = new Task[0];
        List<Animal__c> animalList = getAnimals();
        Map<Id, Date> followupDateByAnimal = getFollowupDate(animalList);
        for(Animal__c animal : animalList){
            Date acceptedDate = System.today(); // change this to animal.acceptedDate
            Date followupDate = followupDateByAnimal.containsKey(animal.Id) ? followupDateByAnimal.get(animal.Id): acceptedDate;
            brcmrcTasks.add(prepTask(animal, followUpDate));
        }
        return brcmrcTasks;
    }
    
    public static void completeBRCMRCTasks(){
        List<Task> taskList = new List<Task>();
        List<Animal__c> animals = getAnimalsForTaskUpdate();
        List<Task> tasks = [Select Id, Status from Task where recordTypeId =:recordTypeId and WhatId IN : animals];
        for(Task t : tasks){
            t.status = 'Completed';
            taskList.add(t);
        }
        update taskList;
    }
    
    private static Task prepTask(Animal__c animal, Date taskDate){
        Contact genericCon = AutoScheduleTasksUtil.genericContactMap.get(animal.Current_Recent_Shelter_Location__c);
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
            ActivityDate = taskDate,
            Description = subjectPrefix + ' Accepted follow up for: ' + animal.Animal_Name_Id__c,
            IsReminderSet = false,
            Status = 'Not Started',
            WhoId = animal.Behavior_Case_Worker__c != null ? animal.Behavior_Case_Worker__c : genericCon.Id,
            Subject = subjectPrefix+' Accepted follow up for: ' + animal.Animal_Name_Id__c,
            //Assigned_Resources__c = animal.Behavior_Case_Worker__r.Is_Generic_Contact__c == false ? animal.Behavior_Case_Worker__r.Name : null,
            Species__c = 'Dog'
        );
        system.debug(animal.id+'-'+newTask);
		return newTask;
    }

    // once the date field is created that needs to be added in the query and that will be considered as reminder startdate
    private static Animal__c[] getAnimals(){
        Date tempEndDate = Date.today().addDays(-7);
        return [SELECT Id, BRC_Status__c, MRC_Status__c, Animal_Name_Id__c, Current_Recent_Shelter_Location__c,
                Behavior_Case_Worker__c, Behavior_Case_Worker__r.Is_Generic_Contact__c,
                Behavior_Case_Worker__r.Name from Animal__c 
                WHERE (BRC_Status__c = 'BRC Accepted' OR MRC_Status__c = 'MRC Accepted')and (Current_Recent_Shelter_Location__c != 'BRC' AND Current_Recent_Shelter_Location__c != 'MRC')];
    }
    
    public static Map<Id, Date> getFollowupDate(List<Animal__c> animals){
        Map<Id, Date> dateMap = new Map<Id, Date>();
        for(Task t : [Select Id, WhatId, ActivityDate from Task where recordTypeId =:recordTypeId and WhatId IN : animals Order By ActivityDate DESC]){
            if(!dateMap.containsKey(t.WhatId)){
                dateMap.put(t.WhatId, DateTimeUtility.AddBusinessDays(t.ActivityDate, 10));
            }
        }
        return dateMap;
    }
    
    public static List<Animal__c> getAnimalsForTaskUpdate(){
        return [SELECT Id, BRC_Status__c, MRC_Status__c from Animal__c 
                WHERE (BRC_Status__c = 'BRC Declined' OR MRC_Status__c = 'MRC Declined')];
    }
}