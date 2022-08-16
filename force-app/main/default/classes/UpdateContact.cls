/**************************************************************************************************
* Name   : UpdateContact
* Author : 
* Date   : 10/25/2013 
* Purpose: This class updates the RecordType for Contact based on the role name.
* ======================================
* = MODIFICATION HISTORY =
* ======================================
* DATE              AUTHOR               CHANGE
* ----              ------               ------
* 10/25/2013                           Created and completed the requirement
* 
***************************************************************************************************/

public class UpdateContact {

    public static void process(List<Contact> lstContact) {
        Map <string, ContactRoleSettings__c> RoleNames = ContactRoleSettings__c.getAll();
        System.debug('RoleNames KeySet--> '+RoleNames.keyset());
        System.debug('RoleNames Values--> '+RoleNames.values());

        Map <String, String> mapRoleToRecordType = new Map<String, String>();
        if (RoleNames.size() > 0) {
            for (String name: RoleNames.keySet() ) {
                mapRoleToRecordType.put(name, RoleNames.get(name).RecordTypeName__c);      
            }
        }
        System.debug('mapRoleToRecordType ->'+mapRoleToRecordType);
        
        Map <String, Id> mapRoleToRecordTypeId = new Map<String, Id>();
        Set<id> setContactId;
        
        List<Account> lstAcct = [Select id, name from account where name = 'FIR Citizen' limit 1];
        // List<RecordType> lstRT = [Select r.Name, r.Id From RecordType r where r.Name = 'FIR Contacts' limit 1];
    	List<RecordType> lstContactRT = [Select r.Name, r.Id From RecordType r where r.Name in :mapRoleToRecordType.values()];
    	
    	for (RecordType contactRT: lstContactRT) {
    		mapRoleToRecordTypeId.put(contactRT.name, contactRT.id);
    	}

        for (Contact contact : lstContact) {
        	setContactId.add(contact.id);
        }
    	
        
        for (Contact contact : lstContact) {
            if (contact.accountid == null) {
                if (!lstAcct.isEmpty() )
                    contact.accountid = lstAcct[0].id;
                /*
                if (!lstRT.isEmpty() )
                    contact.RecordTypeId = lstRT[0].id;
                    */
            }
            
            
    }

    }
}