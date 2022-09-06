/**
 * Class description
 *
 * @author Lamar Barnett
 * @version 1.0.0
 */

public with sharing class dao_Animal extends sql_Dao{
    public dao_Animal() {
        setSObject(Animal__c.SObjectType);

        addField(Animal__c.Id);
        addField(Animal__c.Name);
        addField(Animal__c.Petpoint_ID__c);
        addField(Animal__c.Breed__c);
        addField(Animal__c.Behavior_Case_Worker__c);//returns CaseWorker Id = sObjectType = Contact
        addField(Animal__c.Animal_Name__c);
        addField(Animal__c.Animal_Owner__c);//Returns OwnerId - sObjectType = User
        addField(Animal__c.Behavior_Concerns__c);
        addField(Animal__c.Animal_Field_ID__c);
        addField(Animal__c.Type_of_Animal__c); //Species
        addField(Animal__c.Color__c);
        addField(Animal__c.Current_Animal_Age_Formatted__c);
        addField(Animal__c.Gender__c);
        addField(Animal__c.Walking_Equipment__c);
        addField(Animal__c.Walking_Status__c);
        addField(Animal__c.Volunteer_Reading_Okay__c);
        addField(Animal__c.Case__c);
        addField(Animal__c.Location__c);
        addField(Animal__c.Shelter_Kennel__c);
        addField(Animal__c.Shelter_Location2__c);
        addField(Animal__c.Behavior_Summary__c);
    }

    public List<Animal__c> findAll() {
        return (List<Animal__c>)getAll();
    }

    public Animal__c findOne(String id) {
        List<Animal__c> animals =  getWhere(sql_Criteria.Equals(Animal__c.Id, id));

        if (animals.isEmpty()) { return null; }

        return animals[0];
    }
}