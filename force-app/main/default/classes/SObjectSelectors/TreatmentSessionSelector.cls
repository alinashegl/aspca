/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentSessionSelector extends SObjectSelector{
    public TreatmentSessionSelector() {
        super(Quote.SObjectType);
    }
    public override Set<SObjectField> GetDefaultFields() {
        return new Set<SObjectField> {
                Quote.Name,
                Quote.Id,
                Quote.OpportunityId,
                Quote.Pricebook2Id,
                Quote.Description,
                Quote.Animal__c,
                Quote.AccountId,
                Quote.CreatedById,
                Quote.LastModifiedById,
                Quote.CreatedDate,
                Quote.LastModifiedDate,
                Quote.ContactId,
                Quote.ContractId,
                Quote.Session_Notes__c
        };
    }
    public override List<iOrderBy> GetDefaultOrderBy() {
        return new List<iOrderBy> {
                OrderBy.Ascending(Quote.Name) ,
                OrderBy.Ascending(Quote.Id)
        };
    }
    public List<Pricebook2> GetById(Set<Id> ids) {
        return queryById(ids);
    }

    public List<Pricebook2> GetByName(String name) {
        return queryByName(name);
    }

}