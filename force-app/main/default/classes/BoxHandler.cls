// We need this for the future callout
public class BoxHandler {
     @future (callout=true)
     public static void createFolderFuture(Id accountId) {
        // Need to have Box Toolkit installed in space/sandbox
        box.Toolkit boxToolkit = new box.Toolkit();  
        // Get account ID
        //Account account = [SELECT Id FROM Account WHERE Id=:record];
        //System.debug(LoggingLevel.FINE, 'Creating a workspace for Account(' + account.Id + ')');
         // Actually create folder
        //String accountFolderId = boxToolkit.createFolderForRecordId(account.Id, null, true);
        String accountFolderId = boxToolkit.createFolderForRecordId(accountId, null, true);
        System.debug(LoggingLevel.FINE, 'Created Box Folder ID(' + accountFolderId + ')'); 
         // If there was an error, accountFolderId will be null. mostRecentError will contain the error message
         if(accountFolderId == null) {
             System.debug('most recent error: ' + boxToolkit.mostRecentError);
         }
        // Must call this
        boxToolkit.commitChanges();
    }
 
}