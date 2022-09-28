@isTest
private class Test_MRCTxPlansReportLWCController {
    @isTest
    static void getMotivators_Success() {
        Treatment_Plan__c tp = TestDataFactory.createPlan();
        tp.Preferred_Motivators__c = 'toys;treats';
        update tp;

        Treatment_Plan__c tp2 = new Treatment_Plan__c(
          IsActive__c = false, 
          Description__c = 'Test', 
          Animal__c = tp.Animal__c, 
          AssignedTreatmentBundleId__c = tp.AssignedTreatmentBundleId__c,
          Problem_Behavior__c = 'Fear of People - Mild',
          Preferred_Motivators__c = 'Treats;newspaper'

        );

        insert tp2;

        Animal__c dog = [SELECT Id, (SELECT Id, Preferred_Motivators__c FROM Treatment_Plan__r) FROM Animal__c WHERE Id =: tp.Animal__c LIMIT 1];

        test.startTest();
            String motivators = MRCTreatmentPlansReportLWCController.getMotivators(dog);
        test.stopTest();

        System.assert(motivators.contains('toys'), 'Should have included toys');
        System.assert(motivators.contains('treats'), 'Should have included treats');
        System.assert(motivators.contains('Treats'), 'Should have included Treats');
        System.assert(motivators.contains('newspaper'), 'Should have included newspaper');
    }

    @isTest
    static void getMotivators_NoMotivators() {
        Treatment_Plan__c tp = TestDataFactory.createPlan();

        Treatment_Plan__c tp2 = new Treatment_Plan__c(
          IsActive__c = false, 
          Description__c = 'Test', 
          Animal__c = tp.Animal__c, 
          AssignedTreatmentBundleId__c = tp.AssignedTreatmentBundleId__c,
          Problem_Behavior__c = 'Fear of People - Mild'
        );

        insert tp2;

        Animal__c dog = [SELECT Id, (SELECT Id, Preferred_Motivators__c FROM Treatment_Plan__r) FROM Animal__c WHERE Id =: tp.Animal__c LIMIT 1];

        test.startTest();
            String motivators = MRCTreatmentPlansReportLWCController.getMotivators(dog);
        test.stopTest();

        System.assertEquals('', motivators, 'Should have returned a blank string, but was: ' + motivators);
    }

    @isTest
    static void getProtocolCategoryMap_Success() {
        Treatment_Plan__c tp = TestDataFactory.createPlan();

        test.startTest();
            Map<Id, Map<String, Plan_Protocol__c[]>> protocolIdMap = MRCTreatmentPlansReportLWCController.getProtocolCategoryMap(new Id[]{tp.Animal__c});
        test.stopTest();

        System.assert(!protocolIdMap.isEmpty(), 'Should have returned a map, instead was empty');
    }

    @isTest
    static void getProtocolCategoryMap_NoProtocols() {
        Animal__c dog = TestDataFactory.createAnimal();

        test.startTest();
            Map<Id, Map<String, Plan_Protocol__c[]>> protocolIdMap = MRCTreatmentPlansReportLWCController.getProtocolCategoryMap(new Id[]{dog.Id});
        test.stopTest();

        System.assert(protocolIdMap.isEmpty(), 'Should have returned an empty map, instead was: ' + protocolIdMap);
    }

    @isTest 
    static void getHelperDogs_Success(){
        Animal__c dog = TestDataFactory.createAnimal();
        dog.Helper_Dogs__c = 'fido;willow';
        update dog;

        test.startTest();
            dog = MRCTreatmentPlansReportLWCController.getHelperDogs(dog.Id);
        test.stopTest();

        System.assertEquals('fido;willow', dog.Helper_Dogs__c);
    }

    @isTest 
    static void getHelperDogs_NoDogs(){
        Animal__c dog = TestDataFactory.createAnimal();
        update dog;

        test.startTest();
            dog = MRCTreatmentPlansReportLWCController.getHelperDogs(dog.Id);
        test.stopTest();

        System.assertEquals(null, dog.Helper_Dogs__c);
    }

    @isTest 
    static void getPlanProtocolInfo_Success(){
        Plan_Protocol__c[] protocols = TestDataFactory.createPlanProtocols(1);
        protocols[0].Protocol_Notes__c = 'test notes';
        update protocols;

        test.startTest();
            Plan_Protocol__c protocol = MRCTreatmentPlansReportLWCController.getPlanProtocolInfo(protocols[0].Id);
        test.stopTest();

        System.assertEquals('test notes', protocol.Protocol_Notes__c);
    }

    @isTest 
    static void getPlanProtocolInfo_NoNotes(){
        Plan_Protocol__c[] protocols = TestDataFactory.createPlanProtocols(1);

        test.startTest();
            Plan_Protocol__c protocol = MRCTreatmentPlansReportLWCController.getPlanProtocolInfo(protocols[0].Id);
        test.stopTest();

        System.assertEquals(null, protocol.Protocol_Notes__c);
    }

    @isTest
    static void getAnimalInfos_Success(){
        Treatment_Plan__c tp = TestDataFactory.createPlan();
        tp.Preferred_Motivators__c = 'test;toys';
        update tp;


        Play_Pause__c[] pps = TestDataFactory.createPlayPauses(new Animal__c(Id = tp.Animal__c));

        Animal__c dog = [
            SELECT Id, Animal_Name_Id__c, Gender__c, Breed__c, Current_Location__c, Shelter_Color_Coding__c, Shelter_Location__c,Helper_Dogs__c,
            (SELECT Id, Preferred_Motivators__c FROM Treatment_Plan__r),
            (SELECT Id FROM Play_Pauses__r WHERE (End_Date__c = null OR End_Date__c >= TODAY) LIMIT 1)
            FROM Animal__c 
            WHERE Id =: tp.Animal__c
        ];

        test.startTest();
            MRCTreatmentPlansReportLWCController.AnimalInfo[] infos = MRCTreatmentPlansReportLWCController.getAnimalInfos(new Animal__c[]{dog});
        test.stopTest();

        System.assert(!infos.isEmpty(), 'Should have returned an animalInfo, but was empty');
        MRCTreatmentPlansReportLWCController.AnimalInfo info = infos[0];
        System.assertEquals('test; toys', info.motivators);
        System.assertEquals(true, info.isPlayPause);
        System.assert(!info.categoryToProtocolMap.isEmpty(), 'Should have returned a map of protocols, but was empty');
    }

    @isTest
    static void getAnimalInfos_NoAnimal(){
        test.startTest();
            MRCTreatmentPlansReportLWCController.AnimalInfo[] infos = MRCTreatmentPlansReportLWCController.getAnimalInfos(new Animal__c[0]);
        test.stopTest();

        System.assert(infos.isEmpty(), 'Should have returned an empty infos, but was: ' + infos);
    }

    @isTest
    static void getMRCDogs_Success(){
        String[] dogNames = new String[]{'fido','willow','mika'};
        for(String name : dogNames){
            Animal__c dog = TestDataFactory.createAnimalWithName(name);
        }

        test.startTest();
            Animal__c[] dogs = MRCTreatmentPlansReportLWCController.getMRCDogs();
        test.stopTest();

        System.assert(!dogs.isEmpty(), 'Should have returned a list of dogs, but was empty');
        System.assertEquals(3, dogs.size());
    }

    @isTest
    static void getMRCDogs_NoMRCDog(){
        String[] dogNames = new String[]{'fido','willow','mika'};
        Animal__c[] dogs = new Animal__c[0];
        for(String name : dogNames){
            Animal__c dog = TestDataFactory.createAnimalWithName(name);
            dog.Current_Location__c = 'ARC';
            dogs.add(dog);
        }

        update dogs;

        test.startTest();
            Animal__c[] mrcDogs = MRCTreatmentPlansReportLWCController.getMRCDogs();
        test.stopTest();

        System.assert(mrcDogs.isEmpty(), 'Should have returned an empty list of dogs, but was: ' + mrcDogs);
    }

    @isTest
    static void getMRCDogsForPDF_Success(){
        Treatment_Plan__c tp = TestDataFactory.createPlan();

        test.startTest();
        MRCTreatmentPlansReportLWCController.AnimalInfo[] infos = MRCTreatmentPlansReportLWCController.getMRCDogsForPDF();
        test.stopTest();

        System.assert(!infos.isEmpty(), 'Should have returned a list of infos, but was empty');
    }

    @isTest
    static void getMRCDogsForPDF_NoMRCDog(){
        Treatment_Plan__c tp = TestDataFactory.createPlan();

        Animal__c dog = new Animal__c(
            Id = tp.Animal__c,
            Current_Location__c = 'ARC'
        );

        update dog;

        test.startTest();
        MRCTreatmentPlansReportLWCController.AnimalInfo[] infos = MRCTreatmentPlansReportLWCController.getMRCDogsForPDF();
        test.stopTest();

        System.assert(infos.isEmpty(), 'Should have returned an empty list of infos, but was: ' + infos);
    }

    @isTest 
    static void getTipOfMonth_Success(){
        Generic_Data__c gd = new Generic_Data__c(
            Species__c = 'Dog',
            Location__c = 'MRC',
            Name = 'MRC TOM',
            Text__c = 'tip of month'
        );
        insert gd;

        test.startTest();
        Generic_Data__c returnedGd = MRCTreatmentPlansReportLWCController.getTipOfMonth();
        test.stopTest();

        System.assert(returnedGd != null, 'Should have returned a generic data for tip of month, but was null');
        System.assertEquals(gd.Id, returnedGd.Id);
    }

    @isTest 
    static void getTipOfMonth_NoGenericData(){
        test.startTest();
        Generic_Data__c returnedGd = MRCTreatmentPlansReportLWCController.getTipOfMonth();
        test.stopTest();

        System.assert(returnedGd == null, 'Should have returned a null value, but was: ' + returnedGd);
    }

    @isTest 
    static void instantiate_MRCTreatmentPlansReportLWCController(){
        Treatment_Plan__c tp = TestDataFactory.createPlan();        
        
        test.startTest();
            MRCTreatmentPlansReportLWCController cont = new MRCTreatmentPlansReportLWCController();
            MRCTreatmentPlansReportLWCController.AnimalInfo[] infos = MRCTreatmentPlansReportLWCController.getMRCDogsForPDF();
            cont.infoWrapper = infos;
        test.stopTest();

        System.assertEquals(false, infos.isEmpty());
    }
}