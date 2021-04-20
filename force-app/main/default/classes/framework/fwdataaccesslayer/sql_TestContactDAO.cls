public with sharing class sql_TestContactDAO extends sql_DAO
{
	public sql_TestContactDAO() 
	{
		setSObject(Contact.sObjectType);

		addField(Contact.Id);
		addField(Contact.Name);	
		addField(Contact.Birthdate);	
		addField(Contact.CreatedById);
		addField(Contact.CreatedDate);	
		addField(Contact.DoNotCall);
		addField(Contact.LeadSource);	

		addOrderBy(sql_Order.Ascending(Contact.Name));
		addOrderBy(sql_Order.Descending(Contact.Birthdate));
	}
}