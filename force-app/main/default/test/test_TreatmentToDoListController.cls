@isTest
public with sharing class test_TreatmentToDoListController {
    @isTest
    static void getAnimalTreatmentsWithData() {
        User u = [SELECT Id, Location__c FROM User WHERE Id = :userInfo.getUserId() LIMIT 1];
        u.Location__c = 'All';
        update u;
        Treatment_Plan__c treatmentPlan = TestDataFactory.createPlan();
        Animal__c a = new Animal__c(Id=treatmentPlan.Animal__c, Current_Recent_Shelter_Location__c = 'CARE', Current_Location__c = 'ARC');
        update a;
        treatmentPlan.IsActive__c = TRUE;
        treatmentPlan.Treatment_Priority__c = 'Daily – 7 days';
        update treatmentPlan;

        String locationsFilter = prepLocationsFilter(true, false, 'ARC,CARE,ARC-CARE');

        Test.startTest();
        List<Treatment_Plan__c> treatmentPlans = TreatmentToDoListController.getAnimalTreatments(locationsFilter);
        Test.stopTest();
        System.assertEquals(1, treatmentPlans.size());
    }

    @isTest
    static void getAnimalTreatmentsWithoutData() {
        String locationsFilter = prepLocationsFilter(true, false, 'CRC,CRC-MRC');

        Test.startTest();
        List<Treatment_Plan__c> treatmentPlans = TreatmentToDoListController.getAnimalTreatments(locationsFilter);
        Test.stopTest();
        System.assertEquals(0, treatmentPlans.size());
    }

    @isTest
    static void getAnimalTreatmentsFromQueryTreatmentPlansForList() {
        Test.startTest();
        List<Treatment_Plan__c> treatmentPlans = new TreatmentToDoListController.QueryTreatmentPlansForList('CRC,CRC-MRC',true).treatmentPlanList;
        Test.stopTest();
        System.assertEquals(0, treatmentPlans.size());
    }

    @isTest
    static void getAnimalTreatmentsWithoutTreatmentPriority() {
        User u = [SELECT Id, Location__c FROM User WHERE Id = :userInfo.getUserId() LIMIT 1];
        u.Location__c = 'All';
        update u;
        Treatment_Plan__c treatmentPlan = TestDataFactory.createPlan();
        treatmentPlan.Treatment_Priority__c = null;
        update treatmentPlan;

        String locationsFilter = prepLocationsFilter(true, false, 'CRC,CRC-MRC');

        Test.startTest();
        List<Treatment_Plan__c> treatmentPlans = TreatmentToDoListController.getAnimalTreatments(locationsFilter);
        Test.stopTest();
        System.assertEquals(0, treatmentPlans.size());
    }
    
    @isTest
    static void testCloneRecord() {
        Treatment_Plan__c treatmentPlan = TestDataFactory.createPlan();
        SObject obj = TreatmentToDoListController.cloneRecord(treatmentPlan.Id);
        System.assertNotEquals(null, obj);
    }

    private static String prepLocationsFilter(Boolean hasConfig, Boolean showAll, String locations){
        Map<String, Object> locationsFilterMap = new Map<String, Object>{
            'hasConfigWithLocations' => (Object) hasConfig,
            'showAllLocations' => (Object) showAll,
            'locations' => (Object) locations
        };

        return JSON.serialize(locationsFilterMap);
    }
}