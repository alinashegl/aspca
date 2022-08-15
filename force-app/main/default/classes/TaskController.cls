public class TaskController {
    
    public List<Task> tskList{get; set;}
    public List<Animal__c> animList {get;set;}
    public Task tsk{get;set;}
    public Animal__c anim{get;set;}
    public TaskController(ApexPages.StandardController controller){

    tskList= [SELECT Id, WhatId, Description, Subject, Medicine__c, Dosage__c, Frequency_Of_Treatment__c, Medication__r.Name	
            			 FROM Task 
                         WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        
        if (tskList.size() > 0)
        {
            tsk = tskList.get(0);
        	animList = [SELECT Name, Animal_Name__c, Shelter_Location__c FROM Animal__c WHERE Id =: tsk.WhatId];
    	}
    
        if (animList.size() > 0)
        {
             anim = animList.get(0);
            }
    }

}