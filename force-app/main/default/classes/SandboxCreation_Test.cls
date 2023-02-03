@isTest
public with sharing class SandboxCreation_Test {
    public static final Id ADMINPROFILEID = [SELECT Id FROM Profile 
                           WHERE Name = 'System Administrator'
                           LIMIT 1].Id;
    public static final Id NONADMINPROFILEID = [SELECT Id FROM Profile 
                           WHERE Name != 'System Administrator'
                           LIMIT 1].Id;

    @TestSetup
    static void makeData(){
        Id adminProfile = [SELECT Id FROM Profile 
                           WHERE Name = 'System Administrator'
                           LIMIT 1].Id;
        Id nonaAdminProfile = [SELECT Id FROM Profile 
                           WHERE Name != 'System Administrator'
                           LIMIT 1].Id;
        User[] newUsers = new List<User>();
        newUsers.add(new User(Username='admin@aspca.org', Email='admin@aspca.org.invalid', IsActive = true, ProfileId = ADMINPROFILEID, LastName='admin', Alias='zzzadm01', localesidkey='en_US', emailencodingkey='UTF-8', languagelocalekey='en_US', TimeZoneSidKey= 'America/New_York'));
        newUsers.add(new User(Username='admin2@aspca.org', Email='admin@aspca.org.invalid', IsActive = false, ProfileId = ADMINPROFILEID, LastName='admin', Alias='zzzadm02', localesidkey='en_US', emailencodingkey='UTF-8', languagelocalekey='en_US', TimeZoneSidKey= 'America/New_York'));
        newUsers.add(new User(Username='nonadmin@aspca.org', Email='nonadmin@aspca.org.invalid', IsActive = true, ProfileId = NONADMINPROFILEID, LastName='nonadmin', Alias='zzznonad', localesidkey='en_US', emailencodingkey='UTF-8', languagelocalekey='en_US', TimeZoneSidKey= 'America/New_York'));

        insert newUsers;
    }
    
    
    //Execute test script with RunAsAutoProcUser set to true
    @isTest
    static void updateAdminEmails_Test() {

        Test.startTest();
        Test.testSandboxPostCopyScript(
            new SandboxCreation(), UserInfo.getOrganizationId(),
                UserInfo.getOrganizationId(), UserInfo.getOrganizationName(), true);
        Test.stopTest();

        Integer invalidCount = 0;
        Integer validCount = 0;
                    
        User[] newUsers = [Select Username, Email, IsActive, ProfileId FROM User WHERE Alias like 'zzz%'];
        System.assertEquals(3, newUsers.size(), 'Expecting 3 users');
        for (User u : newUsers) {
            if(!u.isActive || u.ProfileId != ADMINPROFILEID) {
                system.assert(u.Email.contains('.invalid'), 'users should have invalid emails');
                invalidCount++;
            }
            else {
                system.assert(!(u.Email.contains('.invalid')), 'users should have valid emails');
                validCount++;
            }
        }
        system.assertEquals(1, validCount);
        system.assertEquals(2, invalidCount);
    }

   
}