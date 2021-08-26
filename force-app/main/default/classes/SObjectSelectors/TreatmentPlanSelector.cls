/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentPlanSelector extends SObjectSelector {
    public TreatmentPlanSelector() {
        super(Opportunity.SObjectType);
    }

    public override Set<SObjectField> GetDefaultFields() {
        return new Set<SObjectField> {
                Opportunity.Name ,
                Opportunity.CreatedById ,
                Opportunity.CreatedDate ,
                Opportunity.Description ,
                Opportunity.LastModifiedById ,
                Opportunity.Pricebook2Id ,
                Opportunity.IsPrivate ,
                Opportunity.StageName ,
                Opportunity.Type ,
                Opportunity.Id ,
                Opportunity.Assigned_Treatment_Bundle__c
        };
    }

    public override List<iOrderBy> GetDefaultOrderBy() {
        return new List<iOrderBy> {
                OrderBy.Ascending(Opportunity.Name) ,
                OrderBy.Ascending(Opportunity.Id)
        };
    }

    public List<Opportunity> GetById(Set<Id> ids) {
        return queryById(ids);
    }

    public List<Opportunity> GetByName(String name) {
        return queryByName(name);
    }


}