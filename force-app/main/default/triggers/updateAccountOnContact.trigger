trigger updateAccountOnContact on Contact (before insert, before update) {
    
    System.debug('Update Contact'+trigger.new);
    
    //UpdateContact.process(trigger.new);
    List<Account> lstAcct = [Select id, name from account where name = 'FIR Citizen' limit 1];
    
    for (Contact contact : trigger.new) {
        if (contact.accountid == null) {
            if (!lstAcct.isEmpty() )
                contact.accountid = lstAcct[0].id;
        }
    }   
}