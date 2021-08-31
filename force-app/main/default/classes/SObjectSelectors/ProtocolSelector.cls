/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class ProtocolSelector extends SObjectSelector{
    public ProtocolSelector() {
        super(Product2.SObjectType);
    }
    public override Set<SObjectField> GetDefaultFields() {
        return new Set<SObjectField> {
                Product2.Name,
                Product2.CreatedById ,
                Product2.CreatedDate ,
                Product2.Description ,
                Product2.LastModifiedById ,
                Product2.Id ,
                Product2.Family ,
                Product2.IsActive ,
                Product2.ExternalId
        };
    }

    public override List<iOrderBy> GetDefaultOrderBy() {
        return new List<iOrderBy> {
                OrderBy.Ascending(Product2.Name) ,
                OrderBy.Ascending(Product2.Id)
        };
    }

    public List<Product2> GetById(Set<Id> ids) {
        return queryById(ids);
    }

    public List<Product2> GetByName(String name) {
        return queryByName(name);
    }

    public List<Product2> GetByExternalId(String key) {
        List<Product2> lineItems = GetQueryFactory().WithCriteria(Criteria.Equals(Product2.ExternalId, key)).Execute();
        return lineItems;
    }

}