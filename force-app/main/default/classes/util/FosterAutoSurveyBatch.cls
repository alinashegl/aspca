public class FosterAutoSurveyBatch implements Database.Batchable<sObject> {
    public String query;

    public Database.queryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Id> fosterIdList = new List<Id>();
        for (sObject s : scope) {
            Facility_Outcome__c fosterFacility = (Facility_Outcome__c)s;
            Integer daysDiff = fosterFacility.Start_Date__c.daysBetween(System.today());
            if(daysDiff == 7 || daysDiff == 14 || daysDiff == 21 || Math.mod(daysDiff, 28) == 0) {
                fosterIdList.add(fosterFacility.Id);
            }
        }
        if (fosterIdList.size() > 0) {
            FacilityOutcomeUtil.sendFosterSurveyEmail(fosterIdList);
        }
    }

    public void finish(Database.BatchableContext BC) {}
}