@isTest
public with sharing class sql_Test 
{
	@isTest static void testAccountDAO() 
	{
		sql_TestData data = new sql_TestData();

		Set<String> industries = new Set<String>{ 'Construction', 'Energy' };
		Set<Id> users = new Set<Id>{ UserInfo.getUserId() };
		Set<Id> accts = new Set<Id> { data.acct1.Id };
		Decimal employees = 80;
		Date cdate = Date.today();
		Datetime current = Datetime.now();

		Test.startTest();

		Set<Id> acctIds = sql_Utility.getIds(Account.Id, new List<Account> { data.acct1 });

		sql_TestAccountDAO dao = new sql_TestAccountDAO();
		System.debug('@@@ Account: ' + dao.getById(data.acct1.Id));
		System.debug('@@@ Accounts: ' + dao.getByIds(accts));
		System.debug('@@@ Accounts: ' + dao.getAll());
		
		System.debug('@@@ Account: ' + dao.getByIdWithContacts(data.acct1.Id));

		System.debug('@@@ Accounts: ' + dao.getWhere(sql_Criteria.Equals(Account.Id, data.acct1.Id)));
		System.debug('@@@ Accounts: ' + dao.getWhere(sql_Criteria.NotEquals(Account.Id, data.acct1.Id)));

		System.debug('@@@ Accounts: ' + dao.getWhere(sql_Criteria.Equals(Account.CreatedDate, current)));
		System.debug('@@@ Accounts: ' + dao.getWhere(sql_Criteria.NotEquals(Account.CreatedDate, current)));
		System.debug('@@@ Accounts: ' + dao.getWhere(sql_Criteria.LessThan(Account.CreatedDate, current)));
		System.debug('@@@ Accounts: ' + dao.getWhere(sql_Criteria.LessThanEquals(Account.CreatedDate, current)));
		System.debug('@@@ Accounts: ' + dao.getWhere(sql_Criteria.GreaterThan(Account.CreatedDate, current)));
		System.debug('@@@ Accounts: ' + dao.getWhere(sql_Criteria.GreaterThanEquals(Account.CreatedDate, current)));

		System.debug('@@@ Accounts: ' + dao.getWhere(sql_Criteria.Equals(Account.NumberOfEmployees, employees)));
		System.debug('@@@ Accounts: ' + dao.getWhere(sql_Criteria.NotEquals(Account.NumberOfEmployees, employees)));
		System.debug('@@@ Accounts: ' + dao.getWhere(sql_Criteria.LessThan(Account.NumberOfEmployees, employees)));
		System.debug('@@@ Accounts: ' + dao.getWhere(sql_Criteria.LessThanEquals(Account.NumberOfEmployees, employees)));
		System.debug('@@@ Accounts: ' + dao.getWhere(sql_Criteria.GreaterThan(Account.NumberOfEmployees, employees)));
		System.debug('@@@ Accounts: ' + dao.getWhere(sql_Criteria.GreaterThanEquals(Account.NumberOfEmployees, employees)));

		String criteria = sql_Criteria.AndCriterias(new List<String> {
				sql_Criteria.ValueIn(Account.CreatedById, users),
				sql_Criteria.ValueIn(Account.Industry, industries),
				sql_Criteria.LessThan(Account.CreatedDate, Datetime.now())
			});

		System.debug('@@@ Accounts: ' + dao.getWhere(criteria));

		criteria = sql_Criteria.AndCriterias(new List<String> {
				sql_Criteria.ValueNotIn(Account.CreatedById, users),
				sql_Criteria.ValueNotIn(Account.Industry, industries),
				sql_Criteria.LessThan(Account.CreatedDate, Datetime.now())
			});

		System.debug('@@@ Accounts: ' + dao.getWhere(criteria));

		criteria = sql_Criteria.OrCriterias(new List<String> {
				sql_Criteria.ValueIn(Account.CreatedById, users),
				sql_Criteria.ValueIn(Account.Industry, industries),
				sql_Criteria.LessThan(Account.CreatedDate, Datetime.now())
			});

		System.debug('@@@ Accounts: ' + dao.getWhere(criteria));

		criteria = sql_Criteria.OrCriterias(new List<String> {
				sql_Criteria.ValueNotIn(Account.CreatedById, users),
				sql_Criteria.ValueNotIn(Account.Industry, industries),
				sql_Criteria.LessThan(Account.CreatedDate, Datetime.now())
			});

		System.debug('@@@ Accounts: ' + dao.getWhere(criteria));

		Test.stopTest();
	}
	
	@isTest static void testContactDAO() 
	{
		sql_TestData data = new sql_TestData();

		Set<String> sources = new Set<String>{ 'Google', 'Social Media' };
		Set<Id> users = new Set<Id>{ UserInfo.getUserId() };
		Set<Id> accts = new Set<Id> { data.acct1.Id, data.acct2.Id };
		Set<Id> conts = new Set<Id> { data.cont1.Id, data.cont2.Id, data.cont3.Id, data.cont4.Id };
		Date cdate = Date.today();
		Datetime current = Datetime.now();

		Test.startTest();

		sql_TestContactDAO dao = new sql_TestContactDAO();
		System.debug('@@@ Contact: ' + dao.getById(data.cont1.Id));
		System.debug('@@@ Contacts: ' + dao.getByIds(conts));
		System.debug('@@@ Contacts: ' + dao.getAll());

		System.debug('@@@ Contacts: ' + dao.getWhere(sql_Criteria.Equals(Contact.Id, data.cont1.Id)));
		System.debug('@@@ Contacts: ' + dao.getWhere(sql_Criteria.NotEquals(Contact.Id, data.cont1.Id)));

		System.debug('@@@ Contacts: ' + dao.getWhere(sql_Criteria.Equals(Contact.DoNotCall, true)));
		System.debug('@@@ Contacts: ' + dao.getWhere(sql_Criteria.NotEquals(Contact.DoNotCall, true)));

		System.debug('@@@ Contacts: ' + dao.getWhere(sql_Criteria.IsNull(Contact.Birthdate)));
		System.debug('@@@ Contacts: ' + dao.getWhere(sql_Criteria.IsNotNull(Contact.Birthdate)));

		System.debug('@@@ Contacts: ' + dao.getWhere(sql_Criteria.BeginsWith(Contact.Name, 'John')));
		System.debug('@@@ Contacts: ' + dao.getWhere(sql_Criteria.EndsWith(Contact.Name, 'Wilkerson')));
		System.debug('@@@ Contacts: ' + dao.getWhere(sql_Criteria.Contains(Contact.Name, 'Ralph')));

		String criteria = sql_Criteria.AndCriterias(new List<String> {
				sql_Criteria.ValueIn(Contact.CreatedById, users),
				sql_Criteria.ValueIn(Contact.LeadSource, sources),
				sql_Criteria.LessThan(Contact.CreatedDate, Datetime.now())
			});

		System.debug('@@@ Contacts: ' + dao.getWhere(criteria));

		criteria = sql_Criteria.OrCriterias(new List<String> {
				sql_Criteria.ValueIn(Contact.CreatedById, users),
				sql_Criteria.ValueIn(Contact.LeadSource, sources),
				sql_Criteria.LessThan(Contact.CreatedDate, Datetime.now())
			});

		System.debug('@@@ Contacts: ' + dao.getWhere(criteria));

		sql_Query nestedQuery = new sql_Query();
		nestedQuery.setSObject(Account.SObjectType);
		nestedQuery.addField(Account.Id);
		nestedQuery.setCriteria(sql_Criteria.Equals(Account.Industry, 'Energy'));

		System.debug('@@@ Accounts: ' + dao.getWhere(sql_Criteria.ValueIn(Contact.AccountId, nestedQuery)));
		System.debug('@@@ Accounts: ' + dao.getWhere(sql_Criteria.ValueNotIn(Contact.AccountId, nestedQuery)));

		Test.stopTest();
	}

	@isTest static void testUtility() 
	{
		sql_TestData data = new sql_TestData();

		Test.startTest();

		List<Contact> contacts = new List<Contact>();
		contacts.add(data.cont1);
		contacts.add(data.cont2);
		contacts.add(data.cont3);
		contacts.add(data.cont4);

		Set<String> values = sql_Utility.getValues(Contact.Name, contacts);
		Set<Id> ids1 = sql_Utility.getIds(Contact.Id, contacts);
		Set<Id> ids2 = sql_Utility.getIdsFor(Account.sObjectType, Contact.AccountId, contacts);

		Test.stopTest();
	}
}