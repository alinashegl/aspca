/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class SessionProtocolSelector extends SObjectSelector{
    public SessionProtocolSelector() {
        super(QuoteLineItem.SObjectType);
    }
    public override Set<SObjectField> GetDefaultFields() {
        return new Set<SObjectField>{
                QuoteLineItem.Id,
                QuoteLineItem.Needs_Review__c,
                QuoteLineItem.CreatedDate,
                QuoteLineItem.CreatedById,
                QuoteLineItem.LastModifiedDate,
                QuoteLineItem.LastModifiedById,
                QuoteLineItem.Product2Id,
                QuoteLineItem.PricebookEntryId,
                QuoteLineItem.Fear_Best__c,
                QuoteLineItem.Fear_Worst__c,
                QuoteLineItem.Aggressive_Worst__c,
                QuoteLineItem.Arousal_Best__c,
                QuoteLineItem.Arousal_Worst__c,
                QuoteLineItem.Favorite_Motivators__c,
                QuoteLineItem.Protocol_Skipped__c,
                QuoteLineItem.Protocol_Notes__c,
                QuoteLineItem.Protocol_Box_Link__c,
                QuoteLineItem.Manager_Review_Notes__c,
                QuoteLineItem.IsSkipped__c,
                QuoteLineItem.IsRemoved__c,
                QuoteLineItem.Novel_Person__c,
                QuoteLineItem.Novel_Person_Notes__c,
                QuoteLineItem.Overall_Score__c,
                QuoteLineItem.Social_Best__c,
                QuoteLineItem.Review_Complete__c,
                QuoteLineItem.LineNumber
        };
    }
    public override List<iOrderBy> GetDefaultOrderBy() {
        return new List<iOrderBy> {
                OrderBy.Ascending(QuoteLineItem.Id) ,
                OrderBy.Ascending(QuoteLineItem.LineNumber)
        };
    }
    public List<Pricebook2> GetById(Set<Id> ids) {
        return queryById(ids);
    }

    public List<Pricebook2> GetByName(String name) {
        return queryByName(name);
    }

}