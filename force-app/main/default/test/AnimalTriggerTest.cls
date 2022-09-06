@isTest
public class AnimalTriggerTest {

    static testMethod void validateAnimalTrigger(){        
        Contact con = new Contact(LastName='Test', MailingCity='Test', MailingState='AK',County__c='Test');
        insert con;
        
        Animal__c anim = TestDataFactory.createAnimal();
      
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        Test.startTest();
        AnimalTriggerHandler.reverseGeoloc(40.75335663830957,-73.99213560828238, anim.Id);
        Test.stopTest();

        anim = [SELECT Id, Formatted_Address__c FROM Animal__c WHERE Id =: anim.Id LIMIT 1];
        System.assert(anim.Formatted_Address__c != null);
    }

    @isTest 
    static void createBRCMRCTasksNoExistingTasks(){
        Animal__c anim = TestDataFactory.createAnimal();
        Contact con = createGenericContact(anim.Current_Recent_Shelter_Location__c);
        anim.Behavior_Case_Worker__c = con.Id;

        test.startTest();
            AnimalTriggerHandler.createBrcMrcTasks(new Animal__c[]{anim});
        test.stopTest();

        Task[] tasks = [SELECT Id FROM Task WHERE recordType.DeveloperName =: AutoScheduleTasksUtil.MRC_BRC_FOLLOW_UP_TASK_RECORD_TYPE_NAME];
        System.assert(!tasks.isEmpty(), 'Should have returned a task, but was empty');
    }

    @isTest 
    static void createBRCMRCTasksWithExistingTaskDoNotCreateNewTask(){
        Animal__c anim = TestDataFactory.createAnimal();
        Contact con = createGenericContact(anim.Current_Recent_Shelter_Location__c);
        anim.Behavior_Case_Worker__c = con.Id;

        Task t = ScheduleAnimalBRCMRC.prepTask(anim, date.today().addDays(5), false);
        insert t;

        test.startTest();
            AnimalTriggerHandler.createBrcMrcTasks(new Animal__c[]{anim});
        test.stopTest();

        Task[] tasks = [SELECT Id FROM Task WHERE Record_Type__c =: AutoScheduleTasksUtil.MRC_BRC_FOLLOW_UP_TASK_RECORD_TYPE_NAME AND Id !=: t.Id];
        System.assert(tasks.isEmpty(), 'Should have returned an empty list, but was: ' + tasks);
    }

    @isTest 
    static void createBRCMRCTasksWithExistingTaskCreateNewTask(){
        Animal__c anim = TestDataFactory.createAnimal();
        Contact con = createGenericContact(anim.Current_Recent_Shelter_Location__c);
        anim.Behavior_Case_Worker__c = con.Id;

        Task t = ScheduleAnimalBRCMRC.prepTask(anim, date.today().addDays(-5), false);
        insert t;

        test.startTest();
            AnimalTriggerHandler.createBrcMrcTasks(new Animal__c[]{anim});
        test.stopTest();

        Task[] tasks = [SELECT Id FROM Task WHERE Record_Type__c =: AutoScheduleTasksUtil.MRC_BRC_FOLLOW_UP_TASK_RECORD_TYPE_NAME AND Id !=: t.Id];
        System.assert(!tasks.isEmpty(), 'Should have returned at least 1 task but was empty');
    }

    @isTest 
    static void updateHandlerDischargedContactChange(){
        Contact con1 = TestDataFactory.createContact();
        Contact con2 = TestDataFactory.createContact();
        Animal__c anim = TestDataFactory.createAnimal();
        anim.Discharged_to_Contact__c = con1.Id;

        Animal__c oldAnim = new Animal__c(
            Id = anim.Id,
            Discharged_to_Contact__c = con2.Id
        );

        test.startTest();
            AnimalTriggerHandler.updateHandler(
                new Animal__c[]{anim},
                new Map<Id, Animal__c>{anim.Id => oldAnim}
            );
        test.stopTest();

        CaseContactRole[] ccr = [SELECT Id FROM CaseContactRole WHERE CasesId =: anim.Case__c AND ContactId =: con1.Id];
        System.assert(!ccr.isEmpty(), 'Should have returned at least one CaeContactRole, but was empty');
    }

    @isTest 
    static void updateHandlerDischargedContactNotChanged(){
        Contact con = TestDataFactory.createContact();
        Animal__c anim = TestDataFactory.createAnimal();
        anim.Discharged_to_Contact__c = con.Id;

        Animal__c oldAnim = new Animal__c(
            Id = anim.Id,
            Discharged_to_Contact__c = con.Id
        );

        test.startTest();
            AnimalTriggerHandler.updateHandler(
                new Animal__c[]{anim},
                new Map<Id, Animal__c>{anim.Id => oldAnim}
            );
        test.stopTest();

        CaseContactRole[] ccrs = [SELECT Id FROM CaseContactRole WHERE CasesId =: anim.Case__c AND ContactId =: con.Id];
        System.assert(ccrs.isEmpty(), 'Should have returned an empty list, but was: ' + ccrs);
    }

    @isTest 
    static void updateHandlerDischargedDuplicateCCR(){
        Contact con1 = TestDataFactory.createContact();
        Contact con2 = TestDataFactory.createContact();
        Animal__c anim = TestDataFactory.createAnimal();
        anim.Discharged_to_Contact__c = con1.Id;

        Animal__c oldAnim = new Animal__c(
            Id = anim.Id,
            Discharged_to_Contact__c = con2.Id
        );

        CaseContactRole conrole = new CaseContactRole(
            CasesId = anim.Case__c,
            ContactId = con1.Id,
            Role = 'Animal Discharge Contact'
        );
        insert conRole;

        test.startTest();
            AnimalTriggerHandler.updateHandler(
                new Animal__c[]{anim},
                new Map<Id, Animal__c>{anim.Id => oldAnim}
            );
        test.stopTest();

        //new ccr should not be created becuase one for this case and contact already exists
        CaseContactRole[] ccrs = [SELECT Id FROM CaseContactRole WHERE CasesId =: anim.Case__c AND ContactId =: con1.Id];
        System.assert(!ccrs.isEmpty(), 'Should have returned one CaeContactRole, but was empty');
        System.assertEquals(1, ccrs.size());
    }

    @isTest 
    static void onBeforeUpdateHandlerMRCAccepted(){
        Animal__c anim = TestDataFactory.createAnimal();
        anim.MRC_Status__c = 'MRC Accepted';
        anim.Current_Recent_Shelter_Location__c = 'ARC';

        Animal__c oldAnim = new Animal__c(
            Id = anim.Id,
            MRC_Status__c = 'not MRC'
        );

        test.startTest();
            AnimalTriggerHandler.alreadyRan = false;
            AnimalTriggerHandler.onBeforeUpdateHandler(
                new Animal__c[]{anim},
                new Map<Id, Animal__c>{anim.Id => oldAnim}
            );
        test.stopTest();

        Task[] brcMrcTasks = [SELECT Id FROM Task WHERE recordType.DeveloperName =: AutoScheduleTasksUtil.MRC_BRC_FOLLOW_UP_TASK_RECORD_TYPE_NAME];
        System.assert(!brcMrcTasks.isEmpty(), 'Should have returned a task, but was empty');
    }

    private static Contact createGenericContact(String location){
        List<User> u = [SELECT Id, Location__c FROM User WHERE isActive = true AND Location__c =: location LIMIT 1];
        if(u.size() > 0){
            Contact con = new Contact(
                LastName = 'genericContact',
                Is_Generic_Contact__c = true,
                User__c = u[0].Id,
                Active__c = true
            );
            
            insert con;
            
            return con;
        }
        return null;
    }
}