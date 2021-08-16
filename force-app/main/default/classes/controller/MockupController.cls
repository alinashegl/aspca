/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class MockupController {
    @AuraEnabled public static List<Opportunity> getTreatmentPlans(String key) {
        List<Opportunity> opportunities = new List<Opportunity>();
        Id kito = Id.valueOf(key);
        Set<Id> nIds = new Set<Id>();
        nIds.add(kito);
        TreatmentPlanSelector selector = new TreatmentPlanSelector();
        opportunities = selector.GetById(nIds);
        return opportunities;
    }
}