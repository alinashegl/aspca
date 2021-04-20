/**
 * Class description
 *
 * @author Lamar Barnett
 * 
 */
public with sharing class dao_Account extends sql_Dao {
    public dao_Account() {
        setSObject(Account.sObjectType);

        addField(Account.Id);
        addField(Account.Name);
    }

    //SANDBOX 
    public List<Account> findAccountsByNames(Set<String> names) {
        if(names == null || names.isEmpty()) {
            return new List<Account>();
        }

        return (List<Account>)getWhere(sql_Criteria.ValueIn(Account.Name, names));
    }

    public Account findOne(String accountId) {
        List<Account> accounts = getWhere(sql_Criteria.Equals(Account.Id, accountId));
        
        if(accounts.isEmpty()) {
            return null;
        }

        return accounts[0];
    }

    public List<Account> findAll() {
        return (List<Account>)getAll();
    }

    public List<Account> findAllByIds(Set<String> ids) {
        if(ids == null || ids.isEmpty()) {
            return new List<Account>();
        }

        return (List<Account>)getWhere(sql_Criteria.ValueIn(Account.Id, ids));
    }

    public List<Account> findAllByNames(Set<String> names) {
        if(names == null || names.isEmpty()) {
            return new List<Account>();
        }

        return (List<Account>)getWhere(sql_Criteria.ValueIn(Account.Name, names));
    }
}
