/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class SessionProtocolSelector extends SObjectSelector {
    public SessionProtocolSelector() {
        super(QuoteLineItem.SObjectType);
    }

    public override Set<SObjectField> GetDefaultFields() {
        return new Set<SObjectField> {
                QuoteLineItem.Id,
                QuoteLineItem.PricebookEntryId,
                QuoteLineItem.CreatedById,
                QuoteLineItem.CreatedDate,
                QuoteLineItem.LastModifiedById,
                QuoteLineItem.LastModifiedDate,
                QuoteLineItem.UnitPrice,
                QuoteLineItem.Fear_Best__c,
                QuoteLineItem.Fear_Worst__c,
                QuoteLineItem.Aggressive_Worst__c,
                QuoteLineItem.Arousal_Best__c,
                QuoteLineItem.Arousal_Worst__c,
                QuoteLineItem.Social_Best__c,
                QuoteLineItem.Overall_Score__c,
                QuoteLineItem.Novel_Person_Notes__c,
                QuoteLineItem.Novel_Person__c,
                QuoteLineItem.Protocol_Skipped__c,
                QuoteLineItem.Protocol_Notes__c,
                QuoteLineItem.Protocol_Box_Link__c,
                QuoteLineItem.IsSkipped__c,
                QuoteLineItem.IsRemoved__c,
                QuoteLineItem.ListPrice,
                QuoteLineItem.LineNumber,
                QuoteLineItem.Quantity,
                QuoteLineItem.IsDeleted ,
                QuoteLineItem.Product2Id ,
                QuoteLineItem.QuoteId
        };
    }
    public override List<iOrderBy> GetDefaultOrderBy() {
        return new List<iOrderBy> {
                OrderBy.Ascending(QuoteLineItem.LineNumber) ,
                OrderBy.Ascending(QuoteLineItem.Id)
        };
    }

    public List<QuoteLineItem> GetByIds(Set<Id> ids) {
        return queryById(ids);
    }

    public List<QuoteLineItem> GetByQuote(Id key) {
        List<QuoteLineItem> lineItems = GetQueryFactory().WithCriteria(Criteria.Equals(QuoteLineItem.QuoteId, key))
                .Execute();
        return lineItems;
    }

}