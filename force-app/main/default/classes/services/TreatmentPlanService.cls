/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentPlanService {
    public void process(ServiceRequest req) {
        switch on req.Action {
            when 'triggerservice' {
                triggerservice(req);
            }
        }
    }

    private void triggerservice(ServiceRequest req) {
        switch on req.Name {
            when 'BeforeInsert' {
                BeforeInsert(req);
            }when 'BeforeUpdate' {
                BeforeUpdate(req);
            }
        }
    }
    
    private void BeforeInsert(ServiceRequest req) {
        List<Opportunity> treatmentPlans = (List<Opportunity>) req.Parameters.get('newRecords');
        for (Opportunity plan : treatmentPlans) {
            Animal__c animal = [SELECT id, Case__c FROM Animal__c WHERE Id =: plan.Animal__c];
            Case ref = [SELECT Id, Agency_Name__c FROM Case WHERE Id =: animal.Case__c];

            plan.AccountId = ref.Agency_Name__c;
        }
        TriggerRequest request = new TriggerRequest(Opportunity.getSObjectType())
                .SetBefore(true)
                .SetInsert(true)
                .SetNewRecords(treatmentPlans);
        req.Parameters.put('TriggerRequest', request);
        TreatmentPlanDomain domain = new TreatmentPlanDomain();
        ServiceResponse rep = domain.Execute(req);
        rep.Data = request.newRecords;

    } 
    
    private void BeforeUpdate(ServiceRequest req) {
        
    }

}