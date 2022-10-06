public class ArcCareAnimalDogListController {
    @AuraEnabled
    public static List<Animal__c> getRecords() {
        List<Animal__c> objs = [Select Id, Name, Animal_Name__c, Animal_Name_Id__c, Petpoint_ID__c,AAH_ID__c, Gender__c, Evaluation_Status__c, Current_Location__c, 
                Hold_Status_ARC_CARE__c, Behavior_Case_Worker__c, Behavior_Case_Worker__r.Name, Walking_Status__c, 
                Walking_Notes__c, PPE_DOH__c, Important_Notes_ARC_CARE__c FROM Animal__c 
                WHERE Active_Animal__c = true AND Location_Filter__c = true
                ORDER BY CreatedDate ];
        
        List<Animal__c> objList = new List<Animal__c>();
        for(Animal__c obj : objs){
            if(obj.Current_Location__c != null && (obj.Current_Location__c.equalsIgnoreCase('ARC') || 
              obj.Current_Location__c.equalsIgnoreCase('CARE'))){
                objList.add(obj);
            }
        }
        return objList;
    }
    
    @AuraEnabled
    public static List<Option> getPicklistValue(String fieldname){
        Schema.DescribeSObjectResult objSchema = Animal__c.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = objSchema.fields.getmap();
        List<Schema.Picklistentry>fld =fieldmap.get(fieldname).getDescribe().getpicklistValues();
        List<Option> optionList = new List<Option>();
        for(Schema.Picklistentry pl : fld){
            Option op = new Option();
            op.value = pl.getValue();
            op.label = pl.getValue();
            optionList.add(op);
        }
        return optionList;
    }
    
    @AuraEnabled
    public static String saveRecords(String recsString) {
        System.debug(recsString);
        List<Animal__c> recs2Save = (List<Animal__c>) JSON.deserialize(recsString, List<Animal__c>.class);
        update recs2Save;

        Map<Id, Id> animalBehCaseWorkerMap = new Map<Id, Id>();
        for(Animal__c anm : recs2Save){
            if(anm.Behavior_Case_Worker__c != null){
                animalBehCaseWorkerMap.put(anm.Id, anm.Behavior_Case_Worker__c);
            }
        }

        List<BehaviorCaseWorker__c> behCaseWorkers =  [SELECT Id, Animal__c, CaseWorker__c, EndDate__c, StartDate__c FROM BehaviorCaseWorker__c where Animal__c IN : animalBehCaseWorkerMap.keySet()];
        Map<Id, Set<Id>> behAnmMap = new Map<Id, Set<Id>>();
        set<Id> caseWorkers = new Set<Id>();
        for(BehaviorCaseWorker__c b : behCaseWorkers){
            caseWorkers.add(b.CaseWorker__c);
            behAnmMap.put(b.Animal__c, caseWorkers);
        }
        List<BehaviorCaseWorker__c> newCaseWorkers = new List<BehaviorCaseWorker__c>();
        for(Id anmId : animalBehCaseWorkerMap.keySet()){
            if(!behAnmMap.containsKey(anmId) || (behAnmMap.containsKey(anmId) && !(behAnmMap.get(anmId).contains(animalBehCaseWorkerMap.get(anmId))))){
                BehaviorCaseWorker__c bcw = new BehaviorCaseWorker__c();
                bcw.Animal__c = anmId;
                bcw.StartDate__c = System.today();
                bcw.CaseWorker__c = animalBehCaseWorkerMap.get(anmId);
                newCaseWorkers.add(bcw);
            }
        }

        if(!newCaseWorkers.isEmpty()){
            insert newCaseWorkers;
        }

        return 'success';
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getBehCaseWorkers() {
        return [SELECT Id, Name FROM Contact WHERE Contact_Type__c = 'Behavior Case Worker'];
    }
    
    public class option{
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String label;
    }
}