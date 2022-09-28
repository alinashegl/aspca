@isTest
private class BehaviorEvaluationMatrixControllerTest{
    
    static testMethod void unitTest(){
        
        Case cs = new Case();
        insert cs;  
        
        Animal__c objAnimal = new Animal__c(Name='Test2846298359832', Case__c=cs.Id, Type_of_Animal__c = 'Dog', Gender__c = 'Unknown', Age__c = 'Unknown At Intake', Color__c = 'Black');
        insert objAnimal;
        
        Test.startTest();
        
        //Adult Animal Evaluation Test
        Behavior_Evaluation__c behEval = new Behavior_Evaluation__c(
            Animal__c = objAnimal.Id, 
            Evaluation_Subtype__c = 'Adult Animal', 
            Handler_Initials__c = 'TI', 
            Scribe_Initials__c = 'TI', 
            Tester_Initials__c = 'TI',
            Behavior_in_Kennel__c = 'Social;Hyperaroused', 
            Skipped_BOL__c = 'Skipped to safeguard welfare of the animal', 
            Skipped_SB_P1__c = 'Skipped not necessary', 
            Resource_Guarding_P1_Push_Face__c = 'Remained relaxed', 
            Comments_BOL__c='test test test', 
            Tag_Test__c='Too fearful-subtest not done', 
            Skipped_RG_P2_PF__c	= 'Skipped for medical reason'
        );
        insert behEval;
        
        PageReference pageRef = Page.BehaviorEvaluationMatrix;
        Test.setCurrentPage(pageRef);
        apexpages.currentpage().getparameters().put('Id' , behEval.id);
        
        
        
        BehaviorEvaluationMatrixController objBehMatrix  = new BehaviorEvaluationMatrixController (new ApexPages.StandardController(behEval));
        
		//Expected result:        
        //((Behavior in Kennel, ✔, ✔,  ,  ), (Behavior on Leash, ❌, ❌, ❌, ❌), (Social Behavior P1, ---, ---, ---, ---), (Resource Guarding P1 - PF, ✔,  ,  ,  ))
        
        System.assertEquals(5, objBehMatrix.finalTestAndDisplayValues.size());
        //system.debug(objBehMatrix.finalTestAndDisplayValues.size());
        
        //Dog Fighting Evaluation Test
        Behavior_Evaluation__c dogFightingBehEval = new Behavior_Evaluation__c(
            Animal__c = objAnimal.Id, 
            Evaluation_Subtype__c	= 'Dog Fighting', 
            Handler_Initials__c = 'TI', 
            Scribe_Initials__c = 'TI', 
            Tester_Initials__c = 'TI', 
            Behavior_in_Kennel__c = 'Social;Hyperaroused', 
            Skipped_BOL__c = 'Skipped to safeguard welfare of the animal', 
            Skipped_SB_P1__c = 'Skipped not necessary', 
            Resource_Guarding_P1_Push_Face__c = 'Remained relaxed', 
            Comments_BOL__c='test test test', 
            Tag_Test__c='Too fearful-subtest not done', 
            Skipped_RG_P2_PF__c	= 'Skipped for medical reason'
        );
        insert dogFightingBehEval;

        PageReference dogFightingPageRef = Page.BehaviorEvaluationMatrix;
        Test.setCurrentPage(dogFightingPageRef);
        apexpages.currentpage().getparameters().put('Id' , dogFightingBehEval.id);



        BehaviorEvaluationMatrixController dogFightingObjBehMatrix  = new BehaviorEvaluationMatrixController (new ApexPages.StandardController(dogFightingBehEval));

        //Expected result:        
        //((Behavior in Kennel, ✔, ✔,  ,  ), (Behavior on Leash, ❌, ❌, ❌, ❌), (Social Behavior P1, ---, ---, ---, ---), (Resource Guarding P1 - PF, ✔,  ,  ,  ))

        System.assertEquals(5, dogFightingObjBehMatrix.finalTestAndDisplayValues.size());
        
        //Puppy Evaluation Test
        Behavior_Evaluation__c puppyBehEval = new Behavior_Evaluation__c(
            Animal__c = objAnimal.Id, 
            Evaluation_Subtype__c = 'Puppy', 
            Handler_Initials__c = 'TI', 
            Scribe_Initials__c = 'TI', 
            Tester_Initials__c = 'TI', 
            Puppy_Behavior_in_Kennel__c = 'Social;Hyperaroused', 
            Skipped_BOL__c = 'Skipped to safeguard welfare of the animal', 
            Skipped_SB_P1__c = 'Skipped not necessary', 
            Puppy_Resource_Guarding_P1_Push_Face__c = 'Remained relaxed'
        );
        insert puppyBehEval;
        
        PageReference puppyPageRef = Page.BehaviorEvaluationMatrix;
        Test.setCurrentPage(puppyPageRef);
        apexpages.currentpage().getparameters().put('Id' , puppyBehEval.id);
        
        BehaviorEvaluationMatrixController puppyObjBehMatrix  = new BehaviorEvaluationMatrixController (new ApexPages.StandardController(puppyBehEval));
        
		//Expected result:        
        //((Behavior in Kennel, ✔, ✔,  ,  ), (Behavior on Leash, ❌, ❌, ❌, ❌), (Social Behavior P1, ---, ---, ---, ---), (Resource Guarding P1 - PF, ✔,  ,  ,  ))
        
        System.assertEquals(5, objBehMatrix.finalTestAndDisplayValues.size());
        //system.debug(objBehMatrix.finalTestAndDisplayValues.size());
        
        Test.stopTest();
        
        //system.debug(behEval);
        
        
    }
    
    //@isTest static void test
    
}