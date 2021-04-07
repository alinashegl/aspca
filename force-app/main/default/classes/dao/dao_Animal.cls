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
        addField(Animal__c.Breed__c);
        addField(Animal__c.Behavior_Case_Worker__c);//returns CaseWorker Id = sObjectType = Contact
        addField(Animal__c.Animal_Name__c);
        addField(Animal__c.Animal_Owner__c);//Returns OwnerId - sObjectType = User
        addField(Animal__c.Behavior_Concerns__c);
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