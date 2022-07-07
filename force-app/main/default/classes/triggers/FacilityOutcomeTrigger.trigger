trigger FacilityOutcomeTrigger on Facility_Outcome__c (after insert, after update) {
    if (Trigger.isAfter) {
        List<Id> fosterIdList = new List<Id>();
        if (Trigger.isInsert) {
            for (Facility_Outcome__c foInsert : Trigger.new) {
                //Need to send survey for new Foster Home records
                //This checks for the Point of Contact since that's who would get the email
                if (foInsert.Facility_or_Outcome__c == 'Facility'
                    && foInsert.Facility_Outcome__c == 'Foster Home'
                    && foInsert.Point_of_Contact__c != null) {
                    fosterIdList.add(foInsert.Id);
                }
            }
        }
        else if (Trigger.isAfter) {
            for (Facility_Outcome__c foUpdate : Trigger.new) {
                //Need to send survey for Foster Home records
                //when the Point of Contact gets either changed to another contact OR filled in from unassigned
                if(foUpdate.Facility_or_Outcome__c == 'Facility'
                    && foUpdate.Facility_Outcome__c ==  'Foster Home'
                    && (
                            (Trigger.oldMap.get(foUpdate.Id).Point_of_Contact__c == null
                            && foUpdate.Point_of_Contact__c != null)
                        || (Trigger.oldMap.get(foUpdate.Id).Point_of_Contact__c != foUpdate.Point_of_Contact__c
                            && foUpdate.Point_of_Contact__c != null)
                    )) {
                    fosterIdList.add(foUpdate.Id);
                }
            }
        }
        if (fosterIdList.size() > 0) {
            FacilityOutcomeUtil.sendFosterSurveyEmail(fosterIdList);
        }
    }
}