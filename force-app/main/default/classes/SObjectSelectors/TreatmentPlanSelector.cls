/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentPlanSelector extends SObjectSelector {
    public TreatmentPlanSelector() {
        super(Treatment_Plan__c.SObjectType);
    }

    public override Set<SObjectField> GetDefaultFields() {
        return new Set<SObjectField> {
                Treatment_Plan__c.Name ,
                Treatment_Plan__c.CreatedById ,
                Treatment_Plan__c.CreatedDate ,
                Treatment_Plan__c.LastModifiedById ,
                Treatment_Plan__c.AssignedTreatmentBundleId__c,
                Treatment_Plan__c.MasterTreatmentBundleId__c ,
                Treatment_Plan__c.Description__c ,
                Treatment_Plan__c.Id ,
                Treatment_Plan__c.Plan_Notes__c ,
                Treatment_Plan__c.Animal__c ,
                Treatment_Plan__c.Preferred_Motivators__c
        };
    }

    public override List<iOrderBy> GetDefaultOrderBy() {
        return new List<iOrderBy> {
                OrderBy.Ascending(Treatment_Plan__c.Name) ,
                OrderBy.Ascending(Treatment_Plan__c.Id)
        };
    }

    public List<Treatment_Plan__c> GetById(Set<Id> ids) {
        return queryById(ids);
    }

    public List<Treatment_Plan__c> GetByName(String name) {
        return queryByName(name);
    }


}