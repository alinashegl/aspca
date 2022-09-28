public with sharing class sql_TestAccountDAO extends sql_DAO
{
	public sql_TestAccountDAO() 
	{
		setSObject(Account.sObjectType);

		addField(Account.Id);
		addField(Account.Name);
		addField(Account.NumberOfEmployees);
		addField(Account.Industry);
		addField(Account.CreatedById);
		addField(Account.CreatedDate);

		addOrderBy(sql_Order.Ascending(Account.Name));
	}

	public Account getByIdWithContacts(Id acctId)
	{
		sql_Query child = new sql_Query();
		child.setSObject('Contacts');
		child.addField(Contact.Id);
		child.addField(Contact.Name);	
		child.addField(Contact.Birthdate);		
		addChild(child);

		return (Account) getById(acctId);
	}
}