/**
 * 
 * Class Description
 *
 * @author Neha
 * @version 1.0.0
 */

public with sharing class RollUpCountHandler extends DomainActionBase {
    public override void ProcessAction(TriggerRequest request) {
        if (request.targetSObject == Treatment_Session__c.SObjectType) {
            String triggerAction = request.action + request.process;

            switch on triggerAction {
                when 'BeforeInsert' { beforeInsert(request); }
                when 'BeforeUpdate' { beforeUpdate(request); }
                when 'BeforeDelete' { beforeDelete(request);}
                when 'AfterInsert' { afterInsert(request);}
                when 'AfterUpdate' { afterUpdate(request);}
                when 'AfterDelete' { afterDelete(request);}
            }
        } 
        return;
    }

    @SuppressWarnings('ApexUnresolvableReference')
    public void beforeInsert(TriggerRequest request) {
        System.debug('TREATMENT SESSION ROLLUP BEFORE INSERT IS EXECUTING');
    }


    public void beforeUpdate (TriggerRequest request)  {System.debug('TREATMENT SESSION ROLLUP BEFORE INSERT IS EXECUTING'); }
    public void beforeDelete (TriggerRequest request)  {System.debug('TREATMENT SESSION ROLLUP BEFORE INSERT IS EXECUTING'); }
    public void afterInsert (TriggerRequest request) {
        System.debug('TREATMENT SESSION ROLLUP AFTER INSERT IS EXECUTING');
               
        List<Treatment_Session__c> newRecords =  request.newRecords;
        set<id> animalsIds = new Set<id>();
        List<Animal__c> listOfAnimals = new List<Animal__c>();
        
        for(Treatment_Session__c ts: newRecords){
            if(ts.Animal__c!=null){
                animalsIds.add(ts.Animal__c);
            }
        }
        if(!animalsIds.isEmpty()){
            List<Animal__c> listAnimals = [Select id, Name, Days_in_Treatment__c,Final_Outcome_Date__c, Treatment_Start_Date__c, (Select id, CreatedDate from Treatment_Sessions__r Order by CreatedDate ASC) FROM Animal__c WHERE ID IN: animalsIds];
            for(Animal__c animal: listAnimals){
                if(animal.Treatment_Sessions__r.size()>0){
                    animal.Treatment_Start_Date__c = Date.newinstance(animal.Treatment_Sessions__r[0].CreatedDate.year(), animal.Treatment_Sessions__r[0].CreatedDate.month(), animal.Treatment_Sessions__r[0].CreatedDate.day());
                    animal.Days_in_Treatment__c=animal.Treatment_Sessions__r.size();
                    listOfAnimals.add(animal);
                }
            }
            if(listOfAnimals.size()>0){
                update listOfAnimals;
            }
        }

       
        
    }

    //@SuppressWarnings('ApexUnresolvableReference')
    public void afterUpdate(TriggerRequest request) { 
    	System.debug('TREATMENT SESSION ROLLUP BEFORE INSERT IS EXECUTING'); 
 		List<Treatment_Session__c> oldRecords =  request.oldRecords;
        set<id> animalsIds = new Set<id>();
        List<Animal__c> listOfAnimals = new List<Animal__c>();
        
        for(Treatment_Session__c ts: oldRecords){
            if(ts.Animal__c!=null){
                animalsIds.add(ts.Animal__c);
            }
        }
        if(!animalsIds.isEmpty()){
            List<Animal__c> listAnimals = [Select id, Name, Days_in_Treatment__c,Final_Outcome_Date__c, Treatment_Start_Date__c, (Select id, CreatedDate from Treatment_Sessions__r Order by CreatedDate ASC) FROM Animal__c WHERE ID IN: animalsIds];
            for(Animal__c animal: listAnimals){
                if(animal.Treatment_Sessions__r.size()>0){
                    animal.Treatment_Start_Date__c = Date.newinstance(animal.Treatment_Sessions__r[0].CreatedDate.year(), animal.Treatment_Sessions__r[0].CreatedDate.month(), animal.Treatment_Sessions__r[0].CreatedDate.day());
                    animal.Days_in_Treatment__c=animal.Treatment_Sessions__r.size();
                    listOfAnimals.add(animal);
                }
            }
            if(listOfAnimals.size()>0){
                update listOfAnimals;
			  }
        }

    }
    public void afterDelete (TriggerRequest request)  {
        System.debug('TREATMENT SESSION ROLLUP BEFORE INSERT IS EXECUTING');
        List<Treatment_Session__c> newRecords =  request.newRecords;
        List<Treatment_Session__c> oldRecords =  request.oldRecords;
        set<id> animalsIds = new Set<id>();
        List<Animal__c> listOfAnimals = new List<Animal__c>();
        
        for(Treatment_Session__c ts: oldRecords){
            if(ts.Animal__c!=null){
                animalsIds.add(ts.Animal__c);
            }
           if(!animalsIds.isEmpty()){
            List<Animal__c> listAnimals = [Select id, Name, Days_in_Treatment__c, (Select id from Treatment_Sessions__r) FROM Animal__c WHERE ID IN: animalsIds];
            for(Animal__c animal: listAnimals){
                if(animal.Treatment_Sessions__r.size()>0){
                    Animal__c obj = new Animal__c();
                    obj.id=animal.id;
                    obj.Days_in_Treatment__c=animal.Treatment_Sessions__r.size();
                    listOfAnimals.add(obj);
                }
            }
            if(listOfAnimals.size()>0){
                update listOfAnimals;
			  }
        }
        }                                   
                                                      
                                                      
                                                      
                                                      
                                                      }

}