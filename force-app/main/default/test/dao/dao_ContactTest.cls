@isTest
public with sharing class dao_ContactTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void FindOne_IdExistInDB_ReturnItem() {
        Boolean expectExistItem = true;
        
        Contact ct = TestDataFactory.getContactFromDb();
        String expectId = ct.Id;

        Test.startTest();

        dao_Contact daoContact = new dao_Contact();
        Contact resultItem = daoContact.findOne(expectId);
        System.debug('@@@ FindOne_IdExistInDB_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectExistItem, resultItem != null);
        System.assertEquals(expectId, resultItem.Id);

        Test.stopTest();
    }

    @isTest static void FindOne_IdNotExistInDB_ReturnNull() {
        Contact expectNotExistItem = null;
        
        String id = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_Contact daoContact = new dao_Contact();
        Contact resultItem = daoContact.findOne(id);
        System.debug('@@@ FindOne_IdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOne_IdNull_ReturnNull() {
        Contact expectNotExistItem = null;
        
        String id = null;

        Test.startTest();

        dao_Contact daoContact = new dao_Contact();
        Contact resultItem = daoContact.findOne(id);
        System.debug('@@@ FindOne_IdNull_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindAll_WithoutParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Test.startTest();

        dao_Contact daoContact = new dao_Contact();
        List<Contact> resultListItems = daoContact.findAll();
        System.debug('@@@ FindAll_WithoutParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }
}