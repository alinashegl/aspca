public class FacilityOutcomeUtil {
    public static final String[] EVAL_PROCESS_OUTCOME_OPTIONS = new String[]{'ARC','CARE'};
    public static void sendFosterSurveyEmail(List<Id> fosterIdList) {
        List<Messaging.SingleEmailMessage> fosterEmailList = new List<Messaging.SingleEmailMessage>();
        Id templateId = Util.getEmailTemplateId('Foster_Home_Survey');
        OrgWideEmailAddress orgWide = Util.getOrgWideEmailAddress('CRC Behavior Mgmt');
        Id orgWideId = orgWide == null ? null : orgWide.Id;
        for (Facility_Outcome__c foster : [SELECT Id, Point_of_Contact__c FROM Facility_Outcome__c WHERE Id IN :fosterIdList AND Point_of_Contact__r.Email != null]) {
            fosterEmailList.add(Util.createContactEmail(templateId, foster.Point_of_Contact__c, foster.Id, true, orgWideId));
        }
        //do not send emails if tests are running because it will fail if emails are turned off (typical in sandboxes)
        if(!test.isRunningTest()){
            Messaging.sendEmail(fosterEmailList);
        }
    }

    public static void handleEvaluationProcess(Set<Id> animalIds, Set<Id> foIds){
        //query the animals and their child facility/outcome records
        Animal__c[] toUpdate = new Animal__c[0];
        Task[] tasksToInsert = new Task[0];
        Date evalDueDate = Date.today().addDays(4);
        Id taskRecordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.EVALUATION_RECORD_TYPE_NAME);
        for(Animal__c dog : [
            SELECT Id, Evaluation_Due_Date__c, Behavior_Case_Worker__c,
            Animal_Name_Id__c, Current_Recent_Shelter_Location__c,
            (
                SELECT Id
                FROM Facilities_Outcomes__r
                WHERE Facility_Outcome__c IN :EVAL_PROCESS_OUTCOME_OPTIONS
                AND Id NOT IN :foIds
            )
            FROM Animal__c
            WHERE Id IN :animalIds
            AND Type_of_Animal__c = 'Dog'
        ]){
            //if there is only one facility outcome, we know we need to update the evalu due date and create a follow up task
            if(dog.Facilities_Outcomes__r.isEmpty()){
                dog.Evaluation_Due_Date__c = evalDueDate;
                toUpdate.add(dog);
            
                Task evalTask = new Task(
                    ActivityDate = evalDueDate,
                    Animal__c = dog.Id,
                    Description = 'Evaluation Due for: ' + dog.Animal_Name_Id__c + '(' + dog.Current_Recent_Shelter_Location__c + ')',
                    Priority = 'Normal',
                    RecordTypeId = taskRecordTypeId,
                    Species__c = 'Dog',
                    Status = 'Not Started',
                    Subject = 'Evaluation Due',
                    WhatId = dog.Id,
                    WhoId = dog.Behavior_Case_Worker__c
                );
                tasksToInsert.add(evalTask);
            }
        }

        update toUpdate;
        insert tasksToInsert;
    }
}