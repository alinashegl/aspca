@isTest
public with sharing class test_MultiPickToCheckboxGroupController {
    @isTest
    static void getCoordinatorPicklistValues() {
        Test.startTest();
        List<MultiPickToCheckboxGroupController.PicklistOption> options = MultiPickToCheckboxGroupController.getPicklistValues('Daily_Enrichment__c', 'Enrichment_Coordinator__c');
        Test.stopTest();
        System.assert(options.size() > 0);
    }

    @isTest
    static void getActivitiesPicklistValues() {
        Test.startTest();
        List<MultiPickToCheckboxGroupController.PicklistOption> options = MultiPickToCheckboxGroupController.getPicklistValues('Daily_Enrichment__c', 'Enrichment_Activities__c');
        Test.stopTest();
        System.assert(options.size() > 0);
    }

    @isTest
    static void baseClass() {
        Test.startTest();
        MultiPickToCheckboxGroupController.PicklistOption pO1 = new MultiPickToCheckboxGroupController.PicklistOption();
        pO1.label = 'label';
        pO1.value = 'value';
        MultiPickToCheckboxGroupController.PicklistOption pO2 = new MultiPickToCheckboxGroupController.PicklistOption('label', 'value');
        Test.stopTest();
        System.assertEquals(pO1.label, pO2.label);
        System.assertEquals(pO1.value, pO2.value);
    }
}