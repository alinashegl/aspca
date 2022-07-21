public class CaseContactRoleExtension{

    public List<CaseContactRole> ContactRoles{get;set;}
    public List<CaseContactRole> CompRoles{get;set;}
    public List<CaseContactRole> WitnessRoles{get;set;}
    public List<Charge_Information__c> Charges{get; set;}
    public List<Scene_Locations__c> Locations{get;set;}
    public Date Today { get { return Date.today(); }}
    public list<Case> Cases{get;set;}
    public Case objCase{get;set;}
   
    public CaseContactRoleExtension(ApexPages.StandardController controller){ 
        Cases = [Select Id, CaseNumber, Account.Name, Account.BillingStreet, Account.BillingCity, Account.County__c, Account.BillingState, Account.BillingPostalCode, Account.Phone,Agency_Case__c, Contact.Name, Contact.Title, Contact.Phone, Contact.MobilePhone, Contact.Fax, Contact.Email, Description, Investigator__c  FROM Case WHERE Id = :ApexPages.currentPage().getparameters().get('Id')];
        if(Cases.size()>0)
            objCase = Cases[0];
        ContactRoles = [SELECT Contact.Name, Contact.Email, Contact.Gender__c, Contact.Alias__c, Contact.MailingStreet, Contact.MailingCity, Contact.MailingState, Contact.MailingPostalCode, Contact.County__c, Contact.Phone, Contact.MobilePhone, Role, Contact.License_or_ID_State__c, Contact.Drivers_License_or_State_ID__c, Contact.Account.Name, Contact.Account.Website, Contact.Account.BillingStreet, Contact.Account.BillingCity, Contact.Account.County__c, Contact.Account.BillingState, Contact.Account.BillingPostalCode, Contact.Account.Phone, Contact.Account.EIN_Number__c FROM CaseContactRole WHERE Role = 'Subject/Defendant' AND CasesId =:((Case)controller.getRecord()).Id];
        CompRoles = [SELECT Contact.Name, Contact.Email, Contact.MailingStreet, Contact.MailingCity, Contact.MailingState, Contact.MailingPostalCode, Contact.County__c, Contact.Phone, Contact.MobilePhone, Role FROM CaseContactRole WHERE Role = 'Complainant' AND CasesId =:((Case)controller.getRecord()).Id];
        WitnessRoles = [SELECT Contact.Name, Contact.Email, Contact.MailingStreet, Contact.MailingCity, Contact.MailingState, Contact.MailingPostalCode, Contact.County__c, Contact.Phone, Contact.MobilePhone, Role FROM CaseContactRole WHERE Role = 'Witness' AND CasesId =:((Case)controller.getRecord()).Id];
        Locations = [SELECT Name, Address_1__c, Address_Line_2__c, City__c, County__c, Primary_Incident_Location__c, Region__c, State__c, Zipcode__c FROM Scene_Locations__c WHERE Case__c =:((Case)controller.getRecord()).Id AND Primary_Incident_Location__c=True ORDER BY CreatedDate ASC];
        Charges = [SELECT Name, Charge_Level__c, Charge_Count__c FROM Charge_Information__c WHERE Case__c =:((Case)controller.getRecord()).Id ];
    }
}