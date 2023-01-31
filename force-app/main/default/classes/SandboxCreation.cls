public with sharing class SandboxCreation {

    public static void updateAdminEmails() {

        Id adminProfileId = [SELECT Id FROM Profile 
                            WHERE Name = 'System Administrator'
                            LIMIT 1].Id;
    
        User[] adminUsers = [SELECT Email, Id
                            FROM User
                            WHERE ProfileId = :adminProfileId 
                            AND IsActive = true AND Email LIKE '%invalid'];
    
        for (User u : adminUsers) {
            system.debug(u.email);
            u.Email = u.Email.replace('.invalid',''); 
            system.debug(u.email);
        }  

        update adminUsers;
    }  
}