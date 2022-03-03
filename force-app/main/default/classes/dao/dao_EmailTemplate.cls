/**
 * Created by barne on 4/9/2021.
 */

public with sharing class dao_EmailTemplate extends sql_Dao{
    public dao_EmailTemplate() {
        setSObject(EmailTemplate.SObjectType);

        addField(EmailTemplate.Id);
        addField(EmailTemplate.Name);
        addField(EmailTemplate.DeveloperName);
        addField(EmailTemplate.FolderId);
        addField(EmailTemplate.Subject);
        addField(EmailTemplate.Body);


    }


}