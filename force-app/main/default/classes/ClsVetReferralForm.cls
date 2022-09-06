/**************************************************************************************************
* Name   : ClsVetReferralForm 
* Author : Jagdish Khantwal
* Date   : 27/July/2013 
* Purpose: This class is used to generate PDF for Animal_Exam_Sheet__c object and called from pagelaout Animal Exam Sheet, Buttons ( Create animal cage card and Veterinary Referral form )
* 
* ======================================
* = MODIFICATION HISTORY =
* ======================================
* DATE              AUTHOR               CHANGE
* ----              ------               ------
* 27/July/2013     Jagdish Khantwal      Created and completed the requirement.
* 
***************************************************************************************************/

public class ClsVetReferralForm {
    
    list<Animal_Exam_Sheet__c> lstAnimalExam {get;set;}
    public Animal_Exam_Sheet__c objAnimalExam{get;set;}
    public Date Today { get { return Date.today(); }}
   
    public ClsVetReferralForm ()
    {
         string animalId = ApexPages.currentPage().getparameters().get('Id');
         
         // PP: 09/16/2013 - Added Age Estimate - Age__c
         // PP: 09/27/2013 - Added Designated_Handler__c 
         lstAnimalExam = [select Id,Heartworm__c,FIV__c,FIV_Results__c, Felv_FIV__c,Name,Heartworm_Results__c, Babesia__c,Babesia_Results__c,Felv_FIV_Results__c,animal__r.Designated_Handler__c,animal__r.Shelter_Location__c,animal__r.name, animal__r.Animal_Name__c, animal__r.type_of_animal__c, animal__r.breed__c, animal__r.gender__c, animal__r.Age__c,animal__r.Animal_Age__c,animal__r.Intake_Date_Time__c, animal__r.Color__c,animal__r.Photo__c,animal__r.Photo2__c,animal__r.Photo_Document_Id__c from Animal_Exam_Sheet__c where animal__c =:animalId  limit 1];
         
         if(lstAnimalExam.size()>0)
             objAnimalExam = lstAnimalExam[0];
    
    }
        
}