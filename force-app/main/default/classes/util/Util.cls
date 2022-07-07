public with sharing class Util {
    public static id getRecordTypeId(String objAPIName, string developerName){
        Id recTypeId = Schema.getGlobalDescribe().get(objAPIName).getDescribe().getRecordTypeInfosByDeveloperName().get(developerName).getRecordTypeId();

        return recTypeId;
    }

    public static Id getEmailTemplateId(String emailTemplateName) {
        try {
            Id emailTemplateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :emailTemplateName].Id;
            return emailTemplateId;
        }
        catch (Exception ex) {
            return null;
        }
    }

    public static OrgWideEmailAddress getOrgWideEmailAddress(String displayName) {
        try {
            OrgWideEmailAddress orgEmail = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress WHERE DisplayName = :displayName LIMIT 1];
            return orgEmail;
        }
        catch (Exception ex) {
            return null;
        }
    }

    /**
     * Renders email template for related object record. This method sends to Contact
     * type records for the To address. The From address would come from the
     * current users email.
     * 
     * @param templateId        The Id of the email template to render
     * @param targetObjectId    The Id of the Contact that will populate the To address
     * @param whatId            The Id of the sObject related to the specified email template
     * @param saveActivity      The boolean flag for saving the email activity to the related sObject
     * @return                  The constructed email message to be sent
     */
    public static Messaging.SingleEmailMessage createContactEmail(Id templateId, Id targetObjectId, Id whatId, Boolean saveActivity) {
        return createContactEmail(templateId, targetObjectId, whatId, saveActivity, null);
    }

    /**
     * Renders email template for related object record. This method sends to Contact
     * type records for the To address. The From address would come from the
     * specified org-wide email.
     * 
     * @param templateId        The Id of the email template to render
     * @param targetObjectId    The Id of the Contact that will populate the To address
     * @param whatId            The Id of the sObject related to the specified email template
     * @param saveActivity      The boolean flag for saving the email activity to the related sObject
     * @param orgWideEmailId    The Id of the org-wide email that will populate the From address
     * @return                  The constructed email message to be sent
     */
    public static Messaging.SingleEmailMessage createContactEmail(Id templateId, Id targetObjectId, Id whatId, Boolean saveActivity, Id orgWideEmailId) {
        //Sending a template to a Contact requires a TargetObjectId and an optional WhatId
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId(templateId);
        email.setTargetObjectId(targetObjectId);
        if (whatId != null) {
            email.setWhatId(whatId);
        }
        email.setSaveAsActivity(saveActivity);
        if (orgWideEmailId != null) {
            email.setOrgWideEmailAddressId(orgWideEmailId);
        }

        return email;
    }

    //translates a single location to a list of related locations
    public static String[] translateLocation(String location){
        String[] locations = new String[0];
        if(location != null){
            if(location.contains('ARC') || location.contains('CARE')){
                locations.addAll(new String[]{'ARC','CARE'});
            }
            else if(location.contains('MRC')|| location.contains('CRC')){
                locations.addAll(new String[]{'MRC','CRC'});
            }
            else if(location == 'All'){
                locations.addAll(new String[]{'ARC','CARE','MRC','CRC'});
            }
        }
        return locations;
    }
}