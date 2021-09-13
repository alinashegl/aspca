/*
 * Created by barne on 5/5/2021.
 */

public with sharing class EvalHelperTextMapUtil {

    @AuraEnabled public String approachFriendlySP1 { get; set; }
    @AuraEnabled public String approachSubmissiveSP1 { get; set; }
    @AuraEnabled public String approachDistractedSP1 { get; set; }
    @AuraEnabled public String approachFearfulSP1 { get; set;}
    @AuraEnabled public String notApproachDistractSP1 { get; set; }
    @AuraEnabled public String freneticMovementSP1 { get; set; }
    @AuraEnabled public String notApproachModerateSP1 { get; set; }
    @AuraEnabled public String notApproachExtremeSP1 { get; set; }
    @AuraEnabled public String aggressiveSP1 { get; set; }

    public  void SocialTestWrapper() {
        SocialBehaviorTestHelper__c testHelper = SocialBehaviorTestHelper__c.getInstance();
        approachFriendlySP1 = testHelper.Approaches_Tester_readily_Friendly__c;
        approachSubmissiveSP1 = testHelper.Approaches_tester_readily_Submissive__c;
        approachDistractedSP1 = testHelper.Approaches_Tester_but_distracted_by_En__c;
        approachFearfulSP1 = testHelper.Approaches_tester_mildly_fearful__c;
        notApproachDistractSP1 = testHelper.Does_not_approach_tester_Distracted_by__c;
        freneticMovementSP1 = testHelper.Frenetic_Movement__c;
        notApproachModerateSP1 = testHelper.Does_not_approach_Tester_Moderately_fe__c;
        notApproachExtremeSP1 = testHelper.Does_not_approach_tester_extremely_fea__c;
        aggressiveSP1 = testHelper.Becomes_aggressive__c;

    }

    public Map<String, String> SocialTestP1Map(Behavior_Evaluation__c evaluation) {
        Map<String, String> stringMap = new Map<String, String>();
        SocialBehaviorTestHelper__c testHelper = SocialBehaviorTestHelper__c.getInstance();


        stringMap.put('Approaches Tester readily - Friendly', testHelper.Approaches_Tester_readily_Friendly__c);
        stringMap.put('Approaches tester readily - Submissive', testHelper.Approaches_tester_readily_Submissive__c);
        stringMap.put('Approaches Tester - but distracted by Environment', testHelper.Approaches_Tester_but_distracted_by_En__c);
        stringMap.put('Approaches tester - mildly fearful', testHelper.Approaches_tester_mildly_fearful__c);
        stringMap.put('Does not approach tester -Distracted by Environment', testHelper.Does_not_approach_tester_Distracted_by__c);
        stringMap.put('Frenetic Movement', testHelper.Frenetic_Movement__c);
        stringMap.put('Does not approach Tester - Moderately fearful', testHelper.Does_not_approach_Tester_Moderately_fe__c);
        stringMap.put('Does not approach tester - extremely fearful', testHelper.Does_not_approach_tester_extremely_fea__c);
        stringMap.put('Becomes aggressive', testHelper.Becomes_aggressive__c);

        return stringMap;

    }

}