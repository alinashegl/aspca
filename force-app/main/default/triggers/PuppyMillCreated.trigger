trigger PuppyMillCreated on Account (after insert) {
    
		// There should only be one account created
	    Account a = Trigger.new[0];
        System.debug(a);
        Account record = [SELECT RecordtypeId, RecordType.name FROM Account WHERE Id =: a.Id];
        String typeName = record.RecordType.name;
        System.debug(typeName);
        // If it's a puppy mill, create Box folder
        if (typeName == 'Puppy Mill Agency') {
            System.debug('Creating Box Folder');
            String recordId = Trigger.new[0].Id;
            Account account = [SELECT Id FROM Account WHERE Id=:recordId];
            System.debug(LoggingLevel.FINE, 'Creating a workspace for Account(' + account.Id + ')');
			//BoxHandler.createFolderFuture(Trigger.new[0].Id);
			BoxHandler.createFolderFuture(account.Id);

		}


	
}