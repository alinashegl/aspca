@isTest
public class test_Util {
    @TestSetup
    static void setupData() {
        EmailTemplate template = new EmailTemplate(
            developerName = EMAIL_TEMPLATE_DEVELOPER_NAME,
            TemplateType = EMAIL_TEMPLATE_TYPE,
            Name = EMAIL_TEMPLATE_NAME,
            FolderId = UserInfo.getOrganizationId(),
            IsActive = true);
        insert template;
    }

    @isTest
    static void getRecordTypeIdTest() {
        Id recordTypeId;
        System.assertEquals(null, recordTypeId);
        Test.startTest();
        recordTypeId = Util.getRecordTypeId('Case', 'Action_Item');
        Test.stopTest();
        System.assertNotEquals(null, recordTypeId);
    }

    @isTest
    static void getOrgWideEmailAddressValid() {
        Test.startTest();
        OrgWideEmailAddress emailAddress = Util.getOrgWideEmailAddress(VALID_ORG_WIDE_EMAIL);
        Test.stopTest();
        System.assertNotEquals(null, emailAddress);
        System.assertEquals(VALID_ORG_WIDE_EMAIL, emailAddress.DisplayName);
    }

    @isTest
    static void getOrgWideEmailAddressInvalid() {
        Test.startTest();
        OrgWideEmailAddress emailAddress = Util.getOrgWideEmailAddress(INVALID_ORG_WIDE_EMAIL);
        Test.stopTest();
        System.assertEquals(null, emailAddress);
    }

    @isTest
    static void getEmailTemplateIdValid() {
        Test.startTest();
        Id foundTemplateId = Util.getEmailTemplateId(EMAIL_TEMPLATE_DEVELOPER_NAME);
        Test.stopTest();
        EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :EMAIL_TEMPLATE_DEVELOPER_NAME LIMIT 1];
        System.assertEquals(template.Id, foundTemplateId);
    }

    @isTest
    static void getEmailTemplateIdInvalid() {
        Test.startTest();
        Id foundTemplateId = Util.getEmailTemplateId(EMAIL_TEMPLATE_NAME);
        Test.stopTest();
        System.assertEquals(null, foundTemplateId);
    }

    @isTest
    static void createContactEmailNoOrg() {
        Facility_Outcome__c facility = TestDataFactory.createFacilityOutcome();
        Id templateId = Util.getEmailTemplateId(EMAIL_TEMPLATE_DEVELOPER_NAME);
        Test.startTest();
        Messaging.SingleEmailMessage message = Util.createContactEmail(templateId, facility.Point_of_Contact__c, facility.Id, true);
        Test.stopTest();
        System.assertEquals(templateId, message.getTemplateId());
        System.assertEquals(facility.Point_of_Contact__c, message.getTargetObjectId());
        System.assertEquals(facility.Id, message.getWhatId());
        System.assertEquals(null, message.getOrgWideEmailAddressId());
    }

    @isTest
    static void createContactEmailWithOrg() {
        Facility_Outcome__c facility = TestDataFactory.createFacilityOutcome();
        Id templateId = Util.getEmailTemplateId(EMAIL_TEMPLATE_DEVELOPER_NAME);
        OrgWideEmailAddress orgWide = Util.getOrgWideEmailAddress(VALID_ORG_WIDE_EMAIL);
        Test.startTest();
        Messaging.SingleEmailMessage message = Util.createContactEmail(templateId, facility.Point_of_Contact__c, facility.Id, true, orgWide.Id);
        Test.stopTest();
        System.assertEquals(templateId, message.getTemplateId());
        System.assertEquals(facility.Point_of_Contact__c, message.getTargetObjectId());
        System.assertEquals(facility.Id, message.getWhatId());
        System.assertEquals(orgWide.Id, message.getOrgWideEmailAddressId());
    }

    private static final String
        EMAIL_TEMPLATE_DEVELOPER_NAME = 'Test_Email_Template',
        EMAIL_TEMPLATE_NAME = 'Test Email Template',
        EMAIL_TEMPLATE_TYPE = 'Text',
        VALID_ORG_WIDE_EMAIL = 'FIR Sheltering',
        INVALID_ORG_WIDE_EMAIL = 'Test';
}