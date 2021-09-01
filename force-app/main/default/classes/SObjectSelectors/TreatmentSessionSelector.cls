/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentSessionSelector extends SObjectSelector {
    public TreatmentSessionSelector() {
        super(Quote.SObjectType);
    }

    public override Set<SObjectField> GetDefaultFields() {
        return new Set<SObjectField> {
                Quote.Name,
                Quote.Id,
                Quote.OpportunityId,
                Quote.Pricebook2Id,
                Quote.Animal__c,
                Quote.CreatedById,
                Quote.CreatedDate,
                Quote.LastModifiedById,
                Quote.LastModifiedDate,
                Quote.Session_Notes__c,
                Quote.Status
        };
    }

    public override List<iOrderBy> GetDefaultOrderBy() {
        return new List<iOrderBy> {
                OrderBy.Ascending(Quote.Name) ,
                OrderBy.Ascending(Quote.Id)
        };
    }

    public List<Quote> GetByIds(Set<Id> ids) {
        return queryById(ids);
    }

    public List<Quote> GetByName(String name) {
        return queryByName(name);
    }

}