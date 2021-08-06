/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class PlanProtocolSelector extends SObjectSelector{
    public PlanProtocolSelector() {
        super(OpportunityLineItem.SObjectType);
    }
    public override Set<SObjectField> GetDefaultFields() {
        return new Set<SObjectField> {
                OpportunityLineItem.Name,
                OpportunityLineItem.CreatedById ,
                OpportunityLineItem.CreatedDate ,
                OpportunityLineItem.Description ,
                OpportunityLineItem.LastModifiedById ,
                OpportunityLineItem.Product2Id ,
                OpportunityLineItem.PricebookEntryId ,
                OpportunityLineItem.OpportunityId ,
                OpportunityLineItem.Id
        };
    }

    public override List<iOrderBy> GetDefaultOrderBy() {
        return new List<iOrderBy> {
                OrderBy.Ascending(OpportunityLineItem.Name) ,
                OrderBy.Ascending(OpportunityLineItem.Id)
        };
    }

    public List<OpportunityLineItem> GetById(Set<Id> ids) {
        return queryById(ids);
    }

    public List<OpportunityLineItem> GetByName(String name) {
        return queryByName(name);
    }

    public List<OpportunityLineItem> GetByOpp(Id key) {
        List<OpportunityLineItem> lineItems = GetQueryFactory().WithCriteria(Criteria.Equals(OpportunityLineItem.OpportunityId, key)).Execute();
        return lineItems;
    }

}