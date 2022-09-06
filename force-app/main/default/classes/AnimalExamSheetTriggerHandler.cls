public class AnimalExamSheetTriggerHandler {
    
    /*public static void insertHandler(){
        
        for (Animal_Exam_Sheet__c a : (List<Animal_Exam_Sheet__c>)Trigger.new){
                    
                    system.debug(a);
                        Animal__c anim = [SELECT Id, 
                                        Breed__c, 
                                        Gender__c, 
                                        Age__c, 
                                        Markings__c, 
                                        Color__c, 
                                        Secondary_Color__c, 
                                        Tertiary_Color__c, 
                                        Scanned_for_Microchip__c, 
                                        Microchip_Results__c, 
                                        Microchip_Number__c, 
                                        Equine_Body_Pattern__c,
                                        Equine_Leg_Marking__c ,
                                        Forensic_Status__c
                                        	FROM Animal__c WHERE Id = :a.Animal__c];
                    
                    system.debug(anim);
                        
                        if (a.Breed_Text__c != null){
                            anim.Breed__c = a.Breed_Text__c;
                        }
                        
                        if (a.Sex__c != null){
                            anim.Gender__c = a.Sex__c;
                        }
                        
                        if (a.Age_Estimate_Picklist__c != null){
                            anim.Age__c = a.Age_Estimate_Picklist__c;
                        }      
                        
                        if (a.Markings__c != null){
                            anim.Markings__c = a.Markings__c;
                        }      
                        if (a.Primary_Color__c != null){
                            anim.Color__c = a.Primary_Color__c;
                        }
                        if (a.Secondary_Color__c != null){
                            anim.Secondary_Color__c = a.Secondary_Color__c;
                        }
                        if (a.Tertiary_Color__c != null){
                            anim.Tertiary_Color__c = a.Tertiary_Color__c;
                        }
                        if (a.Scanned_for_Microchip__c != null){
                            anim.Scanned_for_Microchip__c = a.Scanned_for_Microchip__c;
                        }
                        if (a.Microchip_Results__c != null){
                            anim.Microchip_Results__c = a.Microchip_Results__c;
                        }
                        if (a.Microchip_Number__c != null){
                            anim.Microchip_Number__c = a.Microchip_Number__c;
                        }
                        if (a.Equine_Body_Pattern__c != null){
                            anim.Equine_Body_Pattern__c = a.Equine_Body_Pattern__c;
                        }
                        if (a.Equine_Leg_Marking__c != null){
                            anim.Equine_Leg_Marking__c = a.Equine_Leg_Marking__c;
                        }    
            			if (a.Forensic_Status__c != null){
                            anim.Forensic_Status__c = a.Forensic_Status__c;
                        }    
                        
                        update anim;
                    	system.debug(anim);
                    }
        
    }*/
   
    public static void updateStormAnxietyandMedicationonAnimal(){
        Set<Id> animalIds = new Set<Id>();
        if(Trigger.isInsert || Trigger.isUndelete){
            for(SObject aes : Trigger.new){
                animalIds.add((Id)aes.get('Animal__c'));
            }
        }
        if(Trigger.isUpdate || Trigger.isDelete){
            for(SObject aes : Trigger.old){
                animalIds.add((Id)aes.get('Animal__c'));
            }
        }
        List<Animal__c> anmList = [Select Id,Storm_Distress_Anxiety__c,Storm_Distress_Anxiety_Notes__c,Behavior_Medication_Flag__c, Behavior_Medication_Data_Time__c,(Select id, Subjective__c, Exam_Type__c  from Animal_Exam_Sheets__r WHERE RecordType.Name = 'Behavior Exam' Order By CreatedDate DESC) from Animal__c where Id IN : animalIds];
        for(Animal__c anm :anmList){
            for(Animal_Exam_Sheet__c aes : anm.Animal_Exam_Sheets__r){
                //anm.Storm_Distress_Anxiety__c = false;
                //anm.Storm_Distress_Anxiety_Notes__c = '';
                //anm.Behavior_Medication_Flag__c = false;
                if(aes.Exam_Type__c == 'Storm Distress/Anxiety'){
                    anm.Storm_Distress_Anxiety__c = true;
                    anm.Storm_Distress_Anxiety_Notes__c = anm.Animal_Exam_Sheets__r[0].Subjective__c ;
                    break;
                }
                if(aes.Exam_Type__c == 'Behavior Medications'){
                    anm.Behavior_Medication_Flag__c = true;
                    anm.Behavior_Medication_Data_Time__c = system.now();
                    break;
                }
            }
        }
        update anmList;
    }
}