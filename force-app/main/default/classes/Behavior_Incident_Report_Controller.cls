public class Behavior_Incident_Report_Controller {

    public Incidents__c incident {get;set;}
    public Animal__c anim {get;set;}
    public Contact contact {get;set;}
    
    public Behavior_Incident_Report_Controller(ApexPages.StandardController controller){
        
        incident = [SELECT Id
                    , Additional_Comments__c
                    , Animal__c
                    , Behaviors_Exhibited_by_the_Dog__c
                    , Clothing_Worn_at_Bite_Site__c
                    , Damage_Done_by_the_Dog__c
                    , If_dog_did_not_bite__c
                    , Incident_Date_Time__c
                    , Incident_Description__c
                    , Name
                    , Number_of_bites__c
                    , Other_Damage_Done_by_the_Dog__c
                    , Person_Involved__c
                    , Please_explain_why_you_think_so__c
                    , Report_Date__c
                    , Specific_Target_of_Dog_s_Behavior__c
                    , Type_of_Bite__c
                    , Was_Bitten_Area_Covered_with_Clothing__c
                    , Witnesses__c
                    , Animal__r.Name
                    , Animal__r.Animal_Name__c
/*                    , Contacts.Name
                    , Contacts.Contact__c*/
        FROM Incidents__c
        WHERE Name = '2022/01/20-0'];

    }
}