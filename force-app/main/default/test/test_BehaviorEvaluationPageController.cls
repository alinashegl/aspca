/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class test_BehaviorEvaluationPageController {
    @IsTest
    static void regressionCoverage() {
        Behavior_Evaluation__c evaluation = TestDataFactory.createPuppyBehaviorEvaluation();
        Test.startTest();
        Behavior_Evaluation__c testGetter = BehaviorEvaluationPageController.getOne(evaluation.Id);
        List<EvaluationWrapper> allWrappers = new List<EvaluationWrapper>();
        List<EvaluationWrapper> puppyWrappers = BehaviorEvaluationPageController.getPuppyEvaluation(evaluation);
        List<EvaluationWrapper> adultWrappers = BehaviorEvaluationPageController.getAdultEvaluation(evaluation);
        allWrappers.addAll(puppyWrappers);
        allWrappers.addAll(adultWrappers);

        Map<String, Object> updateEvalTest = BehaviorEvaluationPageController.updateEval('Comments_BIK__c',
                'Social', evaluation.Id);
        Map<String, Object> selectionsTest = BehaviorEvaluationPageController.putSelections('Behavior_In_Kennel__c',
                new List<String>{'{"label":"Social","isSelected":true}, {"label":"Not Social","isSelected":true}'}, evaluation.Id);
        Map<String,Object> validityTest = BehaviorEvaluationPageController.handleValidity(evaluation.Id);
        List<EvaluationWrapper.ListItems> items = BehaviorEvaluationPageController.getSkipReasons(1);
        Test.stopTest();
        System.assertEquals('success', selectionsTest.get('status'));
        System.assertEquals('success', updateEvalTest.get('status'));
        System.assertEquals('success', validityTest.get('status'));
        System.assertEquals(Behavior_Evaluation__c.Skipped_BIK__c.getDescribe().getPicklistValues().size(), items.size());
        System.assertEquals(37, allWrappers.size());
    }

    @IsTest
    static void adultCoverage() {
        Behavior_Evaluation__c evaluation = TestDataFactory.createAdultBehaviorEvaluation(false);
        Test.startTest();
        Behavior_Evaluation__c testGetter = BehaviorEvaluationPageController.getOne(evaluation.Id);

        Map<String,Object> validityTest = BehaviorEvaluationPageController.handleValidity(evaluation.Id);
        Test.stopTest();
        System.assertEquals(evaluation.Id, testGetter.Id);
        System.assertEquals('success', validityTest.get('status'));
    }
    @IsTest
    static void dogFightingCoverage() {
        Behavior_Evaluation__c evaluation = TestDataFactory.createAdultBehaviorEvaluation(true);
        Test.startTest();
        Behavior_Evaluation__c testGetter = BehaviorEvaluationPageController.getOne(evaluation.Id);

        Map<String,Object> validityTest = BehaviorEvaluationPageController.handleValidity(evaluation.Id);
        Test.stopTest();
        System.assertEquals(evaluation.Id, testGetter.Id);
        System.assertEquals('success', validityTest.get('status'));
    }

    @isTest
    static void getBehaviorReportPuppy() {
        Behavior_Evaluation__c evaluation = TestDataFactory.createPuppyBehaviorEvaluation();
        Test.startTest();
        TabContentUtil behRep = BehaviorEvaluationPageController.getBehaviorReport(evaluation);
        Test.stopTest();
        System.assertEquals(evaluation.Is_Muzzled__c, behRep.IsMuzzled);
        System.assertEquals(null, behRep.puppyHousing);
        System.assertEquals(evaluation.Puppy_Muzzled_DI_P1__c, behRep.puppyMuzzledDogInteraction1);
        System.assertEquals(evaluation.Puppy_Muzzled_DI_P2__c, behRep.puppyMuzzledDogInteraction2);
        System.assertEquals(evaluation.Puppy_Muzzled_DI_P3__c, behRep.puppyMuzzledDogInteraction3);
        System.assertEquals(evaluation.Muzzled_SSD_P3__c, behRep.muzzledSameSexDog3);
        System.assertEquals(evaluation.Muzzled_OSD_P3__c, behRep.muzzledOppositeSexDog3);
        System.assertEquals(evaluation.Caution__c, behRep.UseCaution);
        System.assertEquals(false, behRep.IsAdult);
        System.assertEquals(true, behRep.IsPuppy);
        System.assertEquals(false, behRep.IsDogFighting);
        System.assertEquals(evaluation.Unpleasant_Touch_1st_Flank__c, behRep.UnpleasantTouch1stFlank);
        System.assertEquals(evaluation.Unpleasant_Touch_2nd_Flank__c, behRep.UnpleasantTouch2ndFlank);
    }

    @isTest
    static void getBehaviorReportDogFighting() {
        Behavior_Evaluation__c evaluation = TestDataFactory.createAdultBehaviorEvaluation(true);
        Test.startTest();
        TabContentUtil behRep = BehaviorEvaluationPageController.getBehaviorReport(evaluation);
        Test.stopTest();
        System.assertEquals(evaluation.Is_Muzzled__c, behRep.IsMuzzled);
        System.assertEquals(evaluation.Puppy_Muzzled_DI_P1__c, behRep.puppyMuzzledDogInteraction1);
        System.assertEquals(evaluation.Puppy_Muzzled_DI_P2__c, behRep.puppyMuzzledDogInteraction2);
        System.assertEquals(evaluation.Puppy_Muzzled_DI_P3__c, behRep.puppyMuzzledDogInteraction3);
        System.assertEquals(evaluation.Muzzled_SSD_P3__c, behRep.muzzledSameSexDog3);
        System.assertEquals(evaluation.Muzzled_OSD_P3__c, behRep.muzzledOppositeSexDog3);
        System.assertEquals(evaluation.Caution__c, behRep.UseCaution);
        System.assertEquals(true, behRep.IsAdult);
        System.assertEquals(false, behRep.IsPuppy);
        System.assertEquals(true, behRep.IsDogFighting);
        System.assertEquals(evaluation.Unpleasant_Touch_1st_Flank__c, behRep.UnpleasantTouch1stFlank);
        System.assertEquals(evaluation.Unpleasant_Touch_2nd_Flank__c, behRep.UnpleasantTouch2ndFlank);
    }

    //putBoolean
    @isTest
    static void updateBoolean() {
        Behavior_Evaluation__c evaluation = TestDataFactory.createPuppyBehaviorEvaluation();
        Test.startTest();
        Map<String, Object> putBooleanTest = BehaviorEvaluationPageController.putBoolean('Puppy_Muzzled_DI_P1__c', true, evaluation.Id);
        Test.stopTest();
        System.assertEquals('success', putBooleanTest.get('status'));
    }

    //putSelection
    @isTest
    static void updateRegularPicklist() {
        Behavior_Evaluation__c evaluation = TestDataFactory.createPuppyBehaviorEvaluation();
        Test.startTest();
        Map<String, Object> putSelectionTest = BehaviorEvaluationPageController.putSelection('Puppy_BIK_Housing__c', 'Singly-housed', evaluation.Id);
        Test.stopTest();
        System.assertEquals('success', putSelectionTest.get('status'));
    }

    @isTest
    static void wrapperTestCoverage() {
        Test.startTest();
        EvaluationWrapper.ListItems eWLI1 = new EvaluationWrapper.ListItems();
        EvaluationWrapper.Options eWO1 = new EvaluationWrapper.Options();
        EvaluationWrapper.FieldContents eWFC1 = new EvaluationWrapper.FieldContents();
        EvaluationWrapper eW1 = new EvaluationWrapper();
        TabContentUtil tCU1 = new TabContentUtil();
        EvaluationWrapper.ListItems eWLI2 = new EvaluationWrapper.ListItems('label', 'value');
        EvaluationWrapper.Options eWO2 = new EvaluationWrapper.Options('label', 'longDesc', 'pleApiName', true);
        EvaluationWrapper.FieldContents eWFC2 = new EvaluationWrapper.FieldContents('id', eWO2);
        List<EvaluationWrapper.Options> eWOL = new List<EvaluationWrapper.Options>{eWO2};
        EvaluationWrapper eW2 = new EvaluationWrapper('id', 'label', false, eWFC2, eWOL, eWOL, eWOL,
            eWOL, eWOL, eWOL, eWFC2, 1, false, 'parentTestApiName', eW1, eW1, eW1, eW1);
        TabContentUtil tCU2 = new TabContentUtil('id', 'label', 'name', 'breed', 'color', 'caseNumber',
            'animalId', 'animalAge', 'animalSex', 'location', System.today(), eWOL, eWOL, 'behaviorSummary',
            true, false, false, false, false, false, eWFC2, false, false, 'puppyHousing', false, false, false, false, false);
        Test.stopTest();
    }
}