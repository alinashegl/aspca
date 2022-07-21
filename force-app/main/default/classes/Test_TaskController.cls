@istest
public class Test_TaskController {
    
      static testMethod void TaskControllerTests() {

          Case newCaseObj = new case(Category__C = 'Consultation',Status = 'New',CASE_STATUS_SUBTYPE__c = 'Placement', Investigator__c = 'Terry Mills',Origin = 'Phone');
          insert newCaseObj;
          
          system.debug(newCaseObj);
          
          Animal__c newAnimal = new Animal__c(Name='12341A01', Case__c = newCaseObj.Id, Animal_Status__c='In Shelter', Type_of_Animal__c='Fowl', Color__c='Black', Gender__c = 'MI', Age__c='Egg', Intake_Date_Time__c=system.Today(), Intake_Type__c='Seized');
          insert newAnimal;
          
          system.debug(newAnimal);
          
          Task newTask = new Task(WhatId = newAnimal.Id, Description = 'Test', Subject = 'Test', Medicine__c = 'Test', Dosage__c = 'Test', Frequency_Of_Treatment__c = 'BID', ActivityDate = system.today());
          insert newTask;
          
          system.debug(newTask);
          
          Test.setCurrentPage(Page.Treatment_Labels);
          apexpages.currentpage().getparameters().put('Id' , newTask.id);
          ApexPages.StandardController stdController = new ApexPages.StandardController(newTask);
          TaskController ext = new TaskController(stdController);
          
      }
}