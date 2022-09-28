/**
 * Created by barne on 4/29/2021.
 */

public with sharing class dao_BehaviorEvaluations extends sql_Dao{
    public dao_BehaviorEvaluations() {
        setSObject(Behavior_Evaluation__c.SObjectType);

        addField(Behavior_Evaluation__c.Animal__c);
        addField(Behavior_Evaluation__c.Animal_Age__c);
        addField(Behavior_Evaluation__c.Animal_Breed__c);
        addField(Behavior_Evaluation__c.Animal_Color__c);
        addField(Behavior_Evaluation__c.Animal_ID__c);
        addField(Behavior_Evaluation__c.Animal_Sex__c);
        addField(Behavior_Evaluation__c.Animal_Name__c);
        addField(Behavior_Evaluation__c.Name);
        addField(Behavior_Evaluation__c.Caution__c);
        addField(Behavior_Evaluation__c.Muzzled_OSD_P3__c);
        addField(Behavior_Evaluation__c.Is_Muzzled__c);
        addField(Behavior_Evaluation__c.Puppy_Skipped_DI_P1__c);
        addField(Behavior_Evaluation__c.Puppy_Skipped_DI_P2__c);
        addField(Behavior_Evaluation__c.Puppy_Skipped_DI_P3__c);
        addField(Behavior_Evaluation__c.Puppy_Muzzled_DI_P1__c);
        addField(Behavior_Evaluation__c.Puppy_Muzzled_DI_P2__c);
        addField(Behavior_Evaluation__c.Puppy_Muzzled_DI_P3__c);
        addField(Behavior_Evaluation__c.Puppy_Comments_DI_P1__c);
        addField(Behavior_Evaluation__c.Puppy_Comments_DI_P2__c);
        addField(Behavior_Evaluation__c.Puppy_Comments_DI_P3__c);
        addField(Behavior_Evaluation__c.Puppy_Dog_Interaction_P3__c);
        addField(Behavior_Evaluation__c.Puppy_BIK_Housing__c);
        addField(Behavior_Evaluation__c.Muzzled_OSD_P3__c);
        addField(Behavior_Evaluation__c.Muzzled_SSD_P3__c);
        addField(Behavior_Evaluation__c.Puppy_Dog_Interaction_P2__c);
        addField(Behavior_Evaluation__c.Puppy_Dog_Interaction_P1__c);
        addField(Behavior_Evaluation__c.Puppy_Behavior_in_Kennel__c);
        addField(Behavior_Evaluation__c.Puppy_Behavior_on_Leash__c);
        addField(Behavior_Evaluation__c.Puppy_Social_Behavior_P1__c);
        addField(Behavior_Evaluation__c.Puppy_Social_Behavior_P2__c);
        addField(Behavior_Evaluation__c.Puppy_Play_Tug_P1__c);        
        addField(Behavior_Evaluation__c.Puppy_Play_Tug_P2__c);        
        addField(Behavior_Evaluation__c.Puppy_Play_Tag__c);
        addField(Behavior_Evaluation__c.Puppy_Restraint__c);
        addField(Behavior_Evaluation__c.Puppy_Comments_Restraint__c);
        addField(Behavior_Evaluation__c.Puppy_Skipped_Restraint__c);
        addField(Behavior_Evaluation__c.Puppy_Child_Doll_P1__c);
        addField(Behavior_Evaluation__c.Puppy_Comments_CD_P1__c);
        addField(Behavior_Evaluation__c.Puppy_Skipped_CD_P1__c);
        addField(Behavior_Evaluation__c.Puppy_Resource_Guarding_P1_Push_Face__c);
        addField(Behavior_Evaluation__c.Puppy_Resource_Guarding_P1_Touch_Body__c);
        addField(Behavior_Evaluation__c.Puppy_Resource_Guarding_P1_Touch_Neck__c);
        addField(Behavior_Evaluation__c.Puppy_Resource_Guarding_P1_Touch_Face__c);
        addField(Behavior_Evaluation__c.Puppy_Resource_Guarding_P2_Push_Face__c);
        addField(Behavior_Evaluation__c.Puppy_Resource_Guarding_P2_Touch_Body__c);
        addField(Behavior_Evaluation__c.Puppy_Resource_Guarding_P2_Touch_Neck__c);
        addField(Behavior_Evaluation__c.Puppy_Resource_Guarding_P2_Touch_Face__c);
        addField(Behavior_Evaluation__c.Social_Behavior_P1__c);
        addField(Behavior_Evaluation__c.Social_Behavior_P2_2__c);
        addField(Behavior_Evaluation__c.Play_Test_P1__c);
        addField(Behavior_Evaluation__c.Play_Test_Tug_P1__c);
        addField(Behavior_Evaluation__c.Play_Test_Tug_P2__c);
        addField(Behavior_Evaluation__c.Play_Test_P2__c);
        addField(Behavior_Evaluation__c.Pleasant_Touch__c);
        addField(Behavior_Evaluation__c.Pleasant_Touch_Test__c);
        addField(Behavior_Evaluation__c.Comments_Pleasant_Touch__c);
        addField(Behavior_Evaluation__c.Comments_SB_P1__c);
        addField(Behavior_Evaluation__c.Comments_SB_P2__c);
        addField(Behavior_Evaluation__c.Evaluation_Subtype__c);
        addField(Behavior_Evaluation__c.Behavior_in_Kennel__c);
        addField(Behavior_Evaluation__c.Comments_BIK__c);
        addField(Behavior_Evaluation__c.Behavior_on_Leash__c);
        addField(Behavior_Evaluation__c.Comments_BOL__c);
        addField(Behavior_Evaluation__c.Unpleasant_Touch_1st__c);
        addField(Behavior_Evaluation__c.Unpleasant_Touch_2nd__c);
        addField(Behavior_Evaluation__c.Comments_UT_1st__c);
        addField(Behavior_Evaluation__c.Comments_UT_2nd__c);
        addField(Behavior_Evaluation__c.Tag_Test__c);
        addField(Behavior_Evaluation__c.Comments_Tag__c);
        addField(Behavior_Evaluation__c.Resource_Guarding_P1_Push_Face__c);
        addField(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Body__c);
        addField(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Face__c);
        addField(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Neck__c);
        addField(Behavior_Evaluation__c.Comments_RG_P1__c);
        addField(Behavior_Evaluation__c.Puppy_Child_Doll_P2__c);
        addField(Behavior_Evaluation__c.Resource_Guarding_P2_Push_Face__c);
        addField(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Body__c);
        addField(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Face__c);
        addField(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Neck__c);
        addField(Behavior_Evaluation__c.Comments_RG_P2__c);
        addField(Behavior_Evaluation__c.Toddler_Doll_P1__c);
        addField(Behavior_Evaluation__c.Comments_TD_P1__c);
        addField(Behavior_Evaluation__c.Toddler_Doll_P2__c);
        addField(Behavior_Evaluation__c.Comments_TD_P2__c);
        addField(Behavior_Evaluation__c.Scolding_Person_P1__c);
        addField(Behavior_Evaluation__c.Comments_SP_P1__c);
        addField(Behavior_Evaluation__c.Scolding_Person_P2__c);
        addField(Behavior_Evaluation__c.Comments_SP_P2__c);
        addField(Behavior_Evaluation__c.Fake_Dog__c);
        addField(Behavior_Evaluation__c.Comments_FD__c);
        addField(Behavior_Evaluation__c.Same_Sex_P1__c);
        addField(Behavior_Evaluation__c.Comments_SSD_P1__c);
        addField(Behavior_Evaluation__c.Same_Sex_P2__c);
        addField(Behavior_Evaluation__c.Comments_SSD_P2__c);
        addField(Behavior_Evaluation__c.Same_Sex_P3__c);
        addField(Behavior_Evaluation__c.Comments_SSD_P3__c);
        addField(Behavior_Evaluation__c.Opposite_Sex_P1__c);
        addField(Behavior_Evaluation__c.Comments_OSD_P1__c);
        addField(Behavior_Evaluation__c.Opposite_Sex_P2__c);
        addField(Behavior_Evaluation__c.Comments_OSD_P2__c);
        addField(Behavior_Evaluation__c.Opposite_Sex_P3__c);
        addField(Behavior_Evaluation__c.Comments_OSD_P3__c);
        addField(Behavior_Evaluation__c.Skipped_BIK__c);
        addField(Behavior_Evaluation__c.Skipped_BOL__c);
        addField(Behavior_Evaluation__c.Skipped_FD__c);
        addField(Behavior_Evaluation__c.Skipped_OSD_P1__c);
        addField(Behavior_Evaluation__c.Skipped_OSD_P2__c);
        addField(Behavior_Evaluation__c.Skipped_OSD_P3__c);
        addField(Behavior_Evaluation__c.Skipped_RG_P1__c);
        addField(Behavior_Evaluation__c.Skipped_RG_P2__c);
        addField(Behavior_Evaluation__c.Skipped_RG_P1_PF__c);
        addField(Behavior_Evaluation__c.Skipped_RG_P1_TB__c);
        addField(Behavior_Evaluation__c.Skipped_RG_P1_TF__c);
        addField(Behavior_Evaluation__c.Skipped_RG_P1_TN__c);
        addField(Behavior_Evaluation__c.Skipped_RG_P2_PF__c);
        addField(Behavior_Evaluation__c.Skipped_RG_P2_TB__c);
        addField(Behavior_Evaluation__c.Skipped_RG_P2_TF__c);
        addField(Behavior_Evaluation__c.Skipped_RG_P2_TN__c);
        addField(Behavior_Evaluation__c.Skipped_UT_1st__c);
        addField(Behavior_Evaluation__c.Skipped_UT_2nd__c);
        addField(Behavior_Evaluation__c.Skipped_TD_P1__c);
        addField(Behavior_Evaluation__c.Skipped_TD_P2__c);
        addField(Behavior_Evaluation__c.Skipped_Tag__c);
        addField(Behavior_Evaluation__c.Skipped_SSD_P1__c);
        addField(Behavior_Evaluation__c.Skipped_SSD_P2__c);
        addField(Behavior_Evaluation__c.Skipped_SSD_P3__c);
        addField(Behavior_Evaluation__c.Skipped_Pleasant__c);
        addField(Behavior_Evaluation__c.Skipped_SB_P1__c);
        addField(Behavior_Evaluation__c.Skipped_SB_P2__c);
        addField(Behavior_Evaluation__c.Skipped_SP_P1__c);
        addField(Behavior_Evaluation__c.Skipped_SP_P2__c);
        addField(Behavior_Evaluation__c.Skipped_Play_Tug_P1__c);
        addField(Behavior_Evaluation__c.Skipped_Play_Tug_P2__c);
        addField(Behavior_Evaluation__c.Comments_UT__c);
        addField(Behavior_Evaluation__c.Comments_Play_Tug_P1__c);
        addField(Behavior_Evaluation__c.Comments_Play_Tug_P2__c);
        addField(Behavior_Evaluation__c.CreatedById);
        addField(Behavior_Evaluation__c.CreatedDate);
        addField(Behavior_Evaluation__c.LastModifiedDate);
        addField(Behavior_Evaluation__c.LastModifiedById);
    }

    public List<Behavior_Evaluation__c> findAll() {
        return getAll();
    }

    public Behavior_Evaluation__c findOne(String id) {
        List<Behavior_Evaluation__c> behaviorEvaluations = getWhere(sql_Criteria.Equals(Behavior_Evaluation__c.Id, id));
        System.debug(behaviorEvaluations);
        if (behaviorEvaluations.isEmpty()) { System.debug('QUERY FAILED'); return null; }

        return behaviorEvaluations[0];

    }

    public Behavior_Evaluation__c getOneByAnimalIdString(String id) {
        List<Behavior_Evaluation__c> behaviorEvaluations = getWhere(sql_Criteria.Equals(Behavior_Evaluation__c.Animal__c, id));

        if (behaviorEvaluations.isEmpty()) {return null; }
        return behaviorEvaluations[0];
    }

    public List<Behavior_Evaluation__c> getAllByAnimalIdString(String id) {
        List<Behavior_Evaluation__c> behaviorEvaluations = getWhere(sql_Criteria.Equals(Behavior_Evaluation__c.Animal__c, id));
        if (behaviorEvaluations.isEmpty()) {return null; }
        return behaviorEvaluations;
    }

    public Behavior_Evaluation__c getOneByAnimalId(Id id ) {
        List<Behavior_Evaluation__c> behaviorEvaluations = getWhere(sql_Criteria.Equals(Behavior_Evaluation__c.Animal__c, id));

        if (behaviorEvaluations.isEmpty()) {return null; }
        return behaviorEvaluations[0];
    }

    public List<Behavior_Evaluation__c> getAllByAnimalId(Id id) {
        List<Behavior_Evaluation__c> behaviorEvaluations = getWhere(sql_Criteria.Equals(Behavior_Evaluation__c.Animal__c, id));
        if (behaviorEvaluations.isEmpty()) {return null; }
        return behaviorEvaluations;
    }
}