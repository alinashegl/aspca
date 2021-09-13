/*
<apex:page standardController="Animal__c" extensions="BehEvalPdfController" renderAs="pdf" applyBodyTag="false">
<apex:page standardController="Behavior_Evaluation__c" renderAs="pdf" applyBodyTag="false">
*/
public class BehEvalPdfController {
    
    /*    public Animal__c objAnimal{get;set;}*/
    public Behavior_Evaluation__c behEval{get;set;}
    public List<Test_Config__mdt> testMetadata{get;set;}
    public List<Picklist_Description_Config__mdt> picklistMetadata{get;set;}
    public Boolean aNoConcern { get; set; }
    public Boolean bMildConcern { get; set; }
    public Boolean cModerateConcern { get; set; }
    public Boolean dSevereConcern { get; set; }
    public List<String> potentBehIssue { get; set; }
    public Map<String,String> testDescriptions {get; set;}
    public Map<String,String> picklistDescriptions {get; set;}

    public BehEvalPdfController(ApexPages.StandardController controller){
        
        behEval = [SELECT Id
                  , ANIMAL_AGE__C
                  , ANIMAL_BREED__C
                  , ANIMAL_COLOR__C
                  , ANIMAL_ID__C
                  , ANIMAL_NAME__C
                  , ANIMAL_SEX__C
                  , ANIMAL__C
                  , BEHAVIOR_EVALUATION_SUMMARY__C
                  , BEHAVIOR_IN_KENNEL__C
                  , BEHAVIOR_ON_LEASH__C
                  , CASE_NUMBER__C
                  , CAUTION__C
                  , COMMENTS_BIK__C
                  , COMMENTS_BOL__C
                  , COMMENTS_FD__C
                  , COMMENTS_OSD_P1__C
                  , COMMENTS_OSD_P2__C
                  , COMMENTS_OSD_P3__C
                  , COMMENTS_PLAY_TUG_P1__C
                  , COMMENTS_PLAY_TUG_P2__C
                  , COMMENTS_PLEASANT_TOUCH__C
                  , COMMENTS_RG_P1__C
                  , COMMENTS_RG_P2__C
                  , COMMENTS_SB_P1__C
                  , COMMENTS_SB_P2__C
                  , COMMENTS_SP_P1__C
                  , COMMENTS_SP_P2__C
                  , COMMENTS_SSD_P1__C
                  , COMMENTS_SSD_P2__C
                  , COMMENTS_SSD_P3__C
                  , COMMENTS_TD_P1__C
                  , COMMENTS_TD_P2__C
                  , COMMENTS_TAG__C
                  , COMMENTS_UT_1ST__C
                  , COMMENTS_UT_2ND__C
                  , COMMENTS_UT__C
                  , CREATEDBYID
                  , CREATEDDATE
                  , EVALUATION_BEHAVIOR_SUMMARY__C
                  , EVALUATION_DATE__C
                  , EVALUATION_SUBTYPE__C
                  , FACILITY_OUTCOME__C
                  , FAKE_DOG__C
                  , HANDLER_INITIALS__C
                  , ISDELETED
                  , IS_MUZZLED__C
                  , IS_SKIPPED__C
                  , LASTMODIFIEDBYID
                  , LASTMODIFIEDDATE
                  , MUZZLED_OSD_P3__C
                  , MUZZLED_SSD_P3__C
                  , NAME
                  , OPPOSITE_SEX_P1__C
                  , OPPOSITE_SEX_P2__C
                  , OPPOSITE_SEX_P3__C
                  , OVERALL_EVALUATION_GRADE__C
                  , PLAY_TEST_P1__C
                  , PLAY_TEST_P2__C
                  , PLAY_TEST_TUG_P1__C
                  , PLAY_TEST_TUG_P2__C
                  , PLEASANT_TOUCH_TEST__C
                  , PLEASANT_TOUCH__C
                  , POTENTIAL_BEH_ISS_OTHER__C
                  , POTENTIAL_BEHAVIOR_ISSUES__C
                  , PUPPY_BIK_HOUSING__C
                  , PUPPY_BEHAVIOR_IN_KENNEL__C
                  , PUPPY_BEHAVIOR_ON_LEASH__C
                  , PUPPY_CHILD_DOLL_P1__C
                  , PUPPY_CHILD_DOLL_P2__C
                  , PUPPY_COMMENTS_BIK__C
                  , PUPPY_COMMENTS_BOL__C
                  , PUPPY_COMMENTS_CD_P1__C
                  , PUPPY_COMMENTS_CD_P2__C
                  , PUPPY_COMMENTS_DI_P1__C
                  , PUPPY_COMMENTS_DI_P2__C
                  , PUPPY_COMMENTS_DI_P3__C
                  , PUPPY_COMMENTS_PLAY_TAG__C
                  , PUPPY_COMMENTS_PLAY_TUG_P1__C
                  , PUPPY_COMMENTS_PLAY_TUG_P2__C
                  , PUPPY_COMMENTS_RG_P1__C
                  , PUPPY_COMMENTS_RG_P2__C
                  , PUPPY_COMMENTS_RESTRAINT__C
                  , PUPPY_COMMENTS_SB_P1__C
                  , PUPPY_COMMENTS_SB_P2__C
                  , PUPPY_DOG_INTERACTION_P1__C
                  , PUPPY_DOG_INTERACTION_P2__C
                  , PUPPY_DOG_INTERACTION_P3__C
                  , PUPPY_MUZZLED_DI_P1__C
                  , PUPPY_MUZZLED_DI_P2__C
                  , PUPPY_MUZZLED_DI_P3__C
                  , PUPPY_PLAY_TAG__C
                  , PUPPY_PLAY_TUG_P1__C
                  , PUPPY_PLAY_TUG_P2__C
                  , PUPPY_RESOURCE_GUARDING_P1_PUSH_FACE__C
                  , PUPPY_RESOURCE_GUARDING_P1_TOUCH_BODY__C
                  , PUPPY_RESOURCE_GUARDING_P1_TOUCH_FACE__C
                  , PUPPY_RESOURCE_GUARDING_P1_TOUCH_NECK__C
                  , PUPPY_RESOURCE_GUARDING_P2_PUSH_FACE__C
                  , PUPPY_RESOURCE_GUARDING_P2_TOUCH_BODY__C
                  , PUPPY_RESOURCE_GUARDING_P2_TOUCH_FACE__C
                  , PUPPY_RESOURCE_GUARDING_P2_TOUCH_NECK__C
                  , PUPPY_RESTRAINT__C
                  , PUPPY_SKIPPED_BIK__C
                  , PUPPY_SKIPPED_BOL__C
                  , PUPPY_SKIPPED_CD_P1__C
                  , PUPPY_SKIPPED_CD_P2__C
                  , PUPPY_SKIPPED_DI_P1__C
                  , PUPPY_SKIPPED_DI_P2__C
                  , PUPPY_SKIPPED_DI_P3__C
                  , PUPPY_SKIPPED_PLAY_TAG__C
                  , PUPPY_SKIPPED_PLAY_TUG_P1__C
                  , PUPPY_SKIPPED_PLAY_TUG_P2__C
                  , PUPPY_SKIPPED_RG_P1_PF__C
                  , PUPPY_SKIPPED_RG_P1_TB__C
                  , PUPPY_SKIPPED_RG_P1_TF__C
                  , PUPPY_SKIPPED_RG_P1_TN__C
                  , PUPPY_SKIPPED_RG_P1__C
                  , PUPPY_SKIPPED_RG_P2_PF__C
                  , PUPPY_SKIPPED_RG_P2_TB__C
                  , PUPPY_SKIPPED_RG_P2_TF__C
                  , PUPPY_SKIPPED_RG_P2_TN__C
                  , PUPPY_SKIPPED_RG_P2__C
                  , PUPPY_SKIPPED_RESTRAINT__C
                  , PUPPY_SKIPPED_SB_P1__C
                  , PUPPY_SKIPPED_SB_P2__C
                  , PUPPY_SOCIAL_BEHAVIOR_P1__C
                  , PUPPY_SOCIAL_BEHAVIOR_P2__C
                  , RESOURCE_GUARDING_P1_PUSH_FACE__C
                  , RESOURCE_GUARDING_P1_TOUCH_BODY__C
                  , RESOURCE_GUARDING_P1_TOUCH_FACE__C
                  , RESOURCE_GUARDING_P1_TOUCH_NECK__C
                  , RESOURCE_GUARDING_P2_PUSH_FACE__C
                  , RESOURCE_GUARDING_P2_TOUCH_BODY__C
                  , RESOURCE_GUARDING_P2_TOUCH_FACE__C
                  , RESOURCE_GUARDING_P2_TOUCH_NECK__C
                  , SAME_SEX_P1__C
                  , SAME_SEX_P2__C
                  , SAME_SEX_P3__C
                  , SCOLDING_PERSON_P1__C
                  , SCOLDING_PERSON_P2__C
                  , SCRIBE_INITIALS__C
                  , SKIPPED_BIK__C
                  , SKIPPED_BOL__C
                  , SKIPPED_FD__C
                  , SKIPPED_OSD_P1__C
                  , SKIPPED_OSD_P2__C
                  , SKIPPED_OSD_P3__C
                  , SKIPPED_PLAY_TUG_P1__C
                  , SKIPPED_PLAY_TUG_P2__C
                  , SKIPPED_PLEASANT_TOUCH__C
                  , SKIPPED_PLEASANT__C
                  , SKIPPED_RG_P1_PF__C
                  , SKIPPED_RG_P1_TB__C
                  , SKIPPED_RG_P1_TF__C
                  , SKIPPED_RG_P1_TN__C
                  , SKIPPED_RG_P1__C
                  , SKIPPED_RG_P2_PF__C
                  , SKIPPED_RG_P2_TB__C
                  , SKIPPED_RG_P2_TF__C
                  , SKIPPED_RG_P2_TN__C
                  , SKIPPED_RG_P2__C
                  , SKIPPED_SB_P1__C
                  , SKIPPED_SB_P2__C
                  , SKIPPED_SP_P1__C
                  , SKIPPED_SP_P2__C
                  , SKIPPED_SSD_P1__C
                  , SKIPPED_SSD_P2__C
                  , SKIPPED_SSD_P3__C
                  , SKIPPED_TD_P1__C
                  , SKIPPED_TD_P2__C
                  , SKIPPED_TAG__C
                  , SKIPPED_UT_1ST__C
                  , SKIPPED_UT_2ND__C
                  , SOCIAL_BEHAVIOR_P1__C
                  , SOCIAL_BEHAVIOR_P2_2__C
                  , SOCIAL_BEHAVIOR_P2__C
                  , SOCIAL_BEHAVIOR_TEST_P1__C
                  , SUMMARY_TEST__C
                  , SYSTEMMODSTAMP
                  , TAG_TEST__C
                  , TESTER_INITIALS__C
                  , TODDLER_DOLL_P1__C
                  , TODDLER_DOLL_P2__C
                  , UNPLEASANT_TOUCH_1ST_FLANK__C
                  , UNPLEASANT_TOUCH_1ST__C
                  , UNPLEASANT_TOUCH_2ND_FLANK__C
                  , UNPLEASANT_TOUCH_2ND__C
                   FROM Behavior_Evaluation__c
                   WHERE Id = :ApexPages.currentPage().getparameters().get('Id')];

        //Breaks up Potential Behavior Issues multi-select into potentBehIssue list
        if(behEval.Potential_Behavior_Issues__c != null){
            system.debug('in the if statement');
            potentBehIssue = behEval.Potential_Behavior_Issues__c.split(';');
        }

        aNoConcern = behEval.Overall_Evaluation_Grade__c == 'A - No Concerns' ? true : false;

        bMildConcern = behEval.Overall_Evaluation_Grade__c == 'B - Mild Concern(s)' ? true : false;

        cModerateConcern = behEval.Overall_Evaluation_Grade__c == 'C - Moderate Concern(s)' ? true : false;

        dSevereConcern = behEval.Overall_Evaluation_Grade__c == 'D - Severe Concern(s)' ? true : false;

        Boolean evalType = False;
        if (behEval.Evaluation_Subtype__c == 'Puppy'){
            evalType = True;
        }

        picklistMetadata = new List<Picklist_Description_Config__mdt>();
        picklistDescriptions = new Map<String, String>();
        picklistMetadata = [SELECT Test_Config__r.MasterLabel,Test_Config__r.Test_Name__c,Test_Config__r.IsPuppy__c,Field_API_Name__c,Value_Category__c,Field_Value__c, Field_Description__c
                            FROM Picklist_Description_Config__mdt WHERE Field_Description__c!= null AND Test_Config__r.IsPuppy__c =: evalType];
        if(picklistMetadata != null){
            for (Picklist_Description_Config__mdt plm : picklistMetadata){
                //system.debug(plm.Test_Config__r.Test_Name__c + ': ' + plm.Field_Value__c + ' '+ plm.Field_Description__c);
                picklistDescriptions.put(plm.Test_Config__r.Test_Name__c + ': ' + plm.Field_Value__c, plm.Field_Description__c);

            }
        }

        testMetadata = new List<Test_Config__mdt>();
        testDescriptions = new Map<String, String>();
        testMetadata = [SELECT Test_Name__c, Test_Description__c, IsPuppy__c FROM Test_Config__mdt
                       WHERE IsPuppy__c =: evalType];
        if(testMetadata != null){
            for (Test_Config__mdt tm : testMetadata){
                //system.debug(plm.Test_Config__r.Test_Name__c + ': ' + plm.Field_Value__c + ' '+ plm.Field_Description__c);
                testDescriptions.put(tm.Test_Name__c,tm.Test_Description__c);

            }
        }


        system.debug(picklistDescriptions);
    }
}