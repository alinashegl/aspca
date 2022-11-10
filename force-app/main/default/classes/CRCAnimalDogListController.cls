public class CRCAnimalDogListController {
	@AuraEnabled
    public static CRCDogListResult getRecords(String locationsFilter) {
        system.debug(locationsFilter);
        AnimalLocationFilterUtil filterInfo = new AnimalLocationFilterUtil(locationsFilter);
        String query =  'SELECT Id, Shelter_Color_Coding__c, Behavior_Summary_Change_Date__c,'+
                                'Name, Animal_Name__c, Animal_Name_Id__c,Meets_Adoptability_Date__c,'+
                                'Playgroup_Priority_Level__c, Current_Location__c,Type_of_Animal__c,'+
                                'Behavior_Case_Worker__c, Behavior_Case_Worker__r.Name,'+
                                '(Select Id, Animal__c, Treatment_Priority__c, Enrichment_Priority__c FROM Treatment_Plan__r where IsActive__c = true)'+
                                'from Animal__c where Active_Animal__c = true AND Location_Filter__c = true AND Type_of_Animal__c = \'Dog\'';
        
        if(filterInfo.useFilter == true){
            String[] locationsList = filterInfo.locationList;
            query += ' AND Current_Location__c IN :locationsList ';
        }
        
        List<Animal__c> objs = Database.query(query);
        
        List<Animal__c> objList = new List<Animal__c>();
        if(filterInfo.useFilter == false){
            for(Animal__c obj : objs){
                if((String.isNotBlank(obj.Current_Location__c)) && 
                (obj.Current_Location__c.equalsIgnoreCase('CRC - CRC') ||obj.Current_Location__c.equalsIgnoreCase('CRC-MRC') || 
                obj.Current_Location__c.equalsIgnoreCase('CRC- MRC') || obj.Current_Location__c.equalsIgnoreCase('CRC') || 
                obj.Current_Location__c.equalsIgnoreCase('Field Temp Shelter'))){
                    objList.add(obj);
                }
            }
        } else {
            objList = objs;
        }
        
        
        /*List<Animal__c> objs = Database.query(query);

        List<Animal__c> objList = new List<Animal__c>();
        if(String.isBlank(searchKey)){
            for(Animal__c obj : objs){
                if((String.isNotBlank(obj.Current_Location__c)) && 
                (obj.Current_Location__c.equalsIgnoreCase('CRC - CRC') ||obj.Current_Location__c.equalsIgnoreCase('CRC-MRC') || 
                obj.Current_Location__c.equalsIgnoreCase('CRC- MRC') || obj.Current_Location__c.equalsIgnoreCase('CRC'))){
                    objList.add(obj);
                }
            }
        } else {
            objList = objs;
        }
        
        System.debug('objList:'+objList.size());
        
        Set<Id> animalSet = new Set<Id>();

        for(Animal__c an : objList){
            animalSet.add(an.Id);
        }*/
        
        List<Play_Pause__c> playPauses = [Select Animal__c, Play_Pause_Reason__c from Play_Pause__c where Animal__c in : objList AND End_Play_Pause__c != true]; 
		Map<Id, Set<String>> playPauseReasonByAnimal = new Map<Id, Set<String>>();
        for(Play_Pause__c pp : playPauses){
            if(!playPauseReasonByAnimal.containsKey(pp.Animal__c)){
                playPauseReasonByAnimal.put(pp.Animal__c, new Set<String>{pp.Play_Pause_Reason__c}); 
            } else {
                playPauseReasonByAnimal.get(pp.Animal__c).add(pp.Play_Pause_Reason__c); 
            }
        }
        CRCDogListResult result = new CRCDogListResult();
        result.animals = objList;
        system.debug(playPauseReasonByAnimal);
        result.playPauseReasons = convertToMapList(playPauseReasonByAnimal);
        system.debug(result.playPauseReasons);
        return result;
    }
    
    @AuraEnabled
    public static String saveRecords(String recsString) {
        System.debug(recsString);
        List<Animal__c> animals = (List<Animal__c>) JSON.deserialize(recsString, List<Animal__c>.class);
        List<Treatment_Plan__c> treatmentPlanList = new List<Treatment_Plan__c>();
        Map<Id, Id> animalBehCaseWorkerMap = new Map<Id, Id>();
        for(Animal__c anm: animals){
            system.debug(anm.Treatment_Plan__r); 
            if(anm.Treatment_Plan__r.size() > 0){ 
                treatmentPlanList.add(anm.Treatment_Plan__r);
            }
            if(anm.Behavior_Case_Worker__c != null){
                animalBehCaseWorkerMap.put(anm.Id, anm.Behavior_Case_Worker__c);
            }
        }

        List<BehaviorCaseWorker__c> behCaseWorkers =  [SELECT Id, Animal__c, CaseWorker__c, EndDate__c, StartDate__c FROM BehaviorCaseWorker__c where Animal__c IN : animalBehCaseWorkerMap.keySet()];
        Map<Id, Set<Id>> behAnmMap = new Map<Id, Set<Id>>();
        for(BehaviorCaseWorker__c b : behCaseWorkers){
            if(behAnmMap.containsKey(b.Animal__c)){
                behAnmMap.get(b.Animal__c).add(b.CaseWorker__c);
            }
            else {
                behAnmMap.put(b.Animal__c, new Set<Id>{b.CaseWorker__c});
            }
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
        
        update treatmentPlanList;
        update animals;
        return 'success';
    }
    
    public class CRCDogListResult {
        @AuraEnabled
        public List<Animal__c> animals;
        @AuraEnabled
        public Map<Id, List<String>> playPauseReasons;
        
    }
    
    static Map<Id, List<String>> convertToMapList(Map<Id, Set<String>> source) {
        Map<Id, List<String>> result = new Map<Id, List<String>>();
        for(Id key: source.keySet()) {
            result.put(key, new List<String>(source.get(key)));
        }
        return result;
    }
}