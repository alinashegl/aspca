/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentSessionSelector extends SObjectSelector {
    public TreatmentSessionSelector() {
        super(Treatment_Session__c.SObjectType);
    }

    public override Set<SObjectField> GetDefaultFields() {
        return new Set<SObjectField> {
                Treatment_Session__c.Name,
                Treatment_Session__c.Id,
                Treatment_Session__c.Treatment_Plan__c,
                Treatment_Session__c.Animal__c,
                Treatment_Session__c.CreatedById,
                Treatment_Session__c.CreatedDate,
                Treatment_Session__c.LastModifiedById,
                Treatment_Session__c.LastModifiedDate,
                Treatment_Session__c.Session_Notes__c ,
                Treatment_Session__c.Preferred_Motivators__c
        };
    }

    public List<Treatment_Session__c> GetByIds(Set<Id> ids) {
        return queryById(ids);
    }

    public List<Treatment_Session__c> GetByName(String name) {
        return queryByName(name);
    }

}