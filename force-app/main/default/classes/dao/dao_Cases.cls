/**
 * Created by barne on 4/2/2021.
 */

public with sharing class dao_Cases extends sql_Dao{
    public dao_Cases() {
        setSObject(Case.SObjectType);

        addField(Case.Id);
        addField(Case.AccountId);
        addField(Case.Contact);
        addField(Case.Case_Contact_Roles__r);
        addField(Case.Agency_Name__c);
        addField(Case.Animals__r);
        addField(Case.Intelligence_Report__c);
        addField(Case.Case_Subtype__c);
        addField(Case.Total_Animals__c);
        addField(Case.Total_Animals_Reported__c);
        addField(Case.Total_Animals_Rescued__c);
        addField(Case.OwnerId);
        addField(Case.RecordTypeId);
        addField(Case.RecordType);
        addField(Case.Type);
    }

    public List<Contact> findAll(){
        return (List<Contact>)getAll();
    }

    public List<Contact> findById(Set<Id> ids){
        return (List<Contact>) getWhere(sql_Criteria.ValueIn(Case.Id, ids));
    }
}