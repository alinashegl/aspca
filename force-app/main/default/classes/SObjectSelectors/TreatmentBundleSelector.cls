/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentBundleSelector extends SObjectSelector{
    public TreatmentBundleSelector() {
        super(Treatment_Bundle__c.SObjectType);
    }
    public override Set<SObjectField> GetDefaultFields() {
        return new Set<SObjectField> {
                Treatment_Bundle__c.Name,
                Treatment_Bundle__c.CreatedById ,
                Treatment_Bundle__c.CreatedDate ,
                Treatment_Bundle__c.Description__c ,
                Treatment_Bundle__c.LastModifiedById ,
                Treatment_Bundle__c.Id ,
                Treatment_Bundle__c.IsActive__c,
                Treatment_Bundle__c.IsMaster__c
        };
    }
    public override List<iOrderBy> GetDefaultOrderBy() {
        return new List<iOrderBy> {
                OrderBy.Ascending(Pricebook2.Name) ,
                OrderBy.Ascending(Pricebook2.Id)
        };
    }
    public List<Treatment_Bundle__c> GetById(Set<Id> ids) {
        return queryById(ids);
    }

    public List<Treatment_Bundle__c> GetByName(String name) {
        return queryByName(name);
    }

}