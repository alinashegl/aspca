/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */
@IsTest
private class test_cq {
    @isTest
    private static void simpleRegression() {
        Test.startTest();
        iUnitOfWork uow = cq.App.UoW;
        cq.App.MockSelectorBinding(Account.getSObjectType(), AccountSelector.class);
        Test.stopTest();
    }

    private class AccountSelector extends SObjectSelector {
        public AccountSelector() {
            super(Account.SObjectType);
        }

        public override Set<SObjectField> GetDefaultFields() {
            return new Set<SObjectField>{
                    Account.Id,
                    Account.Name
            };
        }

        public List<Account> GetById(Set<Id> idSet) {
            return (List<Account>) queryById(idSet);
        }

        public List<Account> GetByName(String name) {
            return (List<Account>) queryByName(name);
        }

        public List<Account> GetAll() {
            return (List<Account>) queryAll();
        }

        public List<Account> GetSome(Integer rowLimit) {
            return (List<Account>) querySome(rowLimit);
        }
    }
}