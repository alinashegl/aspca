@isTest 
private class LogHistoryTest {
    @isTest
    static void  getAnimalHistory() {
        Animal__c anim = TestDataFactory.createAnimal();

        test.startTest();
        anim.handling_instructions__c = 'update instructions';
        update anim;

        EntityHistory__c[] hisotryList = LogHistory.getAnimalHistory(
            anim.Id, 
            'Name', 
            '', 
            'Name', 
            'DESC'
        );

        test.stopTest();

        System.assertEquals(true, hisotryList.isEmpty());
    }

    @isTest
    static void  getBehaviorEvaluationHistory() {
        Behavior_Evaluation__c eval = TestDataFactory.createPuppyBehaviorEvaluation();


        test.startTest();
        eval.overall_evaluation_grade__c = 'A - No Concerns';
        eval.grade_change_reason__c = 'TO';
        update eval;

        EntityHistory__c[] hisotryList = LogHistory.getBehaviorEvaluationHistory(
            eval.Id, 
            'overall_evaluation_grade__c', 
            '', 
            'Name', 
            'DESC'
        );

        test.stopTest();

        System.assertEquals(true, hisotryList.isEmpty());
    }
}