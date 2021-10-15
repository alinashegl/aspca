@isTest
public with sharing class test_ObservationQuickCreateController {
    @isTest
    static void getEnrichmentNotesSuccess() {
        Daily_Enrichment__c enrichment = TestDataFactory.createEnrichment();
        Test.startTest();
        Daily_Enrichment__c enrichmentNotes = ObservationQuickCreateController.getEnrichmentNotes(enrichment.Id);
        Test.stopTest();
        System.assertEquals(enrichment.Notes__c, enrichmentNotes.Notes__c);
        System.assertEquals(enrichment.Animal__c, enrichmentNotes.Animal__c);
    }

    @isTest
    static void getEnrichmentNotesWrongId() {
        Animal__c a = TestDataFactory.createAnimal();
        Test.startTest();
        Daily_Enrichment__c enrichmentNotes = ObservationQuickCreateController.getEnrichmentNotes(a.Id);
        Test.stopTest();
        System.assertEquals(null, enrichmentNotes);
    }

    @isTest
    static void getEnrichmentNotesBadId() {
        Daily_Enrichment__c enrichment = TestDataFactory.createEnrichment();
        String idDeleted = enrichment.Id;
        delete enrichment;
        Test.startTest();
        Daily_Enrichment__c enrichmentNotes = ObservationQuickCreateController.getEnrichmentNotes(idDeleted);
        Test.stopTest();
        System.assertEquals(null, enrichmentNotes);
    }

    @isTest
    static void createObservationHappyTail() {
        Daily_Enrichment__c enrichment = TestDataFactory.createEnrichment();
        Observation__c observation = new Observation__c(
            Observation_Reported_By__c = 'Reporter',
            Observation_Notes__c = enrichment.Notes__c,
            Animal__c = enrichment.Animal__c,
            Daily_Enrichment__c = enrichment.Id,
            Observation_Type__c = 'Happy Tail'
        );
        Test.startTest();
        Observation__c created = ObservationQuickCreateController.createQuickObservation(observation);
        Test.stopTest();
        System.assertEquals(enrichment.Id, created.Daily_Enrichment__c);
        System.assertEquals(enrichment.Notes__c, created.Observation_Notes__c);
        System.assertEquals(enrichment.Animal__c, created.Animal__c);
        System.assertEquals('Reporter', created.Observation_Reported_By__c);
        System.assertEquals('Happy Tail', created.Observation_Type__c);
    }

    @isTest
    static void createObservationConcern() {
        Daily_Enrichment__c enrichment = TestDataFactory.createEnrichment();
        Observation__c observation = new Observation__c(
            Observation_Reported_By__c = 'Reporter',
            Observation_Notes__c = enrichment.Notes__c,
            Animal__c = enrichment.Animal__c,
            Daily_Enrichment__c = enrichment.Id,
            Observation_Type__c = 'Concern'
        );
        Test.startTest();
        Observation__c created = ObservationQuickCreateController.createQuickObservation(observation);
        Test.stopTest();
        System.assertEquals(enrichment.Id, created.Daily_Enrichment__c);
        System.assertEquals(enrichment.Notes__c, created.Observation_Notes__c);
        System.assertEquals(enrichment.Animal__c, created.Animal__c);
        System.assertEquals('Reporter', created.Observation_Reported_By__c);
        System.assertEquals('Concern', created.Observation_Type__c);
    }

    @isTest
    static void createObservationBadRecord() {
        Observation__c observation = new Observation__c();
        Test.startTest();
        Observation__c created = ObservationQuickCreateController.createQuickObservation(observation);
        Test.stopTest();
        System.assertEquals(null, created);
    }
}