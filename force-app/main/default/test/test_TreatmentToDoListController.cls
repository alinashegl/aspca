@isTest
public with sharing class test_TreatmentToDoListController {
    @isTest
    static void selectOPTTest() {
        Test.startTest();
        List<TreatmentToDoListController.SelectOption> shelterLocation2 = TreatmentToDoListController.selectOPT('doesnothing');
        Test.stopTest();
        System.assert(shelterLocation2.size() > 0);
    }

    @isTest
    static void listData54Test() {
        List<Plan_Protocol__c> startPlans = TestDataFactory.createPlanProtocols(9);
        List<Protocol__c> pProtocolList = new List<Protocol__c>();
        for (Plan_Protocol__c plan : startPlans) {
            Protocol__c p = new Protocol__c(Id = plan.Protocol__c);
            pProtocolList.add(p);
        }
        List<Protocol__c> extraProtocols = TestDataFactory.createProtocols(9);
        pProtocolList.addAll(extraProtocols);
        Treatment_Bundle__c masterBundle = [SELECT Id FROM Treatment_Bundle__c WHERE IsMaster__c = true LIMIT 1];
        List<Bundle_Entry__c> masterBundleEntries = TestDataFactory.assignEntries(masterBundle, pProtocolList);
        Test.startTest();
        List<TreatmentToDoListController.TreatmentToDoListData> toDoListData = TreatmentToDoListController.listData('MRC');
        Test.stopTest();
        //Count is two because first row is the first 5 and second row is the remaining 4
        System.assertEquals(2, toDoListData[0].rowSelections.size());
        //Count is two because first row is the first extra 5 and second row is remaining extra 4
        System.assertEquals(2, toDoListData[0].notPresentSelections.size());
    }

    @isTest
    static void listData3Test() {
        List<Plan_Protocol__c> startPlans = TestDataFactory.createPlanProtocols(3);
        List<Protocol__c> pProtocolList = new List<Protocol__c>();
        for (Plan_Protocol__c plan : startPlans) {
            Protocol__c p = new Protocol__c(Id = plan.Protocol__c);
            pProtocolList.add(p);
        }
        List<Protocol__c> extraProtocols = TestDataFactory.createProtocols(3);
        pProtocolList.addAll(extraProtocols);
        Treatment_Bundle__c masterBundle = [SELECT Id FROM Treatment_Bundle__c WHERE IsMaster__c = true LIMIT 1];
        List<Bundle_Entry__c> masterBundleEntries = TestDataFactory.assignEntries(masterBundle, pProtocolList);
        Test.startTest();
        List<TreatmentToDoListController.TreatmentToDoListData> toDoListData = TreatmentToDoListController.listData('MRC');
        Test.stopTest();
        //Count is one because first row is 3 columns
        System.assertEquals(1, toDoListData[0].rowSelections.size());
        //Count is one because first row is 3 columns
        System.assertEquals(1, toDoListData[0].notPresentSelections.size());
    }

    @isTest
    static void listData2Test() {
        List<Plan_Protocol__c> startPlans = TestDataFactory.createPlanProtocols(2);
        List<Protocol__c> pProtocolList = new List<Protocol__c>();
        for (Plan_Protocol__c plan : startPlans) {
            Protocol__c p = new Protocol__c(Id = plan.Protocol__c);
            pProtocolList.add(p);
        }
        List<Protocol__c> extraProtocols = TestDataFactory.createProtocols(2);
        pProtocolList.addAll(extraProtocols);
        Treatment_Bundle__c masterBundle = [SELECT Id FROM Treatment_Bundle__c WHERE IsMaster__c = true LIMIT 1];
        List<Bundle_Entry__c> masterBundleEntries = TestDataFactory.assignEntries(masterBundle, pProtocolList);
        Test.startTest();
        List<TreatmentToDoListController.TreatmentToDoListData> toDoListData = TreatmentToDoListController.listData('MRC');
        Test.stopTest();
        //Count is one because first row is 2 columns
        System.assertEquals(1, toDoListData[0].rowSelections.size());
        //Count is one because first row is 2 columns
        System.assertEquals(1, toDoListData[0].notPresentSelections.size());
    }

    @isTest
    static void listData1Test() {
        List<Plan_Protocol__c> startPlans = TestDataFactory.createPlanProtocols(1);
        List<Protocol__c> pProtocolList = new List<Protocol__c>();
        for (Plan_Protocol__c plan : startPlans) {
            Protocol__c p = new Protocol__c(Id = plan.Protocol__c);
            pProtocolList.add(p);
        }
        List<Protocol__c> extraProtocols = TestDataFactory.createProtocols(1);
        pProtocolList.addAll(extraProtocols);
        Treatment_Bundle__c masterBundle = [SELECT Id FROM Treatment_Bundle__c WHERE IsMaster__c = true LIMIT 1];
        List<Bundle_Entry__c> masterBundleEntries = TestDataFactory.assignEntries(masterBundle, pProtocolList);
        Test.startTest();
        List<TreatmentToDoListController.TreatmentToDoListData> toDoListData = TreatmentToDoListController.listData('MRC');
        Test.stopTest();
        //Count is one because first row is 1 columns
        System.assertEquals(1, toDoListData[0].rowSelections.size());
        //Count is one because first row is 1 columns
        System.assertEquals(1, toDoListData[0].notPresentSelections.size());
    }

    @isTest
    static void saveChangesTest() {
        List<Plan_Protocol__c> startPlans = TestDataFactory.createPlanProtocols(5);
        List<Protocol__c> pList = TestDataFactory.createProtocols(3);
        List<ToDoListModWrapper> assigned = new List<ToDoListModWrapper>{
            new ToDoListModWrapper(startPlans[0].Protocol__c, false),
            new ToDoListModWrapper(startPlans[2].Protocol__c, false)
        };
        List<ToDoListModWrapper> unassigned = new List<ToDoListModWrapper>{
            new ToDoListModWrapper(pList[0].Id, true),
            new ToDoListModWrapper(pList[1].Id, true),
            new ToDoListModWrapper(pList[2].Id, true)
        };
        Test.startTest();
        Integer numChanges = TreatmentToDoListController.saveChanges(startPlans[0].Treatment_Plan__c, assigned, unassigned);
        Test.stopTest();
        List<Plan_Protocol__c> endPlans = [SELECT Id FROM Plan_Protocol__c WHERE Treatment_Plan__c = :startPlans[0].Treatment_Plan__c];
        List<Plan_Protocol__c> removedPlans = [SELECT Id FROM Plan_Protocol__c WHERE Treatment_Plan__c = :startPlans[0].Treatment_Plan__c AND IsRemoved__c = true];
        System.assertEquals(5, numChanges);
        System.assertEquals(8, endPlans.size());
        System.assertEquals(4, removedPlans.size());
    }

    @isTest
    static void objectWrapperTest() {
        Treatment_Plan__c tp = TestDataFactory.createPlan();
        Test.startTest();
        TreatmentToDoListController.BundleSelection bSelection = new TreatmentToDoListController.BundleSelection();
        bSelection.name = 'name';
        bSelection.idVal = '123';
        bSelection.inPlan = true;
        TreatmentToDoListController.RowSelection rSelection = new TreatmentToDoListController.RowSelection();
        rSelection.selectionOne = bSelection;
        rSelection.selectionTwo = bSelection;
        rSelection.selectionThree = bSelection;
        rSelection.selectionFour = bSelection;
        rSelection.selectionFive = bSelection;
        TreatmentToDoListController.SelectOption sOption = new TreatmentToDoListController.SelectOption();
        sOption.name = 'name';
        sOption.label = 'label';
        TreatmentToDoListController.TreatmentToDoListData tdData = new TreatmentToDoListController.TreatmentToDoListData();
        tdData.animal = new Animal__c(Id = tp.Animal__c);
        tdData.plan = tp;
        tdData.name = 'name';
        tdData.aspcaname = 'aName';
        tdData.priority = 'priority';
        tdData.assignment = 'assignment';
        tdData.treatmentcount = 1;
        tdData.colorCode = 'color';
        tdData.hasProtocols = true;
        tdData.selections = new List<TreatmentToDoListController.BundleSelection>{bSelection};
        tdData.rowSelections = new List<TreatmentToDoListController.RowSelection>{rSelection};
        tdData.displayProtocols = true;
        tdData.displayNotPresent = true;
        tdData.indexVar = 0;
        tdData.notPresentSelections = new List<TreatmentToDoListController.RowSelection>{rSelection};
        tdData.shelterLocation = new List<String>{'MRC'};
        ToDoListModWrapper tdMod = new ToDoListModWrapper();
        tdMod.protocolId = '123';
        tdMod.checked = true;
        TreatmentToDoListController.BundleSelection bSelectionConstr = new TreatmentToDoListController.BundleSelection(
            'name',
            '123',
            true
        );
        TreatmentToDoListController.RowSelection rSelectionConstr1 = new TreatmentToDoListController.RowSelection(
            bSelection
        );
        TreatmentToDoListController.RowSelection rSelectionConstr2 = new TreatmentToDoListController.RowSelection(
            bSelection,
            bSelection
        );
        TreatmentToDoListController.RowSelection rSelectionConstr3 = new TreatmentToDoListController.RowSelection(
            bSelection,
            bSelection,
            bSelection
        );
        TreatmentToDoListController.RowSelection rSelectionConstr4 = new TreatmentToDoListController.RowSelection(
            bSelection,
            bSelection,
            bSelection,
            bSelection
        );
        TreatmentToDoListController.RowSelection rSelectionConstr5 = new TreatmentToDoListController.RowSelection(
            bSelection,
            bSelection,
            bSelection,
            bSelection,
            bSelection
        );
        TreatmentToDoListController.SelectOption sOptionConstr = new TreatmentToDoListController.SelectOption(
            'name',
            'label'
        );
        TreatmentToDoListController.TreatmentToDoListData tdDataConstr = new TreatmentToDoListController.TreatmentToDoListData(
            'name',
            'aName',
            'priority',
            'assignment',
            1,
            'color',
            true,
            new List<TreatmentToDoListController.BundleSelection>{bSelection},
            new List<TreatmentToDoListController.RowSelection>{rSelection},
            true,
            true,
            0,
            new List<TreatmentToDoListController.RowSelection>{rSelection},
            new List<String>{'MRC'}
        );
        ToDoListModWrapper tdModConstr = new ToDoListModWrapper('123', true);
        Test.stopTest();
        //Parameterless constructors
        System.assertEquals('name', bSelection.name);
        System.assertEquals('123', bSelection.idVal);
        System.assertEquals(true, bSelection.inPlan);
        System.assertEquals(bSelection, rSelection.selectionOne);
        System.assertEquals(bSelection, rSelection.selectionTwo);
        System.assertEquals(bSelection, rSelection.selectionThree);
        System.assertEquals(bSelection, rSelection.selectionFour);
        System.assertEquals(bSelection, rSelection.selectionFive);
        System.assertEquals('name', sOption.name);
        System.assertEquals('label', sOption.label);
        System.assertEquals(tp.Animal__c, tdData.animal.Id);
        System.assertEquals(tp.Id, tdData.plan.Id);
        System.assertEquals('name', tdData.name);
        System.assertEquals('aName', tdData.aspcaname);
        System.assertEquals('priority', tdData.priority);
        System.assertEquals('assignment', tdData.assignment);
        System.assertEquals(1, tdData.treatmentcount);
        System.assertEquals('color', tdData.colorCode);
        System.assertEquals(true, tdData.hasProtocols);
        System.assertEquals(new List<TreatmentToDoListController.BundleSelection>{bSelection}, tdData.selections);
        System.assertEquals(new List<TreatmentToDoListController.RowSelection>{rSelection}, tdData.rowSelections);
        System.assertEquals(true, tdData.displayProtocols);
        System.assertEquals(true, tdData.displayNotPresent);
        System.assertEquals(0, tdData.indexVar);
        System.assertEquals(new List<TreatmentToDoListController.RowSelection>{rSelection}, tdData.notPresentSelections);
        System.assertEquals(new List<String>{'MRC'}, tdData.shelterLocation);
        System.assertEquals('123', tdMod.protocolId);
        System.assertEquals(true, tdMod.checked);
        //Constructors with params
        System.assertEquals('name', bSelectionConstr.name);
        System.assertEquals('123', bSelectionConstr.idVal);
        System.assertEquals(true, bSelectionConstr.inPlan);
        System.assertEquals(bSelection, rSelectionConstr1.selectionOne);
        System.assertEquals(bSelection, rSelectionConstr2.selectionOne);
        System.assertEquals(bSelection, rSelectionConstr2.selectionTwo);
        System.assertEquals(bSelection, rSelectionConstr3.selectionOne);
        System.assertEquals(bSelection, rSelectionConstr3.selectionTwo);
        System.assertEquals(bSelection, rSelectionConstr3.selectionThree);
        System.assertEquals(bSelection, rSelectionConstr4.selectionOne);
        System.assertEquals(bSelection, rSelectionConstr4.selectionTwo);
        System.assertEquals(bSelection, rSelectionConstr4.selectionThree);
        System.assertEquals(bSelection, rSelectionConstr4.selectionFour);
        System.assertEquals(bSelection, rSelectionConstr5.selectionOne);
        System.assertEquals(bSelection, rSelectionConstr5.selectionTwo);
        System.assertEquals(bSelection, rSelectionConstr5.selectionThree);
        System.assertEquals(bSelection, rSelectionConstr5.selectionFour);
        System.assertEquals(bSelection, rSelectionConstr5.selectionFive);
        System.assertEquals('name', sOptionConstr.name);
        System.assertEquals('label', sOptionConstr.label);
        System.assertEquals('name', tdDataConstr.name);
        System.assertEquals('aName', tdDataConstr.aspcaname);
        System.assertEquals('priority', tdDataConstr.priority);
        System.assertEquals('assignment', tdDataConstr.assignment);
        System.assertEquals(1, tdDataConstr.treatmentcount);
        System.assertEquals('color', tdDataConstr.colorCode);
        System.assertEquals(true, tdDataConstr.hasProtocols);
        System.assertEquals(new List<TreatmentToDoListController.BundleSelection>{bSelection}, tdDataConstr.selections);
        System.assertEquals(new List<TreatmentToDoListController.RowSelection>{rSelection}, tdDataConstr.rowSelections);
        System.assertEquals(true, tdDataConstr.displayProtocols);
        System.assertEquals(true, tdDataConstr.displayNotPresent);
        System.assertEquals(0, tdDataConstr.indexVar);
        System.assertEquals(new List<TreatmentToDoListController.RowSelection>{rSelection}, tdDataConstr.notPresentSelections);
        System.assertEquals(new List<String>{'MRC'}, tdDataConstr.shelterLocation);
        System.assertEquals('123', tdModConstr.protocolId);
        System.assertEquals(true, tdModConstr.checked);
    }
}