@isTest
private class updateChargesTest {
    static testMethod void testCharges(){
    	Case testCase = new Case();
		insert testCase;  
                
        Contact testContact = new Contact();
        testContact.FirstName = 'Samus';
        testContact.LastName = 'Aran';
        insert testContact;
        
        Charge_Information__c testCharge = new Charge_Information__c();
        testCharge.Case__c = testCase.ID;
        testCharge.Defendant__c = testContact.ID;
        insert testCharge;
        
        test.startTest();
            List<Charge_Information__c> returnedCharges = updateChargesClass.getCharges(testCase.ID);
        	updateChargesClass.dispositionOptions();
        	updateChargesClass.sentenceOptions();
        test.stopTest();
        
        System.assertEquals(1, returnedCharges.size());
    }

}