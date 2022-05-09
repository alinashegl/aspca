public with sharing class DailyCareLWCController {

    //set default sort by field and value
    @AuraEnabled (cacheable=true)
    public static DailyCareInfo getDailyCare(Date careDate){
        return getDailyCare(careDate,'Animal__r.Shelter_Location__c', 'ASC');
    }
    
    @AuraEnabled (cacheable=true)
    public static DailyCareInfo getDailyCare(Date careDate, String sortByField, String sortByValue){
        DailyCareInfo info = new DailyCareInfo();
        if(careDate != null){
            try{
                Daily_Care__c[] dcList = [SELECT Id FROM Daily_Care__c WHERE Date__c =: careDate LIMIT 1];
                if(!dcList.isEmpty()){
                    Id dcId = dcList[0].Id;
                    info.dailyCareId = dcId;
                    info.animalDailyCares = getAnimalDailyCares(dcId, sortByField, sortByValue);
                }
                return info;
            } catch (Exception e) {
                System.debug('stackTrace: ' + e.getStackTraceString());
                throw new AuraHandledException(e.getMessage());
            }
        } else {
            AuraHandledException e = new AuraHandledException('No date selected');
            e.setMessage('No date selected');
            throw e;
        }
    }

    @testVisible
    private static Id[] getAnimalDailyCares(Id dailyCareId, String sortByField, String sortByValue){
        Id[] idList = new Id[0];
        String query = 'SELECT Id FROM Animal_Daily_Care__c WHERE Daily_Care__c = \'' +  dailyCareId + '\' ORDER BY ' + sortByField + ' ' + sortByValue;
        System.debug('query: ' + query);
        Animal_Daily_Care__c[] adcs = Database.query(query);
        for(Animal_Daily_Care__c adc : adcs){
            idList.add(adc.Id);
        }
        return idList;
    }

    @AuraEnabled (cacheable=true)
    public static AnimalInfo getAnimalDailyCareInfo(Id animalDailyCareId){
        if(animalDailyCareId != null){
            try{
                AnimalInfo info = new AnimalInfo();

                Animal_Daily_Care__c[] adcs = [
                    SELECT 
                        Id, 
                        Animal__c,
                        Animal__r.Animal_Name_Id__c, 
                        Animal__r.Behavior_Medication_Flag__c,
                        Animal__r.Feeding_Amount__c,
                        Animal__r.Shelter_Location__c,
                        Special_Care_TX__c,
                        Special_Care_Outside_TX__c,
                        Special_Care_Other__c,
                    Enrichment__c,
                        Round__c,
                        Mvmt_Round_Notes_Cleaning_Destination__c,
                        Handling_Instructions__c
                    FROM Animal_Daily_Care__c 
                    WHERE Id =: animalDailyCareId
                    LIMIT 1
                ];

                if(!adcs.isEmpty()){
                    Animal_Daily_Care__c adc = adcs[0];
                    info.animalCareId = adc.Id;
                    info.animalName = adc.Animal__r.Animal_Name_Id__c;
                    info.animalKennelLocation = adc.Animal__r.Shelter_Location__c;
                    info.dailyRations = adc.Animal__r.Feeding_Amount__c;
                    info.restDays = BehaviorUtil.getAnimalRestDays(adc.animal__c);
                    info.behaviorMeds = adc.Animal__r.Behavior_Medication_Flag__c;
                    info.specialCareTreatment = adc.Special_Care_TX__c;
                    info.specialCareOutside = adc.Special_Care_Outside_TX__c;
                    info.specialCareOther = adc.Special_Care_Other__c;
                    //info.enrichment = getAnimalEnrichments(adc.Animal__c);
                    info.enrichment = adc.Enrichment__c;
                    info.round = adc.Round__c;
                    info.movemntAndCleaningDestinationField = adc.Mvmt_Round_Notes_Cleaning_Destination__c;
                    info.handlingInstructions = adc.Handling_Instructions__c;
                }
                
                return info;
            
            } catch (Exception e) {
                System.debug('stackTrace: ' + e.getStackTraceString());
                throw new AuraHandledException(e.getMessage());
            }
        } else {
            return null;
        }
    }

    public class DailyCareInfo{
        @AuraEnabled public Id dailyCareId;
        @AuraEnabled public Id[] animalDailyCares;
    }

    public class AnimalInfo{
        @AuraEnabled public Id animalCareId;
        @AuraEnabled public String animalName;
        @AuraEnabled public String animalKennelLocation;
        @AuraEnabled public String dailyRations;
        @AuraEnabled public String restDays;
        @AuraEnabled public Boolean behaviorMeds;
        @AuraEnabled public String specialCareTreatment;
        @AuraEnabled public String specialCareOutside;
        @AuraEnabled public String specialCareOther;
        @AuraEnabled public String enrichment;
        @AuraEnabled public String round;
        @AuraEnabled public String movemntAndCleaningDestinationField;
        @AuraEnabled public String handlingInstructions;
    }
}