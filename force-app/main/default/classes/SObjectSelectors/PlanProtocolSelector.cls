/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class PlanProtocolSelector extends SObjectSelector{
    public PlanProtocolSelector() {
        super(Plan_Protocol__c.SObjectType);
    }
    public override Set<SObjectField> GetDefaultFields() {
        return new Set<SObjectField> {
                Plan_Protocol__c.Name,
                Plan_Protocol__c.CreatedById ,
                Plan_Protocol__c.CreatedDate ,
                Plan_Protocol__c.Protocol_Description__c ,
                Plan_Protocol__c.LastModifiedById ,
                Plan_Protocol__c.Protocol__c ,
                Plan_Protocol__c.Bundle_Entry__c ,
                Plan_Protocol__c.Treatment_Plan__c ,
                Plan_Protocol__c.Id ,
                Plan_Protocol__c.IsRemoved__c,
                Plan_Protocol__c.IsDeleted
        };
    }

    public override List<iOrderBy> GetDefaultOrderBy() {
        return new List<iOrderBy> {
                OrderBy.Ascending(Plan_Protocol__c.Name) ,
                OrderBy.Ascending(Plan_Protocol__c.Id)
        };
    }

    public List<Plan_Protocol__c> GetById(Set<Id> ids) {
        return queryById(ids);
    }

    public List<Plan_Protocol__c> GetByName(String name) {
        return queryByName(name);
    }

    public List<Plan_Protocol__c> GetByOpp(Id key) {
        List<Plan_Protocol__c> lineItems = GetQueryFactory().WithCriteria(Criteria.Equals(Plan_Protocol__c.Treatment_Plan__c, key)).Execute();
        return lineItems;
    }

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
    
    public Protocol__c[] getByProtocolIds(Set<Id> protocolIds) {
        return [
            SELECT 
                Id,
                (SELECT Id, Protocol_Scale__c, Protocol__c, Protocol_Scale__r.Required__c FROM Protocol_Scale_Junctions__r WHERE Protocol_Scale__r.isActive__c = true)
            FROM Protocol__c
            WHERE Id IN  :protocolIds
        ];
    }
}