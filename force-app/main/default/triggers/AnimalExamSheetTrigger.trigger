trigger AnimalExamSheetTrigger on Animal_Exam_Sheet__c (after insert, after update, after delete, after Undelete) {

        /*if(Trigger.isInsert || Trigger.isAfter){
            try {
                AnimalExamSheetTriggerHandler.insertHandler(); 
                          
            } catch (Exception e) {
                System.debug(e);
            }
        }*/
		AnimalExamSheetTriggerHandler.updateStormAnxietyandMedicationonAnimal();

}