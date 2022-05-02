public with sharing class sql_TestData 
{
	public Account acct1 { get; set; }
	public Account acct2 { get; set; }
	public Contact cont1 { get; set; }
	public Contact cont2 { get; set; }
	public Contact cont3 { get; set; }
	public Contact cont4 { get; set; }

	public sql_TestData() 
	{
		acct1 = new Account();
		acct1.Name = 'TEST ACCT 1';
		acct1.NumberOfEmployees = 50;
		acct1.Industry = 'Construction';
		insert acct1;

		acct2 = new Account();
		acct2.Name = 'TEST ACCT 2';
		acct2.NumberOfEmployees = 100;
		acct2.Industry = 'Energy';
		insert acct2;

		cont1 = new Contact();
		cont1.FirstName = 'John';
		cont1.LastName = 'Daniel';
		cont1.AccountId = acct1.Id;
		cont1.Birthdate = Date.today();
		insert cont1;

		cont2 = new Contact();
		cont2.FirstName = 'Jane';
		cont2.LastName = 'Smith';
		cont2.AccountId = acct1.Id;
		insert cont2;

		cont3 = new Contact();
		cont3.FirstName = 'Ralph';
		cont3.LastName = 'Jones';
		cont3.AccountId = acct2.Id;
		cont3.Birthdate = Date.today();
		insert cont3;

		cont4 = new Contact();
		cont4.FirstName = 'Jane';
		cont4.LastName = 'Doe';
		cont4.AccountId = acct2.Id;
		insert cont4;
	}
}