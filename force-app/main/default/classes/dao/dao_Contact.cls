/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 */
public with sharing class dao_Contact extends sql_Dao {
    public dao_Contact() {
        setSObject(Contact.sObjectType);

        addField(Contact.Id);
		addField(Contact.Name);
		addField(Contact.AccountId);
		addField(Contact.Email);
		addField(Contact.FirstName);
		addField(Contact.HomePhone);
		addField(Contact.LastName);
		addField(Contact.MailingCity);
		addField(Contact.MailingPostalCode);
		addField(Contact.MailingState);
		addField(Contact.MailingStreet);
		addField(Contact.MobilePhone);
		addField(Contact.OtherPhone);
		addField(Contact.Phone);
		addField(Contact.Title);
    }

    public Contact findOne(String id) {
        List<Contact> contacts = getWhere(sql_Criteria.Equals(Contact.Id, id));
        
        if(contacts.isEmpty()) {
            return null;
        }

        return contacts[0];
    }

    public List<Contact> findAll() {
        return (List<Contact>)getAll();
    }

    //TODO:UNIT TEST:ADD UNIT TEST
    public List<Contact> findContactsByEmails(Set<String> emails)
	{
		return (List<Contact>) getWhere(sql_Criteria.ValueIn(Contact.Email, emails));
	}
}