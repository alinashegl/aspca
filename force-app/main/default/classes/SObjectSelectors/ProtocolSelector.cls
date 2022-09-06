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
                Protocol__c.Description__c ,
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

    //dont think this is being used
    // public List<Protocol__c> GetByExternalId(String key) {
    //     List<Protocol__c> lineItems = GetQueryFactory().WithCriteria(Criteria.Equals(Product2.ExternalId, key)).Execute();
    //     return lineItems;
    // }

    public Protocol__c[] getByPlan(Id planId) {
        return [
            SELECT 
                Id,
                (SELECT Id, Protocol_Scale__c, Protocol__c, Protocol_Scale__r.Required__c FROM Protocol_Scale_Junctions__r WHERE Protocol_Scale__r.isActive__c = true),
                (SELECT Id, Bundle_Entry__c, IsRemoved__c FROM Plan_Protocols__r WHERE Treatment_Plan__c = :planId)
            FROM Protocol__c
            WHERE Id IN (SELECT Protocol__c FROM Plan_Protocol__c  WHERE Treatment_Plan__c = :planId)
        ];
    }
    
    public Protocol__c[] getProtocolWithChildProtocolScaleJunctionByIds(Set<Id> protocolIds) {
        return [
            SELECT 
                Id,
                (SELECT Id, Protocol_Scale__c, Protocol__c, Protocol_Scale__r.Required__c FROM Protocol_Scale_Junctions__r WHERE Protocol_Scale__r.isActive__c = true)
            FROM Protocol__c
            WHERE Id IN  :protocolIds
        ];
    }

}