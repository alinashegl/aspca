public class DailyCarePDFController {
    public String dailyCareId {get; set;}
    
    public DailyCarePDFController(){
        this.dailyCareId = ApexPages.currentPage().getParameters().get('dailyCareId');
    }
    
    public Daily_Care__c dailyCare {
        public get {
            if (dailyCare == null){
                dailyCare = [SELECT AM_Reminders__c, Date__c, General_Reminders__c, PM_Reminders__c, 
                             Scent_of_the_Week__c, Special_Projects__c, Id, Name 
                             FROM Daily_Care__c WHERE Id =: dailyCareId];
            }
            return dailyCare;
        }
        private set;
    }
    
    public List<Animal_Daily_Care__c> animalDailyCares {
        public get {
            if (animalDailyCares == null){
                animalDailyCares = [SELECT Id, Name, Animal__c, Daily_Care__c, Movement_Method_For_Cleaning__c, 
                             Movements_For_Cleaning__c, Round__c, Special_Care_Other__c, 
                             Special_Care_Outside_TX__c, Special_Care_TX__c FROM Animal_Daily_Care__c WHERE Daily_Care__c =: dailyCareId];
            }
            return animalDailyCares;
        }
        private set;
    }
    
    

}