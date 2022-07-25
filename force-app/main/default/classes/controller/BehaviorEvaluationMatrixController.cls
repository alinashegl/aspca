public class BehaviorEvaluationMatrixController {

    public Behavior_Evaluation__c behaviorEvaluation {get;set;}
    public list<Picklist_Description_Config__mdt> picklistMetadata {get;set;}
    public Map<String, Object> fieldsToValue {get;set;}
    public Map<String,Set<Integer>> testAndValues {get;set;}  
    public Map<String,List<String>> testAndDisplayValues {get;set;}
    public List<List<String>> finalTestAndDisplayValues {get;set;}
    public Map<Integer,String> testOrder {get;set;}
    
    public BehaviorEvaluationMatrixController (ApexPages.StandardController controller){
        behaviorEvaluation = [select 
                              Name,
                              Puppy_Dog_Interaction_P3__c,
                              Puppy_Dog_Interaction_P2__c,
                              Puppy_Dog_Interaction_P1__c,
                              Puppy_Social_Behavior_P2__c,
                              Puppy_Restraint__c,
                              Puppy_Play_Tag__c,
                              Toddler_Doll_P2__c,
                              Toddler_Doll_P1__c,
                              Tag_Test__c,
                              Social_Behavior_P2_2__c,
                              Social_Behavior_P1__c,
                              Unpleasant_Touch_2nd__c,
                              Unpleasant_Touch_1st__c,
                              Scolding_Person_P2__c,
                              Scolding_Person_P1__c,
                              Same_Sex_P3__c,
                              Same_Sex_P2__c,
                              Same_Sex_P1__c,
                              Resource_Guarding_P2_Touch_Neck__c,
                              Resource_Guarding_P2_Touch_Face__c,
                              Resource_Guarding_P2_Touch_Body__c,
                              Resource_Guarding_P2_Push_Face__c,
                              Resource_Guarding_P1_Touch_Neck__c,
                              Resource_Guarding_P1_Touch_Face__c,
                              Resource_Guarding_P1_Touch_Body__c,
                              Resource_Guarding_P1_Push_Face__c,
                              Pleasant_Touch__c,
                              Play_Test_Tug_P2__c,
                              Play_Test_Tug_P1__c,
                              Opposite_Sex_P3__c,
                              Opposite_Sex_P2__c,
                              Behavior_on_Leash__c,
                              Opposite_Sex_P1__c,
                              Behavior_in_Kennel__c,
                              Fake_Dog__c,
                              Potential_Behavior_Issues__c,
                              Puppy_Resource_Guarding_P2_Touch_Neck__c,
                              Puppy_Resource_Guarding_P2_Touch_Face__c,
                              Puppy_Resource_Guarding_P2_Touch_Body__c,
                              Puppy_Social_Behavior_P1__c,
                              Puppy_Resource_Guarding_P2_Push_Face__c,
                              Puppy_Resource_Guarding_P1_Touch_Neck__c,
                              Puppy_Resource_Guarding_P1_Touch_Face__c,
                              Puppy_Resource_Guarding_P1_Touch_Body__c,
                              Puppy_Resource_Guarding_P1_Push_Face__c,
                              Puppy_Play_Tug_P2__c,
                              Puppy_Play_Tug_P1__c,
                              Puppy_Child_Doll_P1__c,
                              Puppy_Child_Doll_P2__c,
                              Puppy_Behavior_on_Leash__c,
                              Puppy_Behavior_in_Kennel__c,
                              Skipped_UT_2nd__c,
                              Skipped_UT_1st__c,
                              Skipped_Tag__c,
                              Skipped_TD_P2__c,
                              Skipped_TD_P1__c,
                              Skipped_SSD_P3__c,
                              Skipped_SSD_P2__c,
                              Skipped_SSD_P1__c,
                              Skipped_SP_P2__c,
                              Skipped_SP_P1__c,
                              Skipped_SB_P2__c,
                              Skipped_SB_P1__c,
                              Skipped_RG_P2__c,
                              Skipped_RG_P2_TN__c,
                              Skipped_RG_P2_TF__c,
                              Skipped_RG_P2_TB__c,
                              Skipped_RG_P2_PF__c,
                              Skipped_RG_P1__c,
                              Skipped_RG_P1_TN__c,
                              Skipped_RG_P1_TF__c,
                              Skipped_RG_P1_TB__c,
                              Skipped_RG_P1_PF__c,
                              Skipped_Pleasant__c,
                              Skipped_Pleasant_Touch__c,
                              Skipped_Play_Tug_P2__c,
                              Skipped_Play_Tug_P1__c,
                              Skipped_OSD_P3__c,
                              Skipped_OSD_P2__c,
                              Skipped_OSD_P1__c,
                              Skipped_FD__c,
                              Skipped_BOL__c,
                              Skipped_BIK__c,
                              Evaluation_Subtype__c,
                              Social_Behavior_Test_P1__c,
                              Social_Behavior_P2__c,
                              Pleasant_Touch_Test__c,
                              Play_Test_P2__c,
                              Play_Test_P1__c,
                              Overall_Evaluation_Grade__c,                                                           
                              Puppy_Skipped_Restraint__c,                                                                                                                    
                                                      
                              Puppy_Skipped_DI_P3__c,
                              Puppy_Skipped_DI_P2__c,
                              Puppy_Skipped_DI_P1__c,
                              Puppy_Skipped_CD_P2__c,
                              Puppy_Skipped_CD_P1__c,                              
                              Puppy_BIK_Housing__c
                              FROM Behavior_Evaluation__c
                              WHERE Id = :ApexPages.currentPage().getparameters().get('Id')];
        system.debug(behaviorEvaluation);
        
        Boolean evalType = False;
        if (behaviorEvaluation.Evaluation_Subtype__c == 'Puppy'){
            evalType = True;
        }
        
        //Create map of field names and their corresponding values
        fieldsToValue = behaviorEvaluation.getPopulatedFieldsAsMap();
        
        testAndValues = new Map<String,Set<Integer>>(); //Map to collect subtest names and corresponding behaviors
        testAndDisplayValues = new Map<String,List<String>>(); //Temp Map to collect subtest names and corresponding categories in correct order
        testOrder = new Map<Integer,String>(); //Map to order tests
        finalTestAndDisplayValues = new List<List<String>>(); //Map of ordered subtests along with categories
        
        //Iterate through fields and values
        for (String fieldName : fieldsToValue.keySet()){
            //System.debug('field name is ' + fieldName + ', value is ' + fieldsToValue.get(fieldName));
            
            //Assign field values to behaviors String
            String behaviors = (String)fieldsToValue.get(fieldName);
            String skipped = '❌';
            String notNecessary = '---';

            //Iterate through Skipped fields to pull out skip reason
            if (fieldName.contains('Skipped')){
                List<Test_Config__mdt> testConfigSkip = new List<Test_Config__mdt>();
                switch on behaviorEvaluation.Evaluation_SubType__c {
                    when 'Puppy' {
                        testConfigSkip = [SELECT Test_Name__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                        WHERE Test_Skip_Reason_Field__c = :fieldName AND IsPuppy__c = true LIMIT 1];
                    }
                    when 'Adult Animal' {
                        testConfigSkip = [SELECT Test_Name__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                        WHERE Test_Skip_Reason_Field__c = :fieldName AND IsAdult__c = true LIMIT 1];
                    }
                    when 'Dog Fighting' {
                        testConfigSkip = [SELECT Test_Name__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                        WHERE Test_Skip_Reason_Field__c = :fieldName AND IsDogFighting__c = true LIMIT 1];
                    }
                    when 'Dog/Dog Only' {
                        testConfigSkip = [SELECT Test_Name__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                        WHERE Test_Skip_Reason_Field__c = :fieldName AND IsDogOnly__c = true LIMIT 1];
                    }
                }
                
                if(testConfigSkip.size() > 0){
                    for (Test_Config__mdt testMetadata : testConfigSkip){
                        // for (Test_Config__mdt testMetadata : [SELECT Test_Skip_Reason_Field__c,MasterLabel,IsPuppy__c,Test_Name__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                        //                                       WHERE Test_Skip_Reason_Field__c = :fieldName AND IsPuppy__c = :evalType LIMIT 1 ]){
                        String testName = '';
                        if (testMetadata.Overall_Test_Display_Name__c != null){
                            testName = testMetadata.Overall_Test_Display_Name__c;
                        }
                        else{
                            testName = testMetadata.Test_Name__c;
                        }
                        
                        if(behaviors.contains('not necessary') || behaviors.contains('appropriate helper dog')){
                            testAndDisplayValues.put(testName, new List<String>{'---','---','---','---'});
                        } else{
                            testAndDisplayValues.put(testName, new List<String>{'❌','❌','❌','❌'});
                        }
                        
                    }
                }
                //system.debug('WITHIN SKIPPED IF: ' + testAndDisplayValues);
            }
            else{
                //system.debug('AFTER SKIPPED IF: ' + testAndDisplayValues);
                //system.debug(behaviors);
                
                //Split values for multi-select picklist fields and assign to array
                List<String> behArray = behaviors.split(';');
                
                //Iterate through array to categorize each selection into a numeric value, based on Value Category
                for (String beh : behArray){
                    
                    for (Picklist_Description_Config__mdt picklistMetadata : [SELECT Test_Config__r.MasterLabel,Test_Config__r.Test_Name__c,Field_API_Name__c,Value_Category__c,Field_Value__c FROM
                            Picklist_Description_Config__mdt
                                                                              WHERE Field_API_Name__c = :fieldName AND Field_Value__c = :beh LIMIT 1 ]){
                        //Assign Value Category String value to Integer
                        Integer valueCategory = Integer.valueOf(picklistMetadata.Value_Category__c);
                        
                        //If testAndValues map does not contain current subtest, create new key-value set for Subtest name and Value Category
                        if(!testAndValues.containsKey(picklistMetadata.Test_Config__r.Test_Name__c)){
                            testAndValues.put(picklistMetadata.Test_Config__r.Test_Name__c, new Set<Integer>{valueCategory});
                        }
                        //If testAndValues map already contains current subtest, add Value Category to the corresponding key
                        else{
                            testAndValues.get(picklistMetadata.Test_Config__r.Test_Name__c).add(valueCategory);
                            
                        }
                        
                        //system.debug('MAP SIZE AFTER INSERT '+ testAndValues.size());
                        
                    }
                    
                }
                
            }
        } //END OF FOR LOOP
        
        
        //Iterate through Value Category Set in testAndValues Map and assign a category to each column, by adding them to a List
        //Categories: 1=Not Concerning, 2=Red Flag, 3=Alert, 4=Inconclusive
        for (String subtest : testAndValues.keySet()){
            for (Integer i = 0; i < 4; i++){
                if(!testAndDisplayValues.containsKey(subtest)){
                    testAndDisplayValues.put(subtest, new List<String>{});
                }
                //If subtest includes behavior in current category, display checkbox; else display blank
                if (testAndValues.get(subtest).contains(i+1)){
                    testAndDisplayValues.get(subtest).add('✔');
                }
                else{
                    testAndDisplayValues.get(subtest).add(' '); 
                }
                
            }
            
        } //END OF FOR LOOP
        
        
        // Iterate through subtests in testAndDisplayMap and order by Test_Display_Order__c
        // Add subtest and order combinations into testOrder Map
        for (String subtest : testAndDisplayValues.keySet()){
            List<Test_Config__mdt> testMetadata = new List<Test_Config__mdt>();
            switch on behaviorEvaluation.Evaluation_SubType__c {
                when 'Puppy' {
                    testMetadata = [SELECT Test_Display_Order__c,Test_Name__c FROM Test_Config__mdt
                                    WHERE Test_Name__c = :subtest AND IsPuppy__c = true LIMIT 1];
                }
                when 'Adult Animal' {
                    testMetadata = [SELECT Test_Display_Order__c,Test_Name__c FROM Test_Config__mdt
                                    WHERE Test_Name__c = :subtest AND IsAdult__c = true LIMIT 1];
                }
                when 'Dog Fighting' {
                    testMetadata = [SELECT Test_Display_Order__c,Test_Name__c FROM Test_Config__mdt
                                    WHERE Test_Name__c = :subtest AND IsDogFighting__c = true LIMIT 1];
                }
                when 'Dog/Dog Only' {
                    testMetadata = [SELECT Test_Display_Order__c,Test_Name__c FROM Test_Config__mdt
                                    WHERE Test_Name__c = :subtest AND IsDogOnly__c = true LIMIT 1];
                }
            }
            // List<Test_Config__mdt> testMetadata = [SELECT MasterLabel,Test_Display_Order__c,Test_Name__c,IsPuppy__c FROM Test_Config__mdt
            //                                        WHERE Test_Name__c = :subtest AND IsPuppy__c =:evalType LIMIT 1 ];
            //system.debug('testMetadata.MasterLabel ============' + testMetadata.Test_Name__c);
            if(testMetadata.size() != 0){
                testOrder.put(Integer.valueOf(testMetadata[0].Test_Display_Order__c), testMetadata[0].Test_Name__c);
            }
            else{
                List<Test_Config__mdt> overallTestMetadata = new List<Test_Config__mdt>();
                switch on behaviorEvaluation.Evaluation_SubType__c {
                    when 'Puppy' {
                        overallTestMetadata = [SELECT Test_Display_Order__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                            WHERE Overall_Test_Display_Name__c = :subtest AND IsPuppy__c = true LIMIT 1];
                    }
                    when 'Adult Animal' {
                        overallTestMetadata = [SELECT Test_Display_Order__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                            WHERE Overall_Test_Display_Name__c = :subtest AND IsAdult__c = true LIMIT 1];
                    }
                    when 'Dog Fighting' {
                        overallTestMetadata = [SELECT Test_Display_Order__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                            WHERE Overall_Test_Display_Name__c = :subtest AND IsDogFighting__c = true LIMIT 1];
                    }
                    when 'Dog/Dog Only' {
                        overallTestMetadata = [SELECT Test_Display_Order__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                            WHERE Overall_Test_Display_Name__c = :subtest AND IsDogOnly__c = true LIMIT 1];
                    }
                }
                // List<Test_Config__mdt> overallTestMetadata = [SELECT MasterLabel,Test_Display_Order__c,Test_Name__c,Overall_Test_Display_Name__c,IsPuppy__c FROM Test_Config__mdt
                //                                               WHERE Overall_Test_Display_Name__c = :subtest AND IsPuppy__c =:evalType LIMIT 1 ];
                if(overallTestMetadata.size() != 0) {
                    testOrder.put(Integer.valueOf(overallTestMetadata[0].Test_Display_Order__c), overallTestMetadata[0].Overall_Test_Display_Name__c);
                }
            }

        }
        
        
        
        //Order testAndDisplayValues map using testOrder, and adds test name and string list to finalTestAndDisplayValues list of lists
        List<Integer> aList = new List<Integer>();
        aList.addAll(testOrder.keySet());
        aList.sort();
        
        for(Integer a: aList)
        {
            for (String subtestList : testAndDisplayValues.keySet()){
                //system.debug('testOrder.get(a): '+testOrder.get(a));
                //system.debug('subtestList: '+subtestList);
                if (testOrder.get(a) == subtestList){
                    List<String> testList = new List<String>();
                    testList.add(subtestList);
                    testList.addAll(testAndDisplayValues.get(subtestList));
                    finalTestAndDisplayValues.add(testList);
                }
                
            }
            
            
            
            //System.debug( '::::::::::::: ' + testOrder.get(a)) ;
        }
        
        
        
        
        
        
        
        system.debug('FINAL LIST: ' + finalTestAndDisplayValues);
        
    }
    
    
    
    
    
}