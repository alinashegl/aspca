public class DailyCarePDFController {
    public String dailyCareId {get; set;}
    //public static Map<string,string> enrichmentByAnimal {get; set;}
    public static Map<string,string> restDayByAnimal {get; set;}
    
    public DailyCarePDFController(){
        this.dailyCareId = ApexPages.currentPage().getParameters().get('dailyCareId');
        //enrichmentByAnimal = new Map<string,string>();
        restDayByAnimal = new Map<string,string>();
    }
    
    public Daily_Care__c dailyCare {
        public get {
            if (dailyCare == null && isValidSalesforceId(dailyCareId, Daily_Care__c.class)){
                dailyCare = [SELECT AM_Reminders__c, Date__c, General_Reminders__c, PM_Reminders__c, 
                             Scent_of_the_Week__c, Special_Projects__c, Id, Name 
                             FROM Daily_Care__c WHERE Id =: dailyCareId];
            }
            return dailyCare;
        }
        private set;
    }
    
    public List<AnimalDailyCare> animalDailyCares {
        public get {
            if (animalDailyCares == null){
                set<id> animalIds = new set<id>();
               List<Animal_Daily_Care__c> lstADC = [SELECT Id, Name, Animal__c, Animal__r.Animal_Name_Id__c, Animal__r.Shelter_Location__c, Daily_Care__c, Handling_Instructions__c , 
                Mvmt_Round_Notes_Cleaning_Destination__c, Round__c, Enrichment__c, Special_Care_Other__c, Animal__r.Behavior_Medication_Flag__c,
                             Special_Care_Outside_TX__c, Special_Care_TX__c, Animal__r.Feeding_Amount__c FROM Animal_Daily_Care__c WHERE Daily_Care__c =: dailyCareId];
                     for (Animal_Daily_Care__c adc : lstADC) {
                            animalIds.add(adc.Animal__c);
                            }
                        if(!animalIds.isEmpty()){
                                getAnimalRestDays(animalIds);
                                //getAnimalEnrichments(animalIds);
                            }
                animalDailyCares= new  List<AnimalDailyCare> ();
                for (Animal_Daily_Care__c adcc : lstADC) {
                    AnimalDailyCare info = new AnimalDailyCare();
                    info.animalCareId = adcc.Id;
                    info.animalName = adcc.Name;
                    info.animalNameId = adcc.Animal__r.Animal_Name_Id__c;
                    info.animalC = adcc.animal__c;
                    info.animalshelterLocation = adcc.Animal__r.Shelter_Location__c;
                    info.dailyCare = adcc.Daily_Care__c;
                    info.round = adcc.Round__c;
                    info.specialCareTreatment = adcc.Special_Care_Outside_TX__c;
                    info.specialCareOutside = adcc.Special_Care_Outside_TX__c;
                    info.specialCareOther = adcc.Special_Care_Other__c;
                    info.handlingInstructions = adcc.Handling_Instructions__c;
                    info.movemntAndCleaningDestinationField = adcc.Mvmt_Round_Notes_Cleaning_Destination__c;
                    info.dailyRations = adcc.Animal__r.Feeding_Amount__c;
                    info.behaviorMeds = adcc.Animal__r.Behavior_Medication_Flag__c;
                    info.enrichment = adcc.Enrichment__c; //enrichmentByAnimal.get(adcc.animal__c);
                    info.restDays = restDayByAnimal?.get(adcc.animal__c)?.split(',');
                    animalDailyCares.add(info);
                }
            }
            return animalDailyCares;
        }
        private set;
    }
    
    public static Boolean isValidSalesforceId( String sfdcId, System.Type t ){
        try {
            
            if ( Pattern.compile( '[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}' ).matcher( sfdcId ).matches() ){
                Id id = sfdcId;
                sObject sObj = (sObject) t.newInstance();
                sObj.Id = id;
                return true;
            }
        } catch ( Exception e ){
        }
        return false;
    }

    public static void  getAnimalRestDays(set<Id> animalIds){
        String restDays = null;
        Date today = date.today();
        Date startDate = AutoScheduleTasksUtil.startOfASPCAWeek(today);
        Date endDate = startDate.addDays(7);
        Id rtId = Util.getRecordTypeId('Task', AutoScheduleTasksUtil.BEH_TREATMENT_TASK_RECORD_TYPE_NAME);
        Set<String> restDaysSet = new Set<String>();
        Map<string,List<Date>> treatmentDaysByAnimal = new Map<string,List<Date>>();
        List<Date> dates = null;
        for(Task t : [SELECT Id, ActivityDate,animal__c FROM Task WHERE Animal__c IN: animalIds AND RecordTypeId =: rtId AND ActivityDate >=: startDate AND ActivityDate <: endDate]){
            if(treatmentDaysByAnimal.containsKey(t.animal__c)){
                dates.add(t.ActivityDate);
                treatmentDaysByAnimal.put(t.animal__c, dates);
            } else {
                dates = new List<Date>{t.ActivityDate};
                treatmentDaysByAnimal.put(t.animal__c,dates);
            }
        }

        System.debug('treatmentDays: ' + treatmentDaysByAnimal);
        for (string tda : treatmentDaysByAnimal.keySet()) {
            if(treatmentDaysByAnimal.get(tda).isEmpty()) {
                restDayByAnimal.put(tda,'No treatments assigned this week');
            } else{
                while(startDate < endDate){
                    System.debug('startDate: ' + startDate);
                    if(!(treatmentDaysByAnimal.get(tda).contains(startDate))){
                        restDaysSet.add(AutoScheduleTasksUtil.getDayOfWeek(startDate));
                    }   
                    startDate = startDate.addDays(1);
                }
    
                if(!restDaysSet.isEmpty()){
                    restDayByAnimal.put(tda,String.join(new List<String>(restDaysSet), ','));
                    System.debug('restDayByAnimal'+ restDayByAnimal );
                }
            }
        }     
    }

    /*public static void  getAnimalEnrichments(set<Id> animalIds){
        Treatment_Plan__c[] plans = [SELECT Id, Enrichment_Activities__c,Animal__c FROM Treatment_Plan__c WHERE IsActive__c = true AND Animal__c IN: animalIds LIMIT 1];
        for (Treatment_Plan__c pln : plans) {
            if(string.isNotBlank(pln.Enrichment_Activities__c)){
                enrichmentByAnimal.put(pln.Animal__c, pln.Enrichment_Activities__c.replace(';', ','));
            }
        }
    }*/

   
    public class AnimalDailyCare{
        public Id animalCareId {get;set;}
        public String animalName {get;set;}
        public String animalC {get;set;}
        public String animalNameId {get;set;}
        public String animalshelterLocation {get;set;}
        public String dailyCare {get;set;}
        public String dailyRations {get;set;}
        public String[] restDays {get;set;}
        public Boolean behaviorMeds {get;set;}
        public String specialCareTreatment {get;set;}
        public String specialCareOutside {get;set;}
        public String specialCareOther {get;set;}
        public String enrichment {get;set;}
        public String round {get;set;}
        public String movemntAndCleaningDestinationField {get;set;}
        public String handlingInstructions {get;set;}
    }
}