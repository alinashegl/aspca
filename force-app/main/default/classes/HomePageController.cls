public with sharing class HomePageController {
	@AuraEnabled(cacheable=true)
    public static List<animalTaskRec> getAnmialTasks(Integer limitSize, Integer offset){
        List<Task> tasks = [SELECT Id,Record_Type__c, Animal__c,Animal__r.Animal_Name_Id__c, animal__r.Current_Location__c,subject   
                from Task where Animal__C != null AND Animal__r.Active_Animal__c  = true AND Animal__r.Location_Filter__c = true
                           and CreatedDate = today 
                      LIMIT :limitSize  OFFSET :offset  ];
        //LIMIT :limitSize  OFFSET :offset     and CreatedDate = today
        List<animalTaskRec> aTaskRecds = new List<animalTaskRec>();
        for(Task tsk : tasks){
            animalTaskRec atr = new animalTaskRec();
            atr.TaskId = tsk.Id;
            atr.recordType = tsk.Record_Type__c;
            atr.subject = tsk.subject;
            atr.Name= tsk.Animal__r.Animal_Name_Id__c;
            atr.location = tsk.animal__r.Current_Location__c;
            atr.taskUrl = '/lightning/r/Task/' + tsk.Id + '/view';
            aTaskRecds.add(atr);
        }
        return aTaskRecds;
    }

    
    @AuraEnabled(cacheable=true)
    public static List<animalTreatmentRec> getAnmialTreatement(){
        List<Treatment_Plan__c> treatmentPlans = [Select Id, Animal__r.Name, Animal__r.Animal_Name_Id__c, Animal__r.Shelter_Location__c,Treatment_Priority__c,(Select Id,Name, Protocol_Name__c,Protocol_Description__c from Plan_Protocols__r)  FROM Treatment_Plan__c
                WHERE IsActive__c = true AND Treatment_Priority__c != 'No Treatment' AND Animal__c != null];
       	List<animalTreatmentRec> aRecds = new List<animalTreatmentRec>();
        for(Treatment_Plan__c tp: treatmentPlans){
            animalTreatmentRec ar = new animalTreatmentRec();
            ar.TreatmentId = tp.Id;
            ar.Name = tp.Animal__r.Animal_Name_Id__c;
            ar.location = tp.Animal__r.Shelter_Location__c;
            ar.treatmentPriority = tp.Treatment_Priority__c;
            List<planProtocol> ptcRecds = new List<planProtocol>();
            for(Plan_Protocol__c pp: tp.Plan_Protocols__r){
                planProtocol ptc = new planProtocol();
                ptc.PlanId = pp.Id;
                ptc.ProtocolName = pp.Name ;
                ptc.Protocol = pp.Protocol_Name__c;
                ptcRecds.add(ptc);
            }
            ar.children = ptcRecds;
            aRecds.add(ar);
        }
        return aRecds;
    }
    
    public class animalTaskRec{
        @AuraEnabled
        public Id TaskId {get;set;}
        @AuraEnabled
        public String recordType {get;set;}
        @AuraEnabled
        public String taskUrl {get;set;}
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String location {get;set;}
        @AuraEnabled
        public String subject {get;set;}
    }
    
    public class animalTreatmentRec{

        @AuraEnabled
        public Id TreatmentId {get;set;}
        
        @AuraEnabled
        public String treatmentPriority {get;set;}
        
        @AuraEnabled
        public List<planProtocol> children {get;set;}
                
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String location {get;set;}
    }
    
    public class planProtocol{
        @AuraEnabled
        public Id PlanId {get;set;}
        @AuraEnabled
        public String ProtocolName {get;set;}
        @AuraEnabled
        public String Protocol {get;set;}
        
    }
}