@isTest
public with sharing class test_BehEvalPdfController {

    @isTest
    static void getPuppySummaryPdf() {
        Behavior_Evaluation__c behE = TestDataFactory.createPuppyBehaviorEvaluation();
        Test.startTest();
        PageReference behEvalPdf = Page.BehEvalPdf;
        Test.setCurrentPage(behEvalPdf);
        ApexPages.currentPage().getParameters().put('id', behE.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(behE);
        BehEvalPdfController behController = new BehEvalPdfController(sc);
        Test.stopTest();
        System.assertEquals(behE.Id, behController.behEval.Id);
        System.assertEquals(behE.Evaluation_Subtype__c, behController.behEval.Evaluation_Subtype__c);
        System.assertEquals(null, behController.paramForensic);
        System.assertEquals(2, behController.potentBehIssue.size());
        System.assert(behController.summary.contains('Dog Interaction:'));
        System.assert(behController.evaluation.size() > 0);
    }

    @isTest
    static void getPuppyForensicPdf() {
        Behavior_Evaluation__c behE = TestDataFactory.createPuppyBehaviorEvaluation();
        Test.startTest();
        PageReference behEvalPdf = Page.BehEvalPdf;
        Test.setCurrentPage(behEvalPdf);
        ApexPages.currentPage().getParameters().put('id', behE.Id);
        ApexPages.currentPage().getParameters().put('forensic', 'true');
        ApexPages.StandardController sc = new ApexPages.StandardController(behE);
        BehEvalPdfController behController = new BehEvalPdfController(sc);
        Test.stopTest();
        System.assertEquals(behE.Id, behController.behEval.Id);
        System.assertEquals(behE.Evaluation_Subtype__c, behController.behEval.Evaluation_Subtype__c);
        System.assertEquals(true, behController.paramForensic);
        System.assertEquals(2, behController.potentBehIssue.size());
        System.assert(behController.summary.contains('Dog Interaction:'));
        System.assert(behController.evaluation.size() > 0);
    }

    @isTest
    static void getAdultSummaryPdf() {
        Behavior_Evaluation__c behE = TestDataFactory.createAdultBehaviorEvaluation(false);
        Test.startTest();
        PageReference behEvalPdf = Page.BehEvalPdf;
        Test.setCurrentPage(behEvalPdf);
        ApexPages.currentPage().getParameters().put('id', behE.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(behE);
        BehEvalPdfController behController = new BehEvalPdfController(sc);
        Test.stopTest();
        System.assertEquals(behE.Id, behController.behEval.Id);
        System.assertEquals(behE.Evaluation_Subtype__c, behController.behEval.Evaluation_Subtype__c);
        System.assertEquals(null, behController.paramForensic);
        System.assertEquals(2, behController.potentBehIssue.size());
        System.assert(behController.summary.contains('Same Sex:'));
        System.assert(behController.evaluation.size() > 0);
    }

    @isTest
    static void getAdultForensicPdf() {
        Behavior_Evaluation__c behE = TestDataFactory.createAdultBehaviorEvaluation(false);
        Test.startTest();
        PageReference behEvalPdf = Page.BehEvalPdf;
        Test.setCurrentPage(behEvalPdf);
        ApexPages.currentPage().getParameters().put('id', behE.Id);
        ApexPages.currentPage().getParameters().put('forensic', 'true');
        ApexPages.StandardController sc = new ApexPages.StandardController(behE);
        BehEvalPdfController behController = new BehEvalPdfController(sc);
        Test.stopTest();
        System.assertEquals(behE.Id, behController.behEval.Id);
        System.assertEquals(behE.Evaluation_Subtype__c, behController.behEval.Evaluation_Subtype__c);
        System.assertEquals(true, behController.paramForensic);
        System.assertEquals(2, behController.potentBehIssue.size());
        System.assert(!behController.summary.contains('Same Sex:'));
        System.assert(behController.evaluation.size() > 0);
    }

    @isTest
    static void getDogFightingSummaryPdf() {
        Behavior_Evaluation__c behE = TestDataFactory.createAdultBehaviorEvaluation(true);
        Test.startTest();
        PageReference behEvalPdf = Page.BehEvalPdf;
        Test.setCurrentPage(behEvalPdf);
        ApexPages.currentPage().getParameters().put('id', behE.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(behE);
        BehEvalPdfController behController = new BehEvalPdfController(sc);
        Test.stopTest();
        System.assertEquals(behE.Id, behController.behEval.Id);
        System.assertEquals(behE.Evaluation_Subtype__c, behController.behEval.Evaluation_Subtype__c);
        System.assertEquals(null, behController.paramForensic);
        System.assertEquals(2, behController.potentBehIssue.size());
        System.assert(behController.summary.contains('Same Sex:'));
        System.assert(behController.evaluation.size() > 0);
    }

    @isTest
    static void getDogFightingForensicPdf() {
        Behavior_Evaluation__c behE = TestDataFactory.createAdultBehaviorEvaluation(true);
        Test.startTest();
        PageReference behEvalPdf = Page.BehEvalPdf;
        Test.setCurrentPage(behEvalPdf);
        ApexPages.currentPage().getParameters().put('id', behE.Id);
        ApexPages.currentPage().getParameters().put('forensic', 'true');
        ApexPages.StandardController sc = new ApexPages.StandardController(behE);
        BehEvalPdfController behController = new BehEvalPdfController(sc);
        Test.stopTest();
        System.assertEquals(behE.Id, behController.behEval.Id);
        System.assertEquals(behE.Evaluation_Subtype__c, behController.behEval.Evaluation_Subtype__c);
        System.assertEquals(true, behController.paramForensic);
        System.assertEquals(2, behController.potentBehIssue.size());
        System.assert(!behController.summary.contains('Same Sex:'));
        System.assert(behController.evaluation.size() > 0);
    }

    @isTest
    static void getDogOnlySummaryPdf() {
        Behavior_Evaluation__c behE = TestDataFactory.createDogOnlyBehaviorEvaluation();
        Test.startTest();
        PageReference behEvalPdf = Page.BehEvalPdf;
        Test.setCurrentPage(behEvalPdf);
        ApexPages.currentPage().getParameters().put('id', behE.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(behE);
        BehEvalPdfController behController = new BehEvalPdfController(sc);
        Test.stopTest();
        System.assertEquals(behE.Id, behController.behEval.Id);
        System.assertEquals(behE.Evaluation_Subtype__c, behController.behEval.Evaluation_Subtype__c);
        System.assertEquals(null, behController.paramForensic);
        System.assertEquals(2, behController.potentBehIssue.size());
        System.assert(behController.summary.contains('Same Sex:'));
        System.assert(behController.evaluation.size() > 0);
    }

    @isTest
    static void getDogOnlyForensicPdf() {
        Behavior_Evaluation__c behE = TestDataFactory.createDogOnlyBehaviorEvaluation();
        Test.startTest();
        PageReference behEvalPdf = Page.BehEvalPdf;
        Test.setCurrentPage(behEvalPdf);
        ApexPages.currentPage().getParameters().put('id', behE.Id);
        ApexPages.currentPage().getParameters().put('forensic', 'true');
        ApexPages.StandardController sc = new ApexPages.StandardController(behE);
        BehEvalPdfController behController = new BehEvalPdfController(sc);
        Test.stopTest();
        System.assertEquals(behE.Id, behController.behEval.Id);
        System.assertEquals(behE.Evaluation_Subtype__c, behController.behEval.Evaluation_Subtype__c);
        System.assertEquals(true, behController.paramForensic);
        System.assertEquals(2, behController.potentBehIssue.size());
        System.assert(!behController.summary.contains('Same Sex:'));
        System.assert(behController.evaluation.size() == 0);
    }

    @isTest
    static void objectWrapperTest() {
        Test.startTest();
        BehEvalPdfController.FieldGroup fGroup1 = new BehEvalPdfController.FieldGroup();
        fGroup1.fieldOrder = 3;
        fGroup1.isSelected = true;
        fGroup1.fieldTypeOrder = 3;
        fGroup1.fieldType = 'Third 3';
        fGroup1.fieldTypeDescription = 'Third item';
        BehEvalPdfController.FieldGroup fGroup2 = new BehEvalPdfController.FieldGroup();
        fGroup2.fieldOrder = 3;
        fGroup2.isSelected = false;
        fGroup2.fieldTypeOrder = 1;
        fGroup2.fieldType = 'Third 1';
        fGroup2.fieldTypeDescription = 'Third item';
        BehEvalPdfController.FieldGroup fGroup3 = new BehEvalPdfController.FieldGroup(3, true, 2, 'Third 2', 'Third item');
        BehEvalPdfController.FieldGroup fGroup4 = new BehEvalPdfController.FieldGroup(1, true, 1, 'First 1', 'First item');
        BehEvalPdfController.FieldGroup fGroup5 = new BehEvalPdfController.FieldGroup(2, true, 1, 'Second 1', 'Second item');
        List<BehEvalPdfController.FieldGroup> fieldGroupList = new List<BehEvalPdfController.FieldGroup>{fGroup1, fGroup2, fGroup3, fGroup4, fGroup5};
        fieldGroupList.sort();
        BehEvalPdfController.ValueGroup vGroup1 = new BehEvalPdfController.ValueGroup();
        vGroup1.valueCategory = 3;
        vGroup1.fieldOrder = 3;
        vGroup1.fieldValue = 'Third 3';
        vGroup1.fieldDescription = 'Third item';
        vGroup1.fields = fieldGroupList;
        BehEvalPdfController.ValueGroup vGroup2 = new BehEvalPdfController.ValueGroup();
        vGroup2.valueCategory = 3;
        vGroup2.fieldOrder = 1;
        vGroup2.fieldValue = 'Third 3';
        vGroup2.fieldDescription = 'Third item';
        vGroup2.fields = fieldGroupList;
        BehEvalPdfController.ValueGroup vGroup3 = new BehEvalPdfController.ValueGroup(3, 2, 'Third 2', 'Third item', fieldGroupList);
        BehEvalPdfController.ValueGroup vGroup4 = new BehEvalPdfController.ValueGroup(1, 1, 'First 1', 'First item', fieldGroupList);
        BehEvalPdfController.ValueGroup vGroup5 = new BehEvalPdfController.ValueGroup(2, 1, 'Second 1', 'Second item', fieldGroupList);
        List<BehEvalPdfController.ValueGroup> valueGroupList = new List<BehEvalPdfController.ValueGroup>{vGroup1, vGroup2, vGroup3, vGroup4, vGroup5};
        valueGroupList.sort();
        BehEvalPdfController.OptionalField oField1 = new BehEvalPdfController.OptionalField();
        oField1.selectedValue = 'Selected';
        oField1.availableValues = new List<String>{'Selected', 'Not Selected'};
        BehEvalPdfController.OptionalField oField2 = new BehEvalPdfController.OptionalField('Selected', new List<String>{'Selected', 'Not Selected'});
        BehEvalPdfController.EvaluationGroup evalGroup1 = new BehEvalPdfController.EvaluationGroup();
        evalGroup1.groupOrder = 3;
        evalGroup1.groupValue = 'Third';
        evalGroup1.headerValue = 'Third description';
        evalGroup1.optionalValue = oField1;
        evalGroup1.skipValue = 'Skipped for reasons';
        evalGroup1.commentValue = 'Comments here';
        evalGroup1.valueGroup0 = new List<BehEvalPdfController.ValueGroup>{vGroup1};
        evalGroup1.valueGroup1 = new List<BehEvalPdfController.ValueGroup>{vGroup2};
        evalGroup1.valueGroup2 = new List<BehEvalPdfController.ValueGroup>{vGroup3};
        evalGroup1.valueGroup3 = new List<BehEvalPdfController.ValueGroup>{vGroup4};
        evalGroup1.valueGroup4 = new List<BehEvalPdfController.ValueGroup>{vGroup5};
        BehEvalPdfController.EvaluationGroup evalGroup2 = new BehEvalPdfController.EvaluationGroup();
        evalGroup2.groupOrder = 1;
        evalGroup2.groupValue = 'First';
        evalGroup2.headerValue = 'First description';
        evalGroup2.optionalValue = oField1;
        evalGroup2.skipValue = 'Skipped for reasons';
        evalGroup2.commentValue = 'Comments here';
        evalGroup2.valueGroup0 = new List<BehEvalPdfController.ValueGroup>{vGroup1};
        evalGroup2.valueGroup1 = new List<BehEvalPdfController.ValueGroup>{vGroup2};
        evalGroup2.valueGroup2 = new List<BehEvalPdfController.ValueGroup>{vGroup3};
        evalGroup2.valueGroup3 = new List<BehEvalPdfController.ValueGroup>{vGroup4};
        evalGroup2.valueGroup4 = new List<BehEvalPdfController.ValueGroup>{vGroup5};
        BehEvalPdfController.EvaluationGroup evalGroup3 = new BehEvalPdfController.EvaluationGroup(
            2,
            'Second',
            'Second description',
            oField2,
            'Skipped for reasons',
            'Comments here',
            new List<BehEvalPdfController.ValueGroup>{vGroup1},
            new List<BehEvalPdfController.ValueGroup>{vGroup2},
            new List<BehEvalPdfController.ValueGroup>{vGroup3},
            new List<BehEvalPdfController.ValueGroup>{vGroup4},
            new List<BehEvalPdfController.ValueGroup>{vGroup5});
        List<BehEvalPdfController.EvaluationGroup> evalGroupList = new List<BehEvalPdfController.EvaluationGroup>{evalGroup1, evalGroup2, evalGroup3};
        evalGroupList.sort();
        BehEvalPdfController.EvaluationGroup evalGroup4 = new BehEvalPdfController.EvaluationGroup(
            1,
            '',
            '',
            oField2,
            '',
            '',
            new List<BehEvalPdfController.ValueGroup>(),
            new List<BehEvalPdfController.ValueGroup>(),
            new List<BehEvalPdfController.ValueGroup>(),
            new List<BehEvalPdfController.ValueGroup>(),
            new List<BehEvalPdfController.ValueGroup>());
            BehEvalPdfController.EvaluationGroup evalGroup5 = new BehEvalPdfController.EvaluationGroup();
            BehEvalPdfController.EvaluationGroup evalGroup6 = new BehEvalPdfController.EvaluationGroup();
            evalGroup6.valueGroup1 = new List<BehEvalPdfController.ValueGroup>{new BehEvalPdfController.ValueGroup()};
        Test.stopTest();
        //evaluation groups
        for (Integer i = 0; i < evalGroupList.size(); i++) {
            System.assertEquals(i + 1, evalGroupList[i].groupOrder);
            System.assertEquals(1, evalGroupList[i].valueGroup0.size());
            System.assertEquals(1, evalGroupList[i].valueGroup1.size());
            System.assertEquals(1, evalGroupList[i].valueGroup2.size());
            System.assertEquals(1, evalGroupList[i].valueGroup3.size());
            System.assertEquals(1, evalGroupList[i].valueGroup4.size());
            System.assertEquals(true, evalGroupList[i].hasGroup0);
            System.assertEquals(true, evalGroupList[i].hasGroup1);
            System.assertEquals(true, evalGroupList[i].hasGroup2);
            System.assertEquals(true, evalGroupList[i].hasGroup3);
            System.assertEquals(true, evalGroupList[i].hasGroup4);
            System.assertEquals(true, evalGroupList[i].hasFieldTypes);
        }
        System.assertEquals(false, evalGroup4.hasFieldTypes);
        System.assertEquals(false, evalGroup5.hasFieldTypes);
        System.assertEquals(false, evalGroup6.hasFieldTypes);
        //value groups
        System.assertEquals(1, valueGroupList[0].valueCategory);
        System.assertEquals(2, valueGroupList[1].valueCategory);
        System.assertEquals(3, valueGroupList[2].valueCategory);
        System.assertEquals(3, valueGroupList[3].valueCategory);
        System.assertEquals(3, valueGroupList[4].valueCategory);
        System.assertEquals(1, valueGroupList[0].fieldOrder);
        System.assertEquals(1, valueGroupList[1].fieldOrder);
        System.assertEquals(1, valueGroupList[2].fieldOrder);
        System.assertEquals(2, valueGroupList[3].fieldOrder);
        System.assertEquals(3, valueGroupList[4].fieldOrder);
        //field groups
        System.assertEquals(1, fieldGroupList[0].fieldOrder);
        System.assertEquals(2, fieldGroupList[1].fieldOrder);
        System.assertEquals(3, fieldGroupList[2].fieldOrder);
        System.assertEquals(3, fieldGroupList[3].fieldOrder);
        System.assertEquals(3, fieldGroupList[4].fieldOrder);
        System.assertEquals(1, fieldGroupList[0].fieldTypeOrder);
        System.assertEquals(1, fieldGroupList[1].fieldTypeOrder);
        System.assertEquals(1, fieldGroupList[2].fieldTypeOrder);
        System.assertEquals(2, fieldGroupList[3].fieldTypeOrder);
        System.assertEquals(3, fieldGroupList[4].fieldTypeOrder);
    }
}