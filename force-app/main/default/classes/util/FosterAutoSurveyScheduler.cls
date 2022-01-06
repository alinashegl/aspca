public class FosterAutoSurveyScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        FosterAutoSurveyBatch surveyBatch = new FosterAutoSurveyBatch();
        surveyBatch.query = 'SELECT Id, Point_of_Contact__c, Start_Date__c ' +
                            'FROM Facility_OutCome__c ' +
                            'WHERE Facility_or_Outcome__c = \'Facility\' ' +
                            'AND Facility_Outcome__c = \'Foster Home\' ' +
                            'AND Point_of_Contact__c != null ' +
                            'AND Point_of_Contact__r.Email != null ' +
                            'AND Start_Date__c < TODAY ' +
                            'AND (End_Date__c = null OR End_Date__c > TODAY)';
        Database.executeBatch(surveyBatch);
    }
}