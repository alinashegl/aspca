@isTest
public with sharing class dao_UserTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void FindOne_IdExistInDB_ReturnItem() {
        Boolean expectExistItem = true;            
        String expectId = TestDataFactory.getUserId();

        Test.startTest();

        dao_User daoUser = new dao_User();
        User resultItem = daoUser.findOne(expectId);
        System.debug('@@@ FindOne_IdExistInDB_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectExistItem, resultItem != null);
        System.assertEquals(expectId, resultItem.Id);

        Test.stopTest();
    }


    @isTest static void FindOne_IdNull_ReturnNull() {
        User expectNotExistItem = null;
            
        String id = null;

        Test.startTest();

        dao_User daoUser = new dao_User();
        User resultItem = daoUser.findOne(id);
        System.debug('@@@ FindOne_IdNull_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    
}