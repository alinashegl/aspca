@isTest
private class Test_DailyCareLWCController {
    @isTest
    static void getDailyCare_Success() {
        Daily_Care__c dc = TestDataFactory.createDailyCareWithAnimalDailyCares(2);

        test.startTest();
        DailyCareLWCController.DailyCareInfo dcInfo = DailyCareLWCController.getDailyCare(dc.Date__c);
        test.stopTest();

        System.assert(dcInfo != null, 'Should have returned a dcInfo, but was null');
        System.assertEquals(dc.Id, dcInfo.dailyCareId);
        System.assert(!dcInfo.animalDailyCares.isEmpty(), 'Should have returned a list of animalInfos, but was empty');
    }

    @isTest
    static void getDailyCare_NoDailyCareForDate() {
        Daily_Care__c dc = TestDataFactory.createDailyCareWithAnimalDailyCares(2);

        test.startTest();
        DailyCareLWCController.DailyCareInfo dcInfo = DailyCareLWCController.getDailyCare(date.today().addDays(-1));
        test.stopTest();

        System.assertEquals(null, dcInfo.dailyCareId);
        System.assertEquals(null, dcInfo.animalDailyCares);
    }

    @isTest
    static void getAnimalDailyCares_Success() {
        Daily_Care__c dc = TestDataFactory.createDailyCareWithAnimalDailyCares(2);

        test.startTest();
        Id[] animalDailyCareIds = DailyCareLWCController.getAnimalDailyCares(dc.Id,'Animal__r.Shelter_Location__c', 'ASC');
        test.stopTest();

        System.assertEquals(2, animalDailyCareIds.size());
    }

    @isTest
    static void getAnimalDailyCares_NoAnimalDailyCares() {
        Daily_Care__c dc = TestDataFactory.createDailyCare();

        test.startTest();
        Id[] animalDailyCareIds = DailyCareLWCController.getAnimalDailyCares(dc.Id,'Animal__r.Shelter_Location__c', 'ASC');
        test.stopTest();

        System.assert(animalDailyCareIds.isEmpty());
    }

    @isTest
    static void getAnimalDailyCareInfo_Success() {
        Daily_Care__c dc = TestDataFactory.createDailyCareWithAnimalDailyCares(2);
        Animal_Daily_Care__c[] adcList = [SELECT Id, Animal__r.Animal_Name_Id__c FROM Animal_Daily_Care__c WHERE Daily_Care__c =: dc.Id];

        test.startTest();
        for(Animal_Daily_Care__c adc : adcList){
            DailyCareLWCController.AnimalInfo aInfo = DailyCareLWCController.getAnimalDailyCareInfo(adc.Id);
            System.assertEquals(adc.Id, aInfo.animalCareId);
            System.assertEquals(adc.Animal__r.Animal_Name_Id__c, aInfo.animalName);
        }   
        test.stopTest();
    }

    @isTest
    static void getAnimalDailyCareInfo_NoAnimalDailyCare() {
        test.startTest();
            DailyCareLWCController.AnimalInfo aInfo = DailyCareLWCController.getAnimalDailyCareInfo(null);
            System.assertEquals(null, aInfo);
        test.stopTest();
    }
}