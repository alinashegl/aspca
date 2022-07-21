public class MassEdit_Charges_Controller {
    
	public Id caseId = ApexPages.currentPage().getparameters().get('Id');
    public List<Charge_Information__c> chargeList {get;set;}
    
	public MassEdit_Charges_Controller (ApexPages.StandardController controller){
        chargeList = [SELECT Id, 
                                                               Name,
                                                               Defendant__c,
                                                               Statute_Lookup__c,
                                                               Statute__c,
                                                               Charge_Title__C, 
                      										   Charge_Count__c,
                                                               Court_Disposition__c,
                                                               Courtdisposition_Date__c,
                                                               Sentence_Details_Picklist__c,
                                                               Counts_Convicted__c,
                                                               Counts_Acquitted__C,
                                                               Counts_Dismissed__c,
                                                               Length_of_Confinement__c,
                                                               Community_Service_Hours__c,
                                                               Length_of_No_animal_Order__c,
                                                               Amount_of_Fine__c,
                                                               Length_of_probation__c,
                                                               Length_of_Supervised_Release__c,
                                                               Appeal__c,
                                                               Defendant_Case_s_Closed__c
                                                               
                                                               FROM Charge_Information__c WHERE Case__r.Id =: caseId];
        
        
    }

/*    public List<Charge_Information__c> chargeList {
                get{
            if (chargeList == null){
                chargeList = new list<Charge_Information__c> ([SELECT Id, 
                                                               Name,
                                                               Defendant__c,
                                                               Statute_Lookup__c,
                                                               Statute__c,
                                                               Charge_Title__C, 
                                                               Court_Disposition__c,
                                                               Courtdisposition_Date__c,
                                                               Sentence__c,
                                                               Counts_Convicted__c,
                                                               Counts_Acquitted__C,
                                                               Counts_Dismissed__c,
                                                               Length_of_Confinement__c,
                                                               Community_Service_Hours__c,
                                                               Length_of_No_animal_Order__c,
                                                               Amount_of_Fine__c,
                                                               Length_of_probation__c,
                                                               Length_of_Supervised_Release__c,
                                                               Appeal__c,
                                                               Defendant_Case_s_Closed__c	
                                                               
                                                               FROM Charge_Information__c WHERE Case__r.Id =: caseId]);
            }
            return chargeList;
        }
        set;
    }*/
    
    public PageReference saveChanges(){
        update chargeList;
        return new PageReference('/'+caseId);
        
    }
    
}