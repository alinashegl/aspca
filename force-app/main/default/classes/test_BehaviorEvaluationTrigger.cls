/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class test_BehaviorEvaluationTrigger {

    @isTest
    static void behaviorEvaluationInsert() {
        Test.startTest();
        List<Behavior_Evaluation__c> evaluations = TestDataFactory.createMultipleBehaviorEvaluation(5, 'Puppy');
        Test.stopTest();
        System.assertEquals(5, evaluations.size());
        List<Behavior_Evaluation__c> afterInsert = [SELECT Id, Behavior_Evaluation_Summary__c FROM Behavior_Evaluation__c WHERE Evaluation_Subtype__c = 'Puppy'];
        System.assertEquals(5, afterInsert.size());
        for (Behavior_Evaluation__c b : afterInsert) {
            System.assert(b.Behavior_Evaluation_Summary__c != null);
        }
    }

    @isTest
    static void behaviorEvaluationUpdateSummary() {
        List<Behavior_Evaluation__c> evaluations = TestDataFactory.createMultipleBehaviorEvaluation(2, 'Dog Fighting');
        Test.startTest();
        evaluations[0].Comments_BIK__c = 'Comment added for kennel';
        evaluations[1].Comments_BOL__c = 'Comment added for leash';
        update evaluations;
        Test.stopTest();
        Behavior_Evaluation__c afterUpdate1 = [SELECT Id, Behavior_Evaluation_Summary__c, Comments_BIK__c FROM Behavior_Evaluation__c WHERE Id = :evaluations[0].Id LIMIT 1];
        Behavior_Evaluation__c afterUpdate2 = [SELECT Id, Behavior_Evaluation_Summary__c, Comments_BOL__c FROM Behavior_Evaluation__c WHERE Id = :evaluations[1].Id LIMIT 1];
        System.assertEquals('Comment added for kennel', afterUpdate1.Comments_BIK__c);
        System.assertEquals('Comment added for leash', afterUpdate2.Comments_BOL__c);
    }
    
    @isTest
    static void behaviorEvaluationUpdateNoSummary() {
        List<Behavior_Evaluation__c> evaluations = TestDataFactory.createMultipleBehaviorEvaluation(2, 'Dog Fighting');
        evaluations[0].Behavior_Evaluation_Summary__c = null;
        evaluations[1].Behavior_Evaluation_Summary__c = ' ';
        update evaluations;

        Test.startTest();
        evaluations[0].Comments_BIK__c = 'Comment added for kennel';
        evaluations[1].Comments_BOL__c = 'Comment added for leash';
        update evaluations;
        Test.stopTest();

        Behavior_Evaluation__c afterUpdate1 = [SELECT Id, Behavior_Evaluation_Summary__c, Comments_BIK__c FROM Behavior_Evaluation__c WHERE Id = :evaluations[0].Id LIMIT 1];
        Behavior_Evaluation__c afterUpdate2 = [SELECT Id, Behavior_Evaluation_Summary__c, Comments_BOL__c FROM Behavior_Evaluation__c WHERE Id = :evaluations[1].Id LIMIT 1];
        System.assertEquals('Comment added for kennel', afterUpdate1.Comments_BIK__c);
        System.assertEquals(true, afterUpdate1.Behavior_Evaluation_Summary__c.contains('Comment added for kennel'));
        System.assertEquals('Comment added for leash', afterUpdate2.Comments_BOL__c);
        System.assertEquals(true, afterUpdate2.Behavior_Evaluation_Summary__c.contains('Comment added for leash'));
    }

    @isTest
    static void behaviorEvaluationUpdateAggression() {
        List<Behavior_Evaluation__c> evaluations = TestDataFactory.createMultipleBehaviorEvaluation(1, 'Dog Fighting');
        Test.startTest();
        evaluations[0].Overall_Evaluation_Grade__c = 'D - Dog Aggression';
        evaluations[0].Grade_Change_Reason__c = 'D - Dog Aggression';
        update evaluations;
        Test.stopTest();
        Behavior_Evaluation__c afterUpdate = [
            SELECT Id, Animal__c, Behavior_Evaluation_Summary__c, Skipped_OSD_P1__c, Skipped_OSD_P2__c, Skipped_OSD_P3__c, Skipped_SSD_P1__c, Skipped_SSD_P2__c, Skipped_SSD_P3__c 
            FROM Behavior_Evaluation__c 
            WHERE Id = :evaluations[0].Id LIMIT 1
        ];
                
        System.assertEquals('Skipped due to risk to the helper dog', afterUpdate.Skipped_OSD_P1__c);
        System.assertEquals('Skipped due to risk to the helper dog', afterUpdate.Skipped_OSD_P2__c);
        System.assertEquals('Skipped due to risk to the helper dog', afterUpdate.Skipped_OSD_P3__c);
        System.assertEquals('Skipped due to risk to the helper dog', afterUpdate.Skipped_SSD_P1__c);
        System.assertEquals('Skipped due to risk to the helper dog', afterUpdate.Skipped_SSD_P2__c);
        System.assertEquals('Skipped due to risk to the helper dog', afterUpdate.Skipped_SSD_P3__c);
    }

    @isTest
    static void behaviorEvaluationUpdateHighValue() {
        List<Behavior_Evaluation__c> evaluations = TestDataFactory.createMultipleBehaviorEvaluation(1, 'Adult Animal');
        Test.startTest();
        evaluations[0].Tag_Test__c = 'Played with tester;Too fearful-subtest not done';
        evaluations[0].Behavior_on_Leash__c = 'Too fearful-subtest not done';
        evaluations[0].Resource_Guarding_P1_Push_Face__c = 'Too fearful';
        update evaluations;
        Test.stopTest();
        Behavior_Evaluation__c afterUpdate = [SELECT Id, Behavior_Evaluation_Summary__c, Tag_Test__c, Behavior_on_Leash__c, Resource_Guarding_P1_Push_Face__c FROM Behavior_Evaluation__c WHERE Id = :evaluations[0].Id LIMIT 1];
        System.assertEquals('Played with tester;Too fearful-subtest not done', afterUpdate.Tag_Test__c);
        System.assertEquals('Too fearful-subtest not done', afterUpdate.Behavior_on_Leash__c);
        System.assertEquals('Too fearful', afterUpdate.Resource_Guarding_P1_Push_Face__c);
    }

    @isTest
    static void behaviorEvaluationUpdateDoubleHighValue() {
        List<Behavior_Evaluation__c> evaluations = TestDataFactory.createMultipleBehaviorEvaluation(1, 'Adult Animal');
        Test.startTest();
        evaluations[0].Tag_Test__c = 'Played with tester;Too fearful-subtest not done';
        update evaluations;
        evaluations[0].Tag_Test__c = 'Played with tester';
        update evaluations;
        evaluations[0].Tag_Test__c = 'Played with tester;Too fearful-subtest not done';
        update evaluations;
        Test.stopTest();
        Behavior_Evaluation__c afterUpdate = [SELECT Id, Behavior_Evaluation_Summary__c, Tag_Test__c, Behavior_on_Leash__c, Resource_Guarding_P1_Push_Face__c FROM Behavior_Evaluation__c WHERE Id = :evaluations[0].Id LIMIT 1];
        System.assertEquals('Played with tester;Too fearful-subtest not done', afterUpdate.Tag_Test__c);
    }

    @isTest
    static void behaviorEvaluationUpdateNoType() {
        List<Behavior_Evaluation__c> evaluations = TestDataFactory.createMultipleBehaviorEvaluation(1, 'Adult Animal');
        Test.startTest();
        evaluations[0].Behavior_in_Kennel__c = 'Social';
        evaluations[0].Behavior_Evaluation_Summary__c = null;
        update evaluations;
        Test.stopTest();
        Behavior_Evaluation__c afterUpdate = [SELECT Id, Behavior_Evaluation_Summary__c, Behavior_in_Kennel__c FROM Behavior_Evaluation__c WHERE Id = :evaluations[0].Id LIMIT 1];
        System.assertEquals('Social', afterUpdate.Behavior_in_Kennel__c);
    }

    @isTest
    static void classWrapperTest() {
        Test.startTest();
        SummaryWrapper sw1 = new SummaryWrapper();
        sw1.labelOrder = 3;
        sw1.labelValue = 'Third';
        SummaryWrapper sw2 = new SummaryWrapper();
        sw2.labelOrder = 1;
        sw2.labelValue = 'First';
        SummaryWrapper sw3 = new SummaryWrapper(2, 'Second');
        List<SummaryWrapper> swList = new List<SummaryWrapper>{sw1, sw2, sw3};
        swList.sort();
        CommentSkipWrapper csw1 = new CommentSkipWrapper();
        csw1.testName = 'Test1';
        csw1.commentField = 'Comment1';
        csw1.skipField = 'Skip1';
        CommentSkipWrapper csw2 = new CommentSkipWrapper('Test2', 'Comment2', 'Skip2');
        HighValueCategoryWrapper hvcw1 = new HighValueCategoryWrapper();
        hvcw1.fieldApiName = 'Name1';
        hvcw1.fieldValue = 'Value1';
        hvcw1.testName = 'Test1';
        HighValueCategoryWrapper hvcw2 = new HighValueCategoryWrapper('Name2', 'Value2', 'Test2');
        Test.stopTest();
        for (Integer i = 0; i < swList.size(); i++) {
            System.assertEquals(i + 1, swList[i].labelOrder);
        }
        System.assertEquals('Test1', csw1.testName);
        System.assertEquals('Comment1', csw1.commentField);
        System.assertEquals('Skip1', csw1.skipField);
        System.assertEquals('Test2', csw2.testName);
        System.assertEquals('Comment2', csw2.commentField);
        System.assertEquals('Skip2', csw2.skipField);
        System.assertEquals('Name1', hvcw1.fieldApiName);
        System.assertEquals('Value1', hvcw1.fieldValue);
        System.assertEquals('Test1', hvcw1.testName);
        System.assertEquals('Name2', hvcw2.fieldApiName);
        System.assertEquals('Value2', hvcw2.fieldValue);
        System.assertEquals('Test2', hvcw2.testName);
    }
}