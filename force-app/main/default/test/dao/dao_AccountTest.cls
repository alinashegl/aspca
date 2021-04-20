@isTest
public with sharing class dao_AccountTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void FindAccountsByNames_ListNames_ReturnNotEmptyList() {
        Set<String> names = TestDataFactory.getAccountsNames();
        Integer expectSizeList = names.size();
         
        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAccountsByNames(names);
        System.debug('@@@ FindAccountsByNames_ListNames_ReturnNotEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }

    @isTest static void FindAccountsByNames_EmptyList_ReturnEmptyList() {
        Integer expectSizeList = 0;
         
        Test.startTest();

        Set<String> names = new Set<String>();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAccountsByNames(names);
        System.debug('@@@ FindAccountsByNames_EmptyList_ReturnEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }


    @isTest static void FindAccountsByNames_ListNull_ReturnEmptyList() {
        Integer expectSizeList = 0;
         
        Test.startTest();

        Set<String> names = null;

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAccountsByNames(names);
        System.debug('@@@ FindAccountsByNames_ListNull_ReturnEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }
    



    @isTest static void FindOne_AccountIdNull_ReturnNull() {
        Account expectNotExistAccount = null;
         
        String accountId = null;

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        Account resultAccount = daoAccount.findOne(accountId);
        System.debug('@@@ FindOne_AccountIdNull_ReturnNull:result: ' + resultAccount);

        System.assertEquals(expectNotExistAccount, resultAccount);

        Test.stopTest();
    }

    @isTest static void FindAll_WithoutParams_ReturnNotEmptyList() {
        Integer expectSizeList = TestDataFactory.ACCOUNTS_COUNT;
         
        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAll();
        System.debug('@@@ FindAll_WithoutParams_ReturnNotEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }

    @isTest static void FindAllByIds_AccountsIdsExistInDB_ReturnNotEmptyList() {
        Set<String> ids = TestDataFactory.getAccountsIds();
        Integer expectSizeList = ids.size();

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_AccountsIdsExistInDB_ReturnNotEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }

   

    @isTest static void FindAllByIds_AccountsIdsEmptyList_ReturnEmptyList() {
        Set<String> ids = new Set<String>();
        Integer expectSizeList = 0;

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_AccountsIdsEmptyList_ReturnEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }

    @isTest static void FindAllByIds_AccountsIdsNull_ReturnEmptyList() {
        Set<String> ids = null;
        Integer expectSizeList = 0;

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_AccountsIdsNull_ReturnEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }

    @isTest static void FindAllByNames_NamesExistInDB_ReturnNotEmptyList() {
        Set<String> names = TestDataFactory.getAccountsNames();
        Integer expectSizeList = names.size();

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAllByNames(names);
        System.debug('@@@ FindAllByNames_NamesExistInDB_ReturnNotEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }



    @isTest static void FindAllByNames_NamesEmptyList_ReturnEmptyList() {
        Set<String> names = new Set<String>();
        Integer expectSizeList = 0;

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAllByNames(names);
        System.debug('@@@ FindAllByNames_NamesEmptyList_ReturnEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }

    @isTest static void FindAllByNames_NamesNull_ReturnEmptyList() {
        Set<String> names = null;
        Integer expectSizeList = 0;

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAllByNames(names);
        System.debug('@@@ FindAllByNames_NamesNull_ReturnEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }

    
}