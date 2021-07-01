/**
 * Created by barne on 5/13/2021.
 */

public with sharing class dao_Case extends sql_Dao {
    public dao_Case() {
        setSObject(Case.SObjectType);

        addField(Case.Id);
        addField(Case.RecordTypeId);
        addField(Case.Agency_Name__c);
        addField(Case.Agency_Case__c);
        addField(Case.Agency_Case_2__c);
        addField(Case.AccountId);
        addField(Case.Borough__c);
        addField(Case.ASPCA_Liaison__c);
        addField(Case.Animal_Breed_from_TIP_details__c);
        addField(Case.Call_Center__c);
        addField(Case.Category__c);
        addField(Case.Case_Origin_2__c);
        addField(Case.Case_Subtype__c);
        addField(Case.Deployment__c);
        addField(Case.Forensics_Case__c);
        addField(Case.Lead_Attorney__c);
        addField(Case.Secondary_Case_Type__c);
    }


}