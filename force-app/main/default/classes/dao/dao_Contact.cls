/**
 * Created by barne on 4/9/2021.
 */

public with sharing class dao_Contact extends sql_Dao{
    public dao_Contact() {
        setSObject(Contact.SObjectType);

        addField(Contact.Name);
        addField(Contact.Id);
        addField(Contact.Email);
        addField(Contact.Phone);
    }

}