@isTest
private class test_DailyCareController {
    @isTest 
    static void getDailyCareSuccess() {
        Daily_Care__c dc = TestDataFactory.createDailyCare();

        test.startTest();
            Daily_Care__c newDc = DailyCareController.getDailyCare();
        test.stopTest();

        System.assertEquals(dc.Id, newDc.Id);
    }

    @isTest
    static void getDailyCareNoDailyCare(){
        test.startTest();
            Daily_Care__c newDc = DailyCareController.getDailyCare();
        test.stopTest();

        System.assertEquals(null, newDc);
    }

    @isTest
    static void getDailyCareNotNeeded(){
        Daily_Care__c dc = TestDataFactory.createDailyCare();
        dc.Date__c = date.today().addDays(1);
        update dc;
        
        test.startTest();
            Daily_Care__c newDc = DailyCareController.getDailyCare();
        test.stopTest();

        System.assertEquals(null, newDc);
    }

    @isTest
    static void getAnimalDailyCareMapSuccess(){
        Daily_Care__c dc = TestDataFactory.createDailyCareWithAnimalDailyCares(2);

        test.startTest();
            Map<Id, Animal_Daily_Care__c> adcMap = DailyCareController.getAnimalDailyCareMap(dc.Id);
        test.stopTest();
        System.assertEquals(2, adcMap.values().size());
    }

    @isTest
    static void getAnimalDailyCareMapNoDailyCare(){
        test.startTest();
            Map<Id, Animal_Daily_Care__c> adcMap = DailyCareController.getAnimalDailyCareMap(null);
        test.stopTest();
        System.assert(adcMap.isEmpty(), 'should have been an empty map, instead was: ' + adcMap);
    }

    @isTest
    static void getAnimalDailyCareMapNoAnimals(){
        Daily_Care__c dc = TestDataFactory.createDailyCare();

        test.startTest();
            Map<Id, Animal_Daily_Care__c> adcMap = DailyCareController.getAnimalDailyCareMap(dc.Id);
        test.stopTest();
        System.assert(adcMap.isEmpty(), 'should have been an empty map, instead was: ' + adcMap);
    }

    @isTest 
    static void updateAnimalsSuccess(){
        Daily_Care__c dc = TestDataFactory.createDailyCareWithAnimalDailyCares(2);
        Animal_Daily_Care__c[] adcs = [SELECT Id, Handling_Instructions__c, Animal__c, Animal__r.Handling_Instructions__c FROM Animal_Daily_Care__c];
        for(Animal_Daily_Care__c adc : adcs){
            adc.Handling_Instructions__c = 'test instructions';
        }

        test.startTest();
            DailyCareController.updateAnimals(adcs);
        test.stopTest();
        
        Animal__c[] animals = [SELECT Id, Handling_Instructions__c FROM Animal__c];
        System.assertEquals(2, animals.size());
        for(Animal__c anim : animals){
            system.assertEquals('test instructions', anim.Handling_Instructions__c);
        }
    }

    @isTest 
    static void updateAnimalsNoAnimals(){
        test.startTest();
            DailyCareController.updateAnimals(null);
        test.stopTest();

        System.assert([SELECT Id FROM Animal__c].isEmpty());
    }

    @isTest 
    static void updateAnimalsEmptyList(){
        test.startTest();
            DailyCareController.updateAnimals(new Animal_Daily_Care__c[0]);
        test.stopTest();

        System.assert([SELECT Id FROM Animal__c].isEmpty());
    }

    @isTest 
    static void createDailyCareSuccess(){
        Daily_Care__c dc = TestDataFactory.createDailyCareWithAnimalDailyCares(2);

        test.startTest();
            Daily_Care__c newDc = DailyCareController.createDailyCare(dc);
        test.stopTest();

        System.assert(newDc.Id != dc.Id);
        System.assertEquals(date.today().addDays(1), newDc.Date__c);
    }

    @isTest 
    static void createDailyCareNoDailyCare(){
        test.startTest();
            Daily_Care__c newDc = DailyCareController.createDailyCare(null);
        test.stopTest();

        System.assert(newDc == null);
    }

    @isTest 
    static void getScentOfWeekFirstToSecond(){
        String[] scentValues = SchemaHelper.GetPicklistValues(SchemaHelper.DetermineSObjectFieldByLabel('Daily_Care__c', 'Scent of the Week'));        
        test.startTest();
            String newScent = DailyCareController.getScentOfWeek(scentValues[0]);
        test.stopTest();

        System.assertEquals(scentValues[1], newScent);
    }

    @isTest 
    static void getScentOfWeekLastToFirst(){
        String[] scentValues = SchemaHelper.GetPicklistValues(SchemaHelper.DetermineSObjectFieldByLabel('Daily_Care__c', 'Scent of the Week'));
        Integer index = scentValues.size() - 1;
        
        test.startTest();
            String newScent = DailyCareController.getScentOfWeek(scentValues[index]);
        test.stopTest();

        System.assertEquals(scentValues[0], newScent);
    }

    @isTest 
    static void getScentOfWeekBadCurrentValue(){
        String[] scentValues = SchemaHelper.GetPicklistValues(SchemaHelper.DetermineSObjectFieldByLabel('Daily_Care__c', 'Scent of the Week'));
        
        test.startTest();
            String newScent = DailyCareController.getScentOfWeek('zzzz');
        test.stopTest();

        System.assertEquals(scentValues[0], newScent);
    }

    @isTest 
    static void getActiveMRCDogsSuccess(){
        Animal__c mrc1 = TestDataFactory.createAnimalWithName('mrc1');
        Animal__c mrc2 = TestDataFactory.createAnimalWithName('mrc2');
        Animal__c arc = TestDataFactory.createAnimalWithName('ARC');
        arc.Current_Location__c = 'ARC';
        update arc;

        test.startTest();
            Animal__c[] mrcDogs = DailyCareController.getActiveMRCDogs();
        test.stopTest();

        System.assertEquals(2, mrcDogs.size());
    }

    @isTest 
    static void getActiveMRCDogsNoAnimals(){
        test.startTest();
            Animal__c[] mrcDogs = DailyCareController.getActiveMRCDogs();
        test.stopTest();

        System.assert(mrcDogs.isEmpty());
    }

    @isTest 
    static void createAnimalDailyCaresSuccess(){
        Daily_Care__c dc = TestDataFactory.createDailyCareWithAnimalDailyCares(2);
        Daily_Care__c newDc = TestDataFactory.createDailyCare();

        Animal__c[] animals = [SELECT Id, Handling_Instructions__c, 
        (SELECT Id, Round__c,Special_Care_Other__c, Special_Care_Outside_TX__c, Special_Care_TX__c,Movements_For_Cleaning__c
        FROM Animals_Daily_Care__r ORDER BY CreatedDate DESC LIMIT 1)
        FROM Animal__c ];

        test.startTest();
            DailyCareController.createAnimalDailyCares(newDc.Id, animals);
        test.stopTest();

        Animal_Daily_Care__c[] adcs = [SELECT Id FROM Animal_Daily_Care__c WHERE Daily_Care__c =: newDc.Id];
        System.assertEquals(2, adcs.size());
    }
}