/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class SessionProtocolSelector extends SObjectSelector {
    public SessionProtocolSelector() {
        super(Session_Protocol__c.SObjectType);
    }

    public override Set<SObjectField> GetDefaultFields() {
        return new Set<SObjectField> {
                Session_Protocol__c.Id,
                Session_Protocol__c.Bundle_Entry__c,
                Session_Protocol__c.CreatedById,
                Session_Protocol__c.CreatedDate,
                Session_Protocol__c.LastModifiedById,
                Session_Protocol__c.LastModifiedDate,
                Session_Protocol__c.Fear_Best__c,
                Session_Protocol__c.Fear_Worst__c,
                Session_Protocol__c.Aggressive_Worst__c,
                Session_Protocol__c.Arousal_Best__c,
                Session_Protocol__c.Arousal_Worst__c,
                Session_Protocol__c.Social_Best__c,
                Session_Protocol__c.Overall_Score__c,
                Session_Protocol__c.Novel_Person_Notes__c,
                Session_Protocol__c.Novel_Person__c,
                Session_Protocol__c.Protocol_Notes__c,
                Session_Protocol__c.Protocol_Box_Link__c,
                Session_Protocol__c.IsSkipped__c,
                Session_Protocol__c.IsRemoved__c,
                Session_Protocol__c.IsDeleted ,
                Session_Protocol__c.ProtocolId__c ,
                Session_Protocol__c.TreatmentSessionId__c ,
                Session_Protocol__c.Add_to_Plan__c
        };
    }
    public override List<iOrderBy> GetDefaultOrderBy() {
        return new List<iOrderBy> {
                OrderBy.Ascending(Session_Protocol__c.Name) ,
                OrderBy.Ascending(Session_Protocol__c.Id)
        };
    }

    public List<Session_Protocol__c> GetByIds(Set<Id> ids) {
        return queryById(ids);
    }

    public List<Session_Protocol__c> GetByQuote(Id key) {
        List<Session_Protocol__c> lineItems = GetQueryFactory().WithCriteria(Criteria.Equals(Session_Protocol__c.TreatmentSessionId__c,
                key))
                .Execute();
        return lineItems;
    }

}