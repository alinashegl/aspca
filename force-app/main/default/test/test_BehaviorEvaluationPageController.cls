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


        Test.startTest();
        //Animal__c A = [SELECT Id, name from Animal__c WHERE Id = 'a077j000001VVm6AAG'];
        String initials = 'LB';
        Behavior_Evaluation__c evaluation = new Behavior_Evaluation__c();
        evaluation.Behavior_in_Kennel__c = 'Social';
        evaluation.Animal__c = Id.valueOf('a077j000001VVm6AAG');
        evaluation.Scribe_Initials__c = initials;
        evaluation.Tester_Initials__c = initials;
        evaluation.Handler_Initials__c = initials;
        evaluation.Comments_BIK__c = 'AAAAAAAAAAAAAAAAAAA';
        evaluation.Evaluation_Subtype__c = 'Puppy';
        insert evaluation;
        BehaviorEvaluationPageController controller = new BehaviorEvaluationPageController();
        Behavior_Evaluation__c testGetter = BehaviorEvaluationPageController.getOne(evaluation.Id);
        List<EvaluationWrapper> allWrappers = new List<EvaluationWrapper>();
        allWrappers.add(BehaviorEvaluationPageController.getBehaviorInKennel(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getBehaviorOnLeash(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getSocialBehaviorTestOne(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getSocialBehaviorTestTwo(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPleasantTouchTest(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getUnpleasantTouchTestOne(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPlayTestPartOne(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPlayTestPartTwo(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getTagTest(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getResourceGuardingOnePF(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getResourceGuardingOneTF(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getResourceGuardingOneTN(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getResourceGuardingOneTB(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getResourceGuardingTwo(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getResourceGuardingTF(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getResourceGuardingTwoTB(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getResourceGuardingTwoTN(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getToddlerDollTestOne(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getToddlerDollTestTwo(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getScoldingPersonTestOne(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getScoldingPersonTestTwo(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getFakeDogTest(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getSameSexDogTestOne(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getSameSexDogTestTwo(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getSameSexDogTestThree(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getOppositeSexDogTestOne(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getOppositeSexDogTestTwo(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getOppositeSexDogTestThree(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPuppyBehaviorInKennel(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPuppyBehaviorOnLeash(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPuppyChildDollOne(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPuppyChildDollTwo(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPuppySocialBehaviorPart1(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPuppySocialBehaviorPart2(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPuppyPlayTestTugTug(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPuppyPlayTestTugP1(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPuppyPlayTestTugP2(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPuppyRestraint(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPuppyResourceGuardingPartOne(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPuppyResourceGuardingPartTwo(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPuppyChildDollTwo(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPuppyChildDollTwo(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPuppyDogInteractionOne(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPuppyDogInteractionTwo(evaluation.Id));
        allWrappers.add(BehaviorEvaluationPageController.getPuppyDogInteractionThree(evaluation.Id));

        evaluation.Caution__c = true;
        Boolean status = BehaviorEvaluationPageController.getCautionStatus(evaluation.Id);

        Map<String, Object> updateEvalTest = BehaviorEvaluationPageController.updateEval('Comments_BIK__c',
                'Social', String.valueOf(evaluation.Id));
        Map<String, Object> selectionsTest = BehaviorEvaluationPageController.putSelections('Behavior_In_Kennel__c',
                String.valueOf('Social, Not Social').split(','), String.valueOf(evaluation.Id));
        Map<String,Object> validityTest = BehaviorEvaluationPageController.handleValidity(String.valueOf(evaluation.Id));
        List<EvaluationWrapper.ListItems> items = BehaviorEvaluationPageController.getSkipReasons(1);
        System.assertNotEquals(items, null);
        System.assertNotEquals(allWrappers, null);
        System.assertNotEquals(updateEvalTest, null);
        System.assertNotEquals(selectionsTest, null);
        System.assertNotEquals(validityTest, null);
        Test.stopTest();
    }

    @IsTest
    static void adultCoverage() {
        Test.startTest();
        String initials = 'LB';
        Behavior_Evaluation__c evaluation = new Behavior_Evaluation__c();
        evaluation.Behavior_in_Kennel__c = 'Social';
        evaluation.Animal__c = Id.valueOf('a077j000001VVm6AAG');
        evaluation.Scribe_Initials__c = initials;
        evaluation.Tester_Initials__c = initials;
        evaluation.Handler_Initials__c = initials;
        evaluation.Comments_BIK__c = 'AAAAAAAAAAAAAAAAAAA';
        evaluation.Evaluation_Subtype__c = 'Adult Animal';
        insert evaluation;
        BehaviorEvaluationPageController controller = new BehaviorEvaluationPageController();
        Behavior_Evaluation__c testGetter = BehaviorEvaluationPageController.getOne(evaluation.Id);

        Map<String,Object> validityTest = BehaviorEvaluationPageController.handleValidity(String.valueOf(evaluation.Id));
        Test.stopTest();

    }
    @IsTest
    static void dogFightingCoverage() {
        Test.startTest();
        String initials = 'LB';
        Behavior_Evaluation__c evaluation = new Behavior_Evaluation__c();
        evaluation.Behavior_in_Kennel__c = 'Social';
        evaluation.Animal__c = Id.valueOf('a077j000001VVm6AAG');
        evaluation.Scribe_Initials__c = initials;
        evaluation.Tester_Initials__c = initials;
        evaluation.Handler_Initials__c = initials;
        evaluation.Comments_BIK__c = 'AAAAAAAAAAAAAAAAAAA';
        evaluation.Evaluation_Subtype__c = 'Dog Fighting';
        insert evaluation;
        BehaviorEvaluationPageController controller = new BehaviorEvaluationPageController();
        Behavior_Evaluation__c testGetter = BehaviorEvaluationPageController.getOne(evaluation.Id);

        Map<String,Object> validityTest = BehaviorEvaluationPageController.handleValidity(String.valueOf(evaluation.Id));
        Test.stopTest();

    }


}