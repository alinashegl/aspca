@isTest
public class SeizureEmailNotificationControllerTest {
    
    @isTest 
    static void SeizureEmailNotification(){
        Animal__c anim = TestDataFactory.createAnimal();
        Treatment_Bundle__c planBundle = createTreatmentBundle();
        Treatment_Plan__c plan = new Treatment_Plan__c(
          IsActive__c = true, 
          Description__c = 'Test', 
          Animal__c = anim.Id, 
          AssignedTreatmentBundleId__c = planBundle.Id,
          Problem_Behavior__c = 'Fear of People - Mild'
        );
        insert plan;
        Contact con = createGenericContact(anim.Current_Recent_Shelter_Location__c);
		anim.Behavior_Case_Worker__c = con.Id;
        anim.Email_Notification__c = true;
        update anim;
        Test.startTest();
        SeizureEmailNotificationController.handleSeizureEmailNotificationSchedular();
        Test.stopTest();
        Animal__c anm = [Select Email_Notification__c from Animal__c where id =: anim.Id];
        System.assertNotEquals(null, anm);
    }
    
    @isTest
    static void testSchedule(){
        Test.StartTest();
        SeizureEmailNotificationSchedulable sh1 = new SeizureEmailNotificationSchedulable();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
        System.assertNotEquals(null, sh1);
    }

     private static Contact createGenericContact(String location){
        User u = [SELECT Id, Location__c FROM User WHERE isActive = true AND Location__c =: location LIMIT 1];
        
        Contact con = new Contact(
            Email='kavya.reddy@aspca.org',
            LastName = 'genericContact',
            Is_Generic_Contact__c = true,
            User__c = u.Id,
            Active__c = true
        );

        insert con;

        return con;
    }
     public static Treatment_Bundle__c createTreatmentBundle() {
        Treatment_Bundle__c bundle = new Treatment_Bundle__c();
        bundle.Name = 'Test';
        bundle.IsActive__c = true;
        bundle.Enrichment_Activities__c = 'Nose Work;Snuffle mat;Tug pully';
        insert bundle;
        return bundle;
    }
}