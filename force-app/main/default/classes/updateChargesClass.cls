public class updateChargesClass {
    @AuraEnabled
	public static List<Charge_Information__c> getCharges(String caseID){
    	List<Charge_Information__c> chargeList = [SELECT Id, Name, Defendant__c, Defendant__r.Name, Statute__c, Statute_Lookup__c,
                                                  Statute_Lookup__r.Name, Charge_Title__c, Charge_Count__c, Court_Disposition__c,
                                                  Courtdisposition_Date__c, Sentence_Details_Picklist__c, Counts_Convicted__c,
                                                  Counts_Acquitted__c, Counts_Dismissed__c, Counts_ACD_Given__c, Length_of_Confinement__c,
                                                  Community_Service_Hours__c, Length_of_No_animal_Order__c, Amount_of_Fine__c, 
                                                  Length_of_probation__c, Length_of_Supervised_Release__c, Appeal__c, Defendant_Case_s_Closed__c
                                                  FROM Charge_Information__c WHERE Case__r.Id = :caseID];
        
		return chargeList;
	}
    @AuraEnabled
	public static List<String> dispositionOptions(){
    	List<String> dispositionOptions = new List<String>();
        Schema.DescribeFieldResult dispositionField = Charge_Information__c.Court_Disposition__c.getDescribe();
        List<Schema.PicklistEntry> dispositionValues = dispositionField.getPicklistValues();
        for(Schema.PicklistEntry dispositionValue : dispositionValues){
            dispositionOptions.add(dispositionValue.getValue());
        }
		return dispositionOptions;
	}
    @AuraEnabled
	public static List<String> sentenceOptions(){
    	List<String> sentenceOptions = new List<String>();
        Schema.DescribeFieldResult sentenceField = Charge_Information__c.Sentence_Details_Picklist__c.getDescribe();
        List<Schema.PicklistEntry> sentenceValues = sentenceField.getPicklistValues();
        for(Schema.PicklistEntry sentenceValue : sentenceValues){
            sentenceOptions.add(sentenceValue.getValue());
        }
        System.debug('Return results: ' + sentenceOptions);
		return sentenceOptions;
	}
    @AuraEnabled
    public static void updateCharges(List<Charge_Information__c> updatedCharges){
		update updatedCharges;
	}
}