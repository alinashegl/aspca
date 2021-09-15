/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class AnimalSelector extends SObjectSelector{
    public AnimalSelector() {
        super(Animal__c.SObjectType);
    }

    public override Set<SObjectField> GetDefaultFields() {
        return new Set<SObjectField> {
                Animal__c.Name,
                Animal__c.Id ,
                Animal__c.Location__c ,
                Animal__c.External_Id__c ,
                Animal__c.ExternalId__c ,
                Animal__c.Extra_Enrichment__c ,
                Animal__c.Extra_Enrichment_Notes__c ,
                Animal__c.Age__c ,
                Animal__c.AAH_ID__c ,
                Animal__c.Animal_Name__c ,
                Animal__c.Animal_Age__c ,
                Animal__c.Current_Animal_Age_Estimate__c ,
                Animal__c.Current_Animal_Age_Formatted__c ,
                Animal__c.Current_Behavior_Grade__c ,
                Animal__c.Current_Behavior_Grade_Change_Date__c ,
                Animal__c.Current_Animal_Age_Estimate__c ,
                Animal__c.Current_Location__c ,
                Animal__c.BRC_Animal_Name__c ,
                Animal__c.Behavior_Case_Worker__c ,
                Animal__c.Case__c ,
                Animal__c.Case_Type__c ,
                Animal__c.Case_Number__c ,
                Animal__c.Legacy_FM_Animal_ID__c ,
                Animal__c.Confirmed_Helper_Dog__c ,
                Animal__c.Potential_Helper_Dog__c ,
                Animal__c.Handling_Instructions__c ,
                Animal__c.Photo1__c ,
                Animal__c.Photo2__c ,
                Animal__c.Photo_Document_Id__c ,
                Animal__c.Shelter_Location2__c ,
                Animal__c.Animal_Name__c
        };
    }
    public override List<iOrderBy> GetDefaultOrderBy() {
        return new List<iOrderBy> {
                (iOrderBy) OrderBy.Ascending(Animal__c.Name),
                (iOrderBy) OrderBy.Ascending(Animal__c.Id)
        };
    }

    public List<Animal__c> GetById(Set<Id> idSet) {
        return queryById(idSet);
    }
    public List<Animal__c> GetByName(String name) {
        return queryByName(name);
    }

    public List<Animal__c> GetAll() {
        return queryAll();
    }

    public List<Animal__c> GetSome(Integer rowLimit) {
        return querySome(rowLimit);
    }

    public List<Animal__c> GetByCase(String key) {
        List<Animal__c> animals = GetQueryFactory().WithCriteria(Criteria.Equals(Animal__c.Case__c, key)).Execute();
        return animals;
    }

}