public class FacilityOutcomeUtil {
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
}