public class BehaviorEvalMetadataCollection {
    
    public class FlowInputs {
        @InvocableVariable public String EvalId;
    }     
    
    @InvocableMethod(label='Get Behavior Evaluation Metadata' description='Assigns values from comment and skip fields to collection, along with the subtest name' /*category= 'Account'*/)
    
    
    public static List<List<String>> getListOfStrings(List<FlowInputs> request){
        
        String EvalId = request[0].EvalId;
        Behavior_Evaluation__c behaviorEvaluation = [SELECT
                                                     Comments_BIK__c,
                                                     Comments_BOL__c,
                                                     Comments_FD__c,
                                                     Comments_OSD_P1__c,
                                                     Comments_OSD_P2__c,
                                                     Comments_OSD_P3__c,
                                                     Comments_Play_Tug_P1__c,
                                                     Comments_Play_Tug_P2__c,
                                                     Comments_Pleasant_Touch__c,
                                                     Comments_RG_P1__c,
                                                     Comments_RG_P2__c,
                                                     Comments_SB_P1__c,
                                                     Comments_SB_P2__c,
                                                     Comments_SP_P1__c,
                                                     Comments_SP_P2__c,
                                                     Comments_SSD_P1__c,
                                                     Comments_SSD_P2__c,
                                                     Comments_SSD_P3__c,
                                                     Comments_Tag__c,
                                                     Comments_TD_P1__c,
                                                     Comments_TD_P2__c,
                                                     Comments_UT__c,
                                                     Comments_UT_1st__c,
                                                     Comments_UT_2nd__c,
                                                     Puppy_Comments_CD_P1__c,
                                                     Puppy_Comments_CD_P2__c,
                                                     Puppy_Comments_DI_P1__c,
                                                     Puppy_Comments_DI_P2__c,
                                                     Puppy_Comments_DI_P3__c,
                                                     Puppy_Comments_Restraint__c,
                                                     Skipped_BIK__c,
                                                     Puppy_Skipped_CD_P1__c,
                                                     Puppy_Skipped_CD_P2__c,
                                                     Puppy_Skipped_DI_P1__c,
                                                     Puppy_Skipped_DI_P2__c,
                                                     Puppy_Skipped_DI_P3__c,
                                                     Puppy_Skipped_Restraint__c,
                                                     Skipped_BOL__c,
                                                     Skipped_FD__c,
                                                     Skipped_OSD_P1__c,
                                                     Skipped_OSD_P2__c,
                                                     Skipped_OSD_P3__c,
                                                     Skipped_Play_Tug_P1__c,
                                                     Skipped_Play_Tug_P2__c,
                                                     Skipped_Pleasant__c,
                                                     Skipped_Pleasant_Touch__c,
                                                     Skipped_RG_P1__c,
                                                     Skipped_RG_P1_PF__c,
                                                     Skipped_RG_P1_TB__c,
                                                     Skipped_RG_P1_TF__c,
                                                     Skipped_RG_P1_TN__c,
                                                     Skipped_RG_P2__c,
                                                     Skipped_RG_P2_PF__c,
                                                     Skipped_RG_P2_TB__c,
                                                     Skipped_RG_P2_TF__c,
                                                     Skipped_RG_P2_TN__c,
                                                     Skipped_SB_P1__c,
                                                     Skipped_SB_P2__c,
                                                     Skipped_SP_P1__c,
                                                     Skipped_SP_P2__c,
                                                     Skipped_SSD_P1__c,
                                                     Skipped_SSD_P2__c,
                                                     Skipped_SSD_P3__c,
                                                     Skipped_Tag__c,
                                                     Skipped_TD_P1__c,
                                                     Skipped_TD_P2__c,
                                                     Skipped_UT_1st__c,
                                                     Skipped_UT_2nd__c,
                                                     Resource_Guarding_P2_Push_Face__c,
                                                     Puppy_Resource_Guarding_P1_Touch_Face__c,
                                                     Resource_Guarding_P1_Touch_Neck__c,
                                                     Puppy_Dog_Interaction_P2__c,
                                                     Puppy_Child_Doll_P1__c,
                                                     Puppy_Child_Doll_P2__c,
                                                     Puppy_Play_Tag__c,
                                                     Same_Sex_P2__c,
                                                     Resource_Guarding_P2_Touch_Neck__c,
                                                     Behavior_on_Leash__c,
                                                     Resource_Guarding_P1_Push_Face__c,
                                                     Opposite_Sex_P2__c,
                                                     Puppy_Resource_Guarding_P2_Touch_Face__c,
                                                     Puppy_Resource_Guarding_P2_Touch_Neck__c,
                                                     Toddler_Doll_P2__c,
                                                     Puppy_Resource_Guarding_P1_Touch_Body__c,
                                                     Same_Sex_P1__c,
                                                     Opposite_Sex_P1__c,
                                                     Puppy_Resource_Guarding_P1_Push_Face__c,
                                                     Fake_Dog__c,
                                                     Opposite_Sex_P3__c,
                                                     Resource_Guarding_P1_Touch_Face__c,
                                                     Same_Sex_P3__c,
                                                     Puppy_Dog_Interaction_P3__c,
                                                     Resource_Guarding_P1_Touch_Body__c,
                                                     Puppy_Resource_Guarding_P2_Push_Face__c,
                                                     Resource_Guarding_P2_Touch_Body__c,
                                                     Toddler_Doll_P1__c,
                                                     Puppy_Dog_Interaction_P1__c,
                                                     Scolding_Person_P1__c,
                                                     Puppy_Resource_Guarding_P1_Touch_Neck__c,
                                                     Puppy_Resource_Guarding_P2_Touch_Body__c,
                                                     Resource_Guarding_P2_Touch_Face__c,
                                                     Scolding_Person_P2__c,
                                                     Puppy_Behavior_on_Leash__c,
                                                     Evaluation_Subtype__c
                                                     
                                                     FROM Behavior_Evaluation__c WHERE Id = :EvalId];
        
        Map<String, Object> fieldsToValue = behaviorEvaluation.getPopulatedFieldsAsMap();
        String testAndResponse;
        List<String> stringList = new List<String>(); 
        List<List<String>> listOfStringLists = new List<List<String>>();
        
        Boolean evalType = False;
        if (behaviorEvaluation.Evaluation_Subtype__c == 'Puppy'){
            evalType = True;
        }
        system.debug('evaltype: '+evaltype);
        
        for (String fieldName : fieldsToValue.keySet()){
            //            System.debug('field name is ' + fieldName + ', value is ' + fieldsToValue.get(fieldName));
            String response = (String)fieldsToValue.get(fieldName);
            system.debug('field name: '+fieldName+' response: '+response);
            
            if(fieldName.contains('Skipped')){
                //Query on Skipped fields
                system.debug('fieldName: '+fieldName+' IF SKIPPED');
                for (Test_Config__mdt testSkippedMetadata : [SELECT Test_Skip_Reason_Field__c,MasterLabel,Test_Name__c,IsPuppy__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                                             WHERE Test_Skip_Reason_Field__c =:fieldName AND IsPuppy__c =:evalType LIMIT 1 ]){
                                                                 String testName = '';
                                                                 if (testSkippedMetadata.Overall_Test_Display_Name__c != null){
                                                                     testName = testSkippedMetadata.Overall_Test_Display_Name__c;
                                                                 }
                                                                 else{
                                                                     testName = testSkippedMetadata.Test_Name__c;
                                                                 }
                                                                 testAndResponse = testName + ': ' + response;
                                                                 stringList.add(testAndResponse);
                                                                 testName = null;
                                                                 testAndResponse = null;
                                                                 
                                                             }
                
            } else if(fieldName.contains('Comments')){
                //Query on Comment fields
                system.debug('fieldName: '+fieldName+' IF COMMENTS');
                for (Test_Config__mdt testCommentMetadata : [SELECT Test_Comment_Field_Name__c,MasterLabel,Test_Name__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                                             WHERE Test_Comment_Field_Name__c = :fieldName AND IsPuppy__c =:evalType LIMIT 1 ]){
                                                                 String testName = '';
                                                                 if (testCommentMetadata.Overall_Test_Display_Name__c != null){
                                                                     testName = testCommentMetadata.Overall_Test_Display_Name__c;
                                                                 }
                                                                 else{
                                                                     testName = testCommentMetadata.Test_Name__c;
                                                                 }
                                                                 
                                                                 testAndResponse = testName + ': ' + response;
                                                                 stringList.add(testAndResponse);
                                                                 system.debug('COMMENTS test and response: '+stringList);
                                                                 //listOfStringLists.add(stringList);
                                                                 //stringList.clear();
                                                                 //stringList = new List<String>();
                                                                 system.debug('COMMENTS test and response LIST: '+listOfStringLists);
                                                                 
                                                                 testName = null;
                                                                 testAndResponse = null;
                                                             }  
                
            } else {
                List<String> behArray = response.split(';');
                for (String beh : behArray){
                    for (Picklist_Description_Config__mdt picklistMetadata : [SELECT Test_Config__r.MasterLabel,Field_API_Name__c,Value_Category__c,Field_Value__c FROM Picklist_Description_Config__mdt
                                                                              WHERE Field_API_Name__c = :fieldName AND Field_Value__c = :beh LIMIT 1 ]){
                                                                                  if (picklistMetadata.Value_Category__c == '4'){
                                                                                      String testName = picklistMetadata.Test_Config__r.MasterLabel;
                                                                                      if (testName.contains('Puppy')){
                                                                                          testName = testName.substring(6);
                                                                                      }
                                                                                      testAndResponse = testName + ': ' + beh;
                                                                                      stringList.add(testAndResponse);
                                                                                  }
                                                                              }
                    
                }
            }
            
            
            
            
        }
        
        listOfStringLists.add(stringList);
        system.debug(listOfStringLists.size());
        return listOfStringLists;
    }
    
    
    
}