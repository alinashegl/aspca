/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class ProtocolSelector extends SObjectSelector{
    public ProtocolSelector() {
        super(Protocol__c.SObjectType);
    }
    public override Set<SObjectField> GetDefaultFields() {
        return new Set<SObjectField> {
                Protocol__c.Name,
                Protocol__c.CreatedById ,
                Protocol__c.CreatedDate ,
                Protocol__c.LastModifiedById ,
                Protocol__c.Id ,
                Protocol__c.IsActive__c
        };
    }

    public override List<iOrderBy> GetDefaultOrderBy() {
        return new List<iOrderBy> {
                OrderBy.Ascending(Product2.Name) ,
                OrderBy.Ascending(Product2.Id)
        };
    }

    public List<Protocol__c> GetById(Set<Id> ids) {
        return queryById(ids);
    }

    public List<Protocol__c> GetByName(String name) {
        return queryByName(name);
    }

}