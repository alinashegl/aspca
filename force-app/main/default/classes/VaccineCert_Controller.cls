public class VaccineCert_Controller {
    
    list<Animal__c> lstAnimal {get;set;}
    public Animal__c objAnimal{get;set;}
    public String doctorValue{get;set;}
    public Date Today { get { return Date.today(); }}
    
    public VaccineCert_Controller (ApexPages.StandardController controller)
        
        {
         lstAnimal = [select Id,
                      Name, 
                      Animal_Name__c, 
                      Type_of_animal__c, 
                      Breed__c, 
                      Gender__c, 
                      Current_Animal_Age_Estimate__c, 
                      Current_Animal_Age_Formatted__c,
                      Animal_Age__c,
                      Intake_Date_Time__c, 
                      Color__c,
                      Secondary_Color__c,
                      Current_Weight_in_kgs_Num__c,
                      Current_Weight_in_lbs_Num__c,
                      Microchip_Number__c,
                      Assessment__c,
                      Recommendations__c,
                      Administered_Microchip_Number__c,
                      Photo_Document_Id__c,
                      Estimated_Date_of_Birth__c
                      FROM Animal__c 
                      WHERE Id = :ApexPages.currentPage().getparameters().get('Id')];
         if(lstAnimal.size()>0)
             objAnimal = lstAnimal[0];
    }
    
    	public List<Vaccine_and_Preventative__c	> vaccs{
        get{
            if (vaccs == null){
                vaccs = new List<Vaccine_and_Preventative__c> ([SELECT Id, 
                                                                Vaccine_Preventative__r.Name,
                                                                Vaccine_Preventative__r.Manufacturer__c,
                                                                Vaccine_Preventative__r.Lot_Number__c, 
                                                                Date_Administered__c, 
                                                                Rabies_Tag__c,
                                                                Route__c,
                                                                Due_On__c,
                                                                Notes__c
                                                           FROM Vaccine_and_Preventative__c	
                                                           WHERE Animal__r.Id = :ApexPages.currentPage().getparameters().get('Id')
                                                           ORDER BY Date_Administered__c DESC]);
            }
            return vaccs;
        }
        private set;
    }
    
   public PageReference genCert(){

    PageReference pr = new PageReference('/apex/VaccineCert'); 
    return pr;
    }
    
    public String getDoc(){
        return doctorValue;
    }
    
    public void setDoc(String doctorValue){
        this.doctorValue = doctorValue;
    }
    

}