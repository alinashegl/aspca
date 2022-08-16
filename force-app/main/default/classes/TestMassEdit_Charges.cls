@isTest
private class TestMassEdit_Charges {
    
    static testMethod void unitTest(){
        
	Case cs = new Case();
	insert cs;  
                
    Contact con = new Contact(FirstName = 'Test',LastName = 'Test');
    insert con;
        
    Charge_Information__c charge = new Charge_Information__c(Case__c=cs.Id, Defendant__c=con.Id);
    insert charge;
        
    MassEdit_Charges_Controller objME  = new MassEdit_Charges_Controller (new ApexPages.StandardController(cs));
        
    objME.saveChanges();
       
    

	}
}