/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class BehaviorEvaluationsSelector extends SObjectSelector {
    public BehaviorEvaluationsSelector() {
        super(Behavior_Evaluation__c.SObjectType);
    }

    public override Set<SObjectField> GetDefaultFields() {
        return new Set<SObjectField> {
                  Behavior_Evaluation__c.Animal__c,
                Behavior_Evaluation__c.Animal_Age__c,
                Behavior_Evaluation__c.Animal_Breed__c,
                Behavior_Evaluation__c.Animal_ID__c,
                Behavior_Evaluation__c.Animal_Sex__c,
                Behavior_Evaluation__c.Animal_Name__c,
                Behavior_Evaluation__c.Name,
                Behavior_Evaluation__c.Id,
                Behavior_Evaluation__c.Caution__c,
                Behavior_Evaluation__c.Muzzled_SSD_P3__c,
                Behavior_Evaluation__c.Muzzled_OSD_P3__c,
                Behavior_Evaluation__c.Is_Muzzled__c,
                Behavior_Evaluation__c.Puppy_Muzzled_DI_P3__c,
                Behavior_Evaluation__c.Puppy_Muzzled_DI_P2__c,
                Behavior_Evaluation__c.Puppy_Muzzled_DI_P1__c,
                Behavior_Evaluation__c.Puppy_Skipped_DI_P1__c,
                Behavior_Evaluation__c.Puppy_Skipped_DI_P2__c,
                Behavior_Evaluation__c.Puppy_Skipped_DI_P3__c,
                Behavior_Evaluation__c.Puppy_Comments_DI_P1__c,
                Behavior_Evaluation__c.Puppy_Comments_DI_P2__c,
                Behavior_Evaluation__c.Puppy_Comments_DI_P3__c,
                Behavior_Evaluation__c.Puppy_Dog_Interaction_P1__c,
                Behavior_Evaluation__c.Puppy_Dog_Interaction_P2__c,
                Behavior_Evaluation__c.Puppy_Dog_Interaction_P3__c,
                Behavior_Evaluation__c.Puppy_BIK_Housing__c,
                Behavior_Evaluation__c.Puppy_Behavior_in_Kennel__c,
                Behavior_Evaluation__c.Puppy_Behavior_on_Leash__c,
                Behavior_Evaluation__c.Puppy_Social_Behavior_P1__c,
                Behavior_Evaluation__c.Puppy_Social_Behavior_P2__c,
                Behavior_Evaluation__c.Puppy_Play_Tug_P1__c,                
                Behavior_Evaluation__c.Puppy_Play_Tug_P2__c,                
                Behavior_Evaluation__c.Puppy_Play_Tag__c,
                Behavior_Evaluation__c.Puppy_Restraint__c,
                Behavior_Evaluation__c.Puppy_Comments_Restraint__c,
                Behavior_Evaluation__c.Puppy_Skipped_Restraint__c,
                Behavior_Evaluation__c.Puppy_Child_Doll_P1__c,
                Behavior_Evaluation__c.Puppy_Comments_CD_P1__c,
                Behavior_Evaluation__c.Puppy_Skipped_CD_P1__c,
                Behavior_Evaluation__c.Puppy_Resource_Guarding_P1_Push_Face__c,
                Behavior_Evaluation__c.Puppy_Resource_Guarding_P1_Touch_Body__c,
                Behavior_Evaluation__c.Puppy_Resource_Guarding_P1_Touch_Neck__c,
                Behavior_Evaluation__c.Puppy_Resource_Guarding_P1_Touch_Face__c,
                Behavior_Evaluation__c.Puppy_Resource_Guarding_P2_Push_Face__c,
                Behavior_Evaluation__c.Puppy_Resource_Guarding_P2_Touch_Body__c,
                Behavior_Evaluation__c.Puppy_Resource_Guarding_P2_Touch_Neck__c,
                Behavior_Evaluation__c.Puppy_Resource_Guarding_P2_Touch_Face__c,
                Behavior_Evaluation__c.Social_Behavior_P1__c,
                Behavior_Evaluation__c.Social_Behavior_P2_2__c,
                Behavior_Evaluation__c.Play_Test_P1__c,
                Behavior_Evaluation__c.Play_Test_Tug_P1__c,
                Behavior_Evaluation__c.Play_Test_Tug_P2__c,
                Behavior_Evaluation__c.Play_Test_P2__c,
                Behavior_Evaluation__c.Pleasant_Touch__c,
                Behavior_Evaluation__c.Pleasant_Touch_Test__c,
                Behavior_Evaluation__c.Comments_Pleasant_Touch__c,
                Behavior_Evaluation__c.Comments_SB_P1__c,
                Behavior_Evaluation__c.Comments_SB_P2__c,
                Behavior_Evaluation__c.Evaluation_Subtype__c,
                Behavior_Evaluation__c.Behavior_in_Kennel__c,
                Behavior_Evaluation__c.Comments_BIK__c,
                Behavior_Evaluation__c.Behavior_on_Leash__c,
                Behavior_Evaluation__c.Comments_BOL__c,
                Behavior_Evaluation__c.Unpleasant_Touch_1st__c,
                Behavior_Evaluation__c.Unpleasant_Touch_2nd__c,
                Behavior_Evaluation__c.Comments_UT_1st__c,
                Behavior_Evaluation__c.Comments_UT_2nd__c,
                Behavior_Evaluation__c.Tag_Test__c,
                Behavior_Evaluation__c.Comments_Tag__c,
                Behavior_Evaluation__c.Resource_Guarding_P1_Push_Face__c,
                Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Body__c,
                Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Face__c,
                Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Neck__c,
                Behavior_Evaluation__c.Comments_RG_P1__c,
                Behavior_Evaluation__c.Puppy_Child_Doll_P2__c,
                Behavior_Evaluation__c.Resource_Guarding_P2_Push_Face__c,
                Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Body__c,
                Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Face__c,
                Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Neck__c,
                Behavior_Evaluation__c.Comments_RG_P2__c,
                Behavior_Evaluation__c.Toddler_Doll_P1__c,
                Behavior_Evaluation__c.Comments_TD_P1__c,
                Behavior_Evaluation__c.Toddler_Doll_P2__c,
                Behavior_Evaluation__c.Comments_TD_P2__c,
                Behavior_Evaluation__c.Scolding_Person_P1__c,
                Behavior_Evaluation__c.Comments_SP_P1__c,
                Behavior_Evaluation__c.Scolding_Person_P2__c,
                Behavior_Evaluation__c.Comments_SP_P2__c,
                Behavior_Evaluation__c.Fake_Dog__c,
                Behavior_Evaluation__c.Comments_FD__c,
                Behavior_Evaluation__c.Same_Sex_P1__c,
                Behavior_Evaluation__c.Comments_SSD_P1__c,
                Behavior_Evaluation__c.Same_Sex_P2__c,
                Behavior_Evaluation__c.Comments_SSD_P2__c,
                Behavior_Evaluation__c.Same_Sex_P3__c,
                Behavior_Evaluation__c.Comments_SSD_P3__c,
                Behavior_Evaluation__c.Opposite_Sex_P1__c,
                Behavior_Evaluation__c.Comments_OSD_P1__c,
                Behavior_Evaluation__c.Opposite_Sex_P2__c,
                Behavior_Evaluation__c.Comments_OSD_P2__c,
                Behavior_Evaluation__c.Opposite_Sex_P3__c,
                Behavior_Evaluation__c.Comments_OSD_P3__c,
                Behavior_Evaluation__c.Skipped_BIK__c,
                Behavior_Evaluation__c.Skipped_BOL__c,
                Behavior_Evaluation__c.Skipped_FD__c,
                Behavior_Evaluation__c.Skipped_OSD_P1__c,
                Behavior_Evaluation__c.Skipped_OSD_P2__c,
                Behavior_Evaluation__c.Skipped_OSD_P3__c,
                Behavior_Evaluation__c.Skipped_RG_P1__c,
                Behavior_Evaluation__c.Skipped_RG_P1_PF__c,
                Behavior_Evaluation__c.Skipped_RG_P2__c,
                Behavior_Evaluation__c.Skipped_RG_P1_TB__c,
                Behavior_Evaluation__c.Skipped_RG_P1_TF__c,
                Behavior_Evaluation__c.Skipped_RG_P1_TN__c,
                Behavior_Evaluation__c.Skipped_RG_P2_PF__c,
                Behavior_Evaluation__c.Skipped_RG_P2_TB__c,
                Behavior_Evaluation__c.Skipped_RG_P2_TF__c,
                Behavior_Evaluation__c.Skipped_RG_P2_TN__c,
                Behavior_Evaluation__c.Skipped_UT_1st__c,
                Behavior_Evaluation__c.Skipped_UT_2nd__c,
                Behavior_Evaluation__c.Skipped_TD_P1__c,
                Behavior_Evaluation__c.Skipped_TD_P2__c,
                Behavior_Evaluation__c.Skipped_Tag__c,
                Behavior_Evaluation__c.Skipped_SSD_P1__c,
                Behavior_Evaluation__c.Skipped_SSD_P2__c,
                Behavior_Evaluation__c.Skipped_SSD_P3__c,
                Behavior_Evaluation__c.Skipped_Pleasant__c,
                Behavior_Evaluation__c.Skipped_SB_P1__c,
                Behavior_Evaluation__c.Skipped_SB_P2__c,
                Behavior_Evaluation__c.Skipped_SP_P1__c,
                Behavior_Evaluation__c.Skipped_SP_P2__c,
                Behavior_Evaluation__c.Skipped_Play_Tug_P1__c,
                Behavior_Evaluation__c.Skipped_Play_Tug_P2__c,
                Behavior_Evaluation__c.Comments_UT__c,
                Behavior_Evaluation__c.Comments_Play_Tug_P1__c,
                Behavior_Evaluation__c.Comments_Play_Tug_P2__c,
                Behavior_Evaluation__c.CreatedById,
                Behavior_Evaluation__c.CreatedDate,
                Behavior_Evaluation__c.LastModifiedById,
                Behavior_Evaluation__c.LastModifiedDate ,
                Behavior_Evaluation__c.Unpleasant_Touch_1st_Flank__c ,
                Behavior_Evaluation__c.Unpleasant_Touch_2nd_Flank__c
        };
    }
    public override List<iOrderBy> GetDefaultOrderBy() {
        return new List<iOrderBy> {
                (iOrderBy) OrderBy.Ascending(Behavior_Evaluation__c.Name),
                (iOrderBy) OrderBy.Ascending(Behavior_Evaluation__c.Id)
        };
    }

    public List<Behavior_Evaluation__c> GetById(Set<Id> idSet) {
        return queryById(idSet);
    }

    public List<Behavior_Evaluation__c> GetByName(String name){
        return queryByName(name);
    }

    public List<Behavior_Evaluation__c> GetAll() {
        return queryAll();
    }

    public List<Behavior_Evaluation__c> GetSome(Integer rowLimit) {
        return querySome(rowLimit);
    }
}