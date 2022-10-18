public with sharing class FacilityOutcomeTriggerHandler {
    private static List<Id> fosterIdList = new List<Id>();
    private static Set<Id> animalIdsForEvalProcess = new Set<Id>();
    private static Set<Id> foIdsForEvalProcess = new Set<Id>();

    public static void afterInsert(Facility_Outcome__c[] newRecords){
        for (Facility_Outcome__c foInsert : newRecords) {
            //Need to send survey for new Foster Home records
            //This checks for the Point of Contact since that's who would get the email
            if (foInsert.Facility_or_Outcome__c == 'Facility'
                && foInsert.Facility_Outcome__c == 'Foster Home'
                && foInsert.Point_of_Contact__c != null) {
                fosterIdList.add(foInsert.Id);
            }

            //if is ARC/CARE facility outcome add to animalIdsForEvalProcess            
            if(FacilityOutcomeUtil.EVAL_PROCESS_OUTCOME_OPTIONS.contains(foInsert.Facility_Outcome__c)){
                animalIdsForEvalProcess.add(foInsert.Animal__c);
                foIdsForEvalProcess.add(foInsert.Id);
            }
        }
    }

    public static void afterUpdate(Facility_Outcome__c[] newRecords, Map<Id, Facility_Outcome__c> oldMap){
        for (Facility_Outcome__c foUpdate : newRecords) {
            //Need to send survey for Foster Home records
            //when the Point of Contact gets either changed to another contact OR filled in from unassigned
            if(
                foUpdate.Facility_or_Outcome__c == 'Facility' &&
                foUpdate.Facility_Outcome__c ==  'Foster Home' &&
                (
                    (oldMap.get(foUpdate.Id).Point_of_Contact__c == null &&foUpdate.Point_of_Contact__c != null) ||
                    (oldMap.get(foUpdate.Id).Point_of_Contact__c != foUpdate.Point_of_Contact__c && foUpdate.Point_of_Contact__c != null)
                )
            ) {
                fosterIdList.add(foUpdate.Id);
            }
        }
    }

    public static void andFinally(){
        if(!fosterIdList.isEmpty()){
            FacilityOutcomeUtil.sendFosterSurveyEmail(fosterIdList);
        }

        if(!animalIdsForEvalProcess.isEmpty()){
            FacilityOutcomeUtil.handleEvaluationProcess(animalIdsForEvalProcess, foIdsForEvalProcess);
        }
    }
}