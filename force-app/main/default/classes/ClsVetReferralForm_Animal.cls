public class ClsVetReferralForm_Animal {
    
    list<Animal__c> lstAnimal {get;set;}
    public Animal__c objAnimal{get;set;}
    public Date Today { get { return Date.today(); }}
   
    public ClsVetReferralForm_Animal ()
    {
         lstAnimal = [select Id,Designated_Handler__c,Shelter_Location__c,name, Animal_Name__c, type_of_animal__c, breed__c, gender__c, Age__c, Animal_Age__c,Intake_Date_Time__c, Color__c,Photo__c,Photo2__c,Photo_Document_Id__c FROM Animal__c WHERE Id = :ApexPages.currentPage().getparameters().get('Id')];
         
         if(lstAnimal.size()>0)
             objAnimal = lstAnimal[0];
    
    }
        
}