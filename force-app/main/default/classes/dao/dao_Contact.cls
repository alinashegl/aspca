/**
 * Created by barne on 4/9/2021.
 */

public with sharing class dao_Contact extends sql_Dao{
    public dao_Contact() {
        setSObject(Contact.SObjectType);

        addField(Contact.Name);
        addField(Contact.Id);
        addField(Contact.Email);
        addField(Contact.Phone);
    }

    public List<Contact> findAll() {
        return (List<Contact>)getAll();
    }

    public Contact findOne(String id) {
        List<Contact> contacts = getWhere(sql_Criteria.Equals(Contact.Id, id));

        if (contacts.isEmpty()) { return null; }

        return contacts[0];
    }
}