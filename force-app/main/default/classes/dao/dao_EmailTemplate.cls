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

    public EmailTemplate findOneByDeveloperName(String developerName) {
        List<EmailTemplate> templates = getWhere((String) sql_Criteria.Equals(EmailTemplate.DeveloperName, developerName));

        if (templates.isEmpty()) { return null; }

        return templates[0];
    }

}