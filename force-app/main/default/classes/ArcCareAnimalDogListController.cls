public class ArcCareAnimalDogListController {
    @AuraEnabled
    public static List<Animal__c> getRecords() {
        List<Animal__c> objs = [Select Id, Name, Animal_Name__c, Animal_Name_Id__c, Petpoint_ID__c,AAH_ID__c, Gender__c, Evaluation_Status__c, Current_Location__c, 
                Hold_Status_ARC_CARE__c, Behavior_Case_Worker__c, Behavior_Case_Worker__r.Name, Walking_Status__c,Type_of_Animal__c, 
                Walking_Notes__c, PPE_DOH__c, Important_Notes_ARC_CARE__c FROM Animal__c 
                WHERE Active_Animal__c = true AND Location_Filter__c = true AND Type_of_Animal__c = 'Dog'
                ORDER BY CreatedDate ];
        
        List<Animal__c> objList = new List<Animal__c>();
        for(Animal__c obj : objs){
            if(obj.Current_Location__c != null && (obj.Current_Location__c.equalsIgnoreCase('ARC') || 
              obj.Current_Location__c.equalsIgnoreCase('CARE') || obj.Current_Location__c.equalsIgnoreCase('AAH') ||
              obj.Current_Location__c.equalsIgnoreCase('Foster Home') || obj.Current_Location__c.equalsIgnoreCase('Partner Hospital'))){
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
    public static List<Option> getPicklistValue(String objectname, String fieldname){
        SObjectType sObjType = ((SObject) Type.forName(objectname).newInstance()).getSObjectType();
        Schema.DescribeSObjectResult objSchema = sObjType.getDescribe();
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
    public static List<option> getAnimalGender(){
        Map<String, List<String>> result = getGlobalPickList('Animal__c', 'Type_of_Animal__c', 'Gender__c' );
        List<Option> options = new List<Option>();
        for(String pick: result.get('Dog')){
            Option op = new Option();
            op.label = op.value = pick;
            options.add(op);
        }
        return options;
    }
    
    public static Map<String, List<String>> getGlobalPickList(String objectName, String controllingField, String dependentField )  {
        Map<String, List<String>> controllingInfo = new Map<String, List<String>>() ;
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult  describeResult = objType.getDescribe ();
        Schema.DescribeFieldResult  controllingFieldInfo = describeResult.fields.getMap().get(controllingField).getDescribe() ;
        Schema.DescribeFieldResult  dependentFieldInfo = describeResult.fields.getMap().get(dependentField).getDescribe() ;
        List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
        List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();
        for (Schema.PicklistEntry currControllingValue  :  controllingValues)  {
            controllingInfo.put (currControllingValue.getLabel() , new List<String>( ) ) ;
        }
        
        for  (Schema.PicklistEntry  currDependentValue  :  dependentValues)  {
            String  jsonString  =  JSON.serialize(currDependentValue) ;
            MyPickListInfo  info  =  (MyPickListInfo)  JSON.deserialize(jsonString, MyPickListInfo.class);
            String hexString  =  EncodingUtil.convertToHex (EncodingUtil.base64Decode (info.validFor)).toUpperCase ( ) ;
            Integer  baseCount  =  0;
            for (Integer curr  :  hexString.getChars ( ) )  {
                Integer  val  =  0;
                if  (curr  >=  65) {
                    val  =  curr  -  65  +  10;
                }  else  {
                    val  =  curr  -  48;
                }
                if  ((val & 8)  ==  8)  {
                    controllingInfo.get (controllingValues[baseCount  +  0].getLabel( ) ).add (currDependentValue.getLabel( ) ) ;
                }
                if  ((val & 4)  ==  4)  {
                    controllingInfo.get (controllingValues[baseCount  +  1].getLabel( ) ).add (currDependentValue.getLabel( ) ) ;
                }
                if  ((val & 2)  ==  2)  {
                    controllingInfo.get (controllingValues[baseCount  +  2].getLabel( ) ).add (currDependentValue.getLabel( ) ) ;
                }
                
                if  ((val & 1)  ==  1)  {
                    controllingInfo.get (controllingValues[baseCount  +  3].getLabel( ) ).add (currDependentValue.getLabel( ) ) ;
                }
                baseCount  +=  4;
            }   
        }
        return controllingInfo;
    }
    
    public class MyPickListInfo {
        public String validFor;
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