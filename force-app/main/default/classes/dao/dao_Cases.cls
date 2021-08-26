/**
 * Class description
 * @author Lamar Barnett
 * @version 1.0.0
 */

public with sharing class dao_Cases extends sql_Dao {
    public dao_Cases() {
        setSObject(Case.SObjectType);

        addField(Case.Id);
        addField(Case.AccountId);
        addField(Case.ContactId);
        addField(Case.Agency_Name__c);
        addField(Case.Intelligence_Report__c);
        addField(Case.Case_Subtype__c);
        addField(Case.Total_Animals__c);
        addField(Case.Total_Animals_Reported__c);
        addField(Case.Total_Animals_Rescued__c);
        addField(Case.OwnerId);
        addField(Case.RecordTypeId);
        addField(Case.Type);
    }

    public List<Contact> findAll(){
        return (List<Contact>)getAll();
    }

    public List<Contact> findById(Set<Id> ids){
        return (List<Contact>) getWhere(sql_Criteria.ValueIn(Case.Id, ids));
    }
}