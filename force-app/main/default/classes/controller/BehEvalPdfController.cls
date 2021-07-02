/*
<apex:page standardController="Animal__c" extensions="BehEvalPdfController" renderAs="pdf" applyBodyTag="false">
<apex:page standardController="Behavior_Evaluation__c" renderAs="pdf" applyBodyTag="false">
*/
public class BehEvalPdfController {
    
/*    public Animal__c objAnimal{get;set;}*/
    public Behavior_Evaluation__c behEval{get;set;}
    public String aNoConcernEvalGrade { get; set; }
    public Boolean bMildConcerns { get; set; }


    public BehEvalPdfController(ApexPages.StandardController controller){
        
        behEval = [SELECT 
Id,
Animal__c, 
Animal_Age__c, 
Animal_Breed__c, 
Animal_Color__c, 
Animal_ID__c, 
Animal_Name__c, 
Animal_Sex__c,
                Name,
Behavior_in_Kennel__c, 
Behavior_on_Leash__c, 
Case_Number__c, 
Caution__c, 
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
Behavior_Evaluation_Summary__c, 
Evaluation_Date__c, 
Evaluation_Subtype__c, 
Fake_Dog__c, 
Handler_Initials__c, 
Is_Muzzled__c, 
Muzzled_OSD_P3__c, 
Muzzled_SSD_P3__c, 
Opposite_Sex_P1__c, 
Opposite_Sex_P2__c, 
Opposite_Sex_P3__c, 
Overall_Evaluation_Grade__c,
Play_Test_P1__c, 
Play_Test_P2__c, 
Play_Test_Tug_P1__c, 
Play_Test_Tug_P2__c, 
Pleasant_Touch__c, 
Pleasant_Touch_Test__c, 
Resource_Guarding_P1_Push_Face__c, 
Resource_Guarding_P1_Touch_Body__c, 
Resource_Guarding_P1_Touch_Face__c, 
Resource_Guarding_P1_Touch_Neck__c, 
Resource_Guarding_P2_Push_Face__c, 
Resource_Guarding_P2_Touch_Body__c, 
Resource_Guarding_P2_Touch_Face__c, 
Resource_Guarding_P2_Touch_Neck__c, 
Same_Sex_P1__c, 
Same_Sex_P2__c, 
Same_Sex_P3__c, 
Scolding_Person_P1__c, 
Scolding_Person_P2__c, 
Scribe_Initials__c, 
Is_Skipped__c, 
Skipped_BIK__c, 
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
Social_Behavior_P1__c, 
Social_Behavior_P2_2__c, 
Social_Behavior_Test_P1__c, 
Social_Behavior_P2__c, 
Summary_Test__c, 
Tag_Test__c, 
Tester_Initials__c, 
Toddler_Doll_P1__c, 
Toddler_Doll_P2__c, 
Unpleasant_Touch_1st__c, 
Unpleasant_Touch_2nd__c,
Potential_Behavior_Issues__c,
Potential_Beh_Iss_Other__c,
Facility_Outcome__c
                  FROM Behavior_Evaluation__c /*Limit 1)*/
                                       WHERE Id = :ApexPages.currentPage().getparameters().get('Id')];
/*                  FROM Animal__c WHERE Name = 'ARC-46813685'];*/
/*                     WHERE Id = :ApexPages.currentPage().getparameters().get('Id')  ];*/


        if (behEval.Overall_Evaluation_Grade__c == 'A - No Concerns') {
            aNoConcernEvalGrade = 'X';
        }else {
            aNoConcernEvalGrade = '';
        }

        bMildConcerns = behEval.Overall_Evaluation_Grade__c == 'B - Mild Concern(s)' ? true : false;
    }
}