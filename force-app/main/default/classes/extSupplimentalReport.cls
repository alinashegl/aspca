public class extSupplimentalReport{

public list<Contact> lstContacts {get;set;}
public list<Contact> lstContactRoleComplainant {get;set;}
public Case ObjCase {get;set;}
set<Id>ConIdSet = new set<Id>();
set<Id>ComplinantConIdSet = new set<Id>();
public list<Scene_Locations__c> lstSceneLocation{get;set;}

 public list<integer> getrepeatDiv(){
        list<integer> repeatDiv = new list<integer>();
        for(integer i=0;i<3;i++){
                repeatDiv.add(i); 
        }
        return repeatDiv; 
    } 
      
    public extSupplimentalReport(ApexPages.StandardController controller) {
        id caseId=Apexpages.currentPage().getParameters().get('id');
            if(caseId!=null){
                 ObjCase = [Select c.contact.email,c.contact.title,c.contact.phone,c.contact.mobilephone,c.contact.fax,c.contact.name,AccountId,c.Account.Type,c.Account.Name,c.account.Phone, c.CaseNumber, c.Agency_Case__c,c.Account.BillingCountry, c.Account.BillingPostalCode,
                                 c.Account.BillingState, c.Account.BillingCity, c.Account.BillingStreet, c.Account.Fax,c.Description,c.contactid  From Case c Where Id =: caseId];
                
                for(CaseContactRole  Casecon :[Select c.Id, c.ContactId, c.Role, c.CasesId From CaseContactRole c where CasesId =:caseId]){
                    if(Casecon.role=='Suspect'){
                       ConIdSet.add(Casecon.ContactId);     
                    }
                        if(Casecon.Role=='Complainant' ){
                                ComplinantConIdSet.add(Casecon.ContactId);
                        }
                }
                
                 lstSceneLocation=[Select  s.name,s.Zipcode__c, s.State__c, s.Region__c, s.Primary_Incident_Location__c, s.CreatedDate, s.County__c,
                 s.City__c, s.Case__c, s.Address_Line_2__c, s.Address_1__c From Scene_Locations__c s where Case__c =:caseId AND Primary_Incident_Location__c= true];
                
                if(ConIdSet!=null && ConIdSet.Size()>0){
                lstContacts=[ Select  c.Account.EIN_Number__c,c.Salutation,c.Phone,c.Account.Name, c.Name, c.MobilePhone,   
                                      c.MailingStreet, c.MailingState, c.MailingPostalCode, c.MailingCountry, c.MailingCity,     
                                      c.License_or_ID_State__c, c.Account.website,c.Account.BillingCity,c.Account.BillingCountry,c.Account.BillingState, c.Account.Billingstreet,
                                      c.Account.BillingPostalCode,c.Account.Phone,c.LastName, c.Gender__c, c.FirstName, c.Financial_Resources__c, 
                                      c.Fax, c.Email,  c.Drivers_License_or_State_ID__c, c.Description,c.Birthdate,c.Alias__c,c.Age__c, c.AccountId,c.title From Contact c 
                                      Where Id IN :ConIdSet];    
                                        
                 }                       
                lstContactRoleComplainant=[Select c.Title, c.Salutation, 
                                         c.Phone, c.OwnerId, c.OtherStreet, c.OtherState, c.OtherPostalCode, c.OtherPhone, 
                                         c.OtherCountry, c.OtherCity, c.Name, c.MobilePhone,
                                         c.MasterRecordId, c.Marital_Status__c, c.MailingStreet, c.MailingState, c.MailingPostalCode, c.MailingCountry, c.MailingCity, 
                                         c.HomePhone, c.FirstName, c.Financial_Resources__c,c.Fax, c.Email From Contact c Where Id IN :ComplinantConIdSet]; 
                                
                Apexpages.currentPage().getHeaders().put( 'content-disposition', 'inline; filename=SupplementalReport.pdf' );
            
            }
    }

}