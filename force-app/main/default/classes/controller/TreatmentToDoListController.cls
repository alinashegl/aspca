/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentToDoListController {
    public class TreatmentToDoListData{
        @AuraEnabled public String name;
        @AuraEnabled public Animal__c animal;
        @AuraEnabled public Treatment_Plan__c plan;
        @AuraEnabled public String priority;
        @AuraEnabled public String assignment;
        @AuraEnabled public Integer treatmentcount;
        @AuraEnabled public String colorCode;
        @AuraEnabled public Boolean hasProtocols;
        @AuraEnabled public List<BundleSelection> selections;
        @AuraEnabled public List<RowSelection> rowSelections;
        @AuraEnabled public List<RowSelection> notPresentSelections;
        @AuraEnabled public Boolean displayProtocols;
        @AuraEnabled public Integer indexVar;
        @AuraEnabled public Boolean displayNotPresent;

        public TreatmentToDoListData(String name, String priority, String assignment, Integer treatmentCount, String
                colorCode, Boolean hasProtocols, List<BundleSelection> selections, List<RowSelection> rowSelections,
                Boolean displayProtocols, Boolean displayNotPresent, Integer indexVar, List<RowSelection>
                        notPresentSelections) {
            this.name = name;
            this.priority = priority;
            this.assignment = assignment;
            this.treatmentcount = treatmentCount;
            this.colorCode = colorCode;
            this.hasProtocols = hasProtocols;
            this.selections = selections;
            this.rowSelections = rowSelections;
            this.displayProtocols = displayProtocols;
            this.indexVar = indexVar;
            this.notPresentSelections = notPresentSelections;
            this.displayNotPresent = displayNotPresent;
        }

        public TreatmentToDoListData() { }
    }

    public class  BundleSelection {
        @AuraEnabled public String name;
        @AuraEnabled public String idVal;
        @AuraEnabled public Boolean inPlan;

        public BundleSelection(String name, String idval, Boolean inPlan) {
            this.name = name;
            this.idVal = idval;
            this.inPlan = inPlan;
        }

        public BundleSelection() { }
    }

    public class RowSelection {
        @AuraEnabled public BundleSelection selectionOne;
        @AuraEnabled public BundleSelection selectionTwo;
        @AuraEnabled public BundleSelection selectionThree;

        public RowSelection(BundleSelection selectionOne, BundleSelection selectionTwo, BundleSelection
                selectionThree) {
            this.selectionOne = selectionOne;
            this.selectionTwo = selectionTwo;
            this.selectionThree = selectionThree;
        }
        public RowSelection(BundleSelection selectionOne, BundleSelection selectionTwo) {
            this.selectionOne = selectionOne;
            this.selectionTwo = selectionTwo;

        }
        public RowSelection(BundleSelection selectionOne) {
            this.selectionOne = selectionOne;
        }

        public RowSelection() { }
    }

    @AuraEnabled
    public static List<TreatmentToDoListData> listData(String key) {
        List<Animal__c> animals = [SELECT Id, Name, Location__c, Shelter_Location2__c FROM Animal__c WHERE
                Shelter_Location2__c =: key];
        List<Treatment_Plan__c> treatmentPlans = [SELECT Id, Name, Treatment_Priority__c, Animal__c, IsActive__c,
                AssignedTreatmentBundleId__c, Shelter_Color_Code__c FROM Treatment_Plan__c WHERE Animal__c =: animals
                AND IsActive__c = TRUE];
        Map<Id, Animal__c> animalsByIds = new Map<Id, Animal__c>(animals);
        Map<Id, Treatment_Plan__c> treatmentPlansByIds = new Map<Id, Treatment_Plan__c>(treatmentPlans);

        Map<Id, Treatment_Session__c> sessionsByIds = new Map<Id, Treatment_Session__c>([SELECT Id,
                Treatment_Plan__c, CreatedDate
                FROM Treatment_Session__c WHERE Treatment_Plan__c =: treatmentPlans]);
        Map<Id, List<Treatment_Session__c>> idToTreatmentSessionMap = new Map<Id, List<Treatment_Session__c>>();
        for(Treatment_Plan__c plan : treatmentPlans) {
            List<Treatment_Session__c> sessions = new List<Treatment_Session__c>();
            for(Treatment_Session__c session : sessionsByIds.values()) {
                if (plan.Id == session.Treatment_Plan__c) {
                    sessions.add(session);
                }
            }
            idToTreatmentSessionMap.put(plan.id, sessions);
        }

        List<TreatmentToDoListData> data = new List<TreatmentToDoListData>();
        Map<Id, List<Plan_Protocol__c>> planToPlanProtocolsMap = new Map<Id, List<Plan_Protocol__c>>();
        Treatment_Bundle__c master = [SELECT Id, IsMaster__c from Treatment_Bundle__c LIMIT 1];
        List<Bundle_Entry__c> entries = [SELECT Id, Protocol__c, Treatment_Bundle__c FROM Bundle_Entry__c WHERE
                Treatment_Bundle__c =: master.Id];

        ProtocolSelector protocolSelector = new ProtocolSelector();
        Set<Id> masterSet = new Set<Id>();
        for(Bundle_Entry__c entry : entries) {
            masterSet.add(entry.Protocol__c);
        }
        Map<Id, Protocol__c> masterProtocols = new Map<Id, Protocol__c>(protocolSelector.GetById(masterSet));
        Map<Id, Plan_Protocol__c> protocols = new Map<Id, Plan_Protocol__c>([SELECT Id, Treatment_Plan__c, Protocol__c FROM Plan_Protocol__c]);

        for(Treatment_Plan__c plan : treatmentPlans) {
            List<Plan_Protocol__c> planProtocols = new List<Plan_Protocol__c>();
            for(Plan_Protocol__c protocol : protocols.values()) {
                if(protocol.Treatment_Plan__c == plan.Id) {
                    planProtocols.add(protocol);
                }
            }
            if(planProtocols != null) {
                planToPlanProtocolsMap.put(plan.Id, planProtocols);
            }else {
                System.debug('NO PROTOCOLS FOUND FOR => ' + plan.Name);
                planToPlanProtocolsMap.put(plan.Id, planProtocols);
            }
        }

        for(Treatment_Plan__c plan : treatmentPlans) {
            List<RowSelection> notPresentRow = new List<TreatmentToDoListController.RowSelection>();
            Animal__c animal = animalsByIds.get(plan.Animal__c);
            TreatmentToDoListData item = new TreatmentToDoListData();
            item.name = animal.Name == null ? 'None Found' : animal.Name;
            item.priority = plan.Treatment_Priority__c == null ? 'None Found' : plan.Treatment_Priority__c;
            List<RowSelection> rowSelections = new List<TreatmentToDoListController.RowSelection>();

            Treatment_Bundle__c bundle = new Treatment_Bundle__c();
            if(plan.AssignedTreatmentBundleId__c != null) { bundle = [SELECT Name, Id FROM Treatment_Bundle__c WHERE Id =: plan
                    .AssignedTreatmentBundleId__c]; }
            item.assignment = bundle == null ? 'None Found' : bundle.Name;
            item.colorCode = plan.Shelter_Color_Code__c == null ? 'None Found' : plan.Shelter_Color_Code__c;
            List<Treatment_Session__c> sessions = idToTreatmentSessionMap.get(plan.Id);
            item.treatmentcount = 5;
            item.animal = animal;
            item.plan = plan;
            item.displayProtocols = false;

            List<BundleSelection> selections = new List<TreatmentToDoListController.BundleSelection>();
            List<BundleSelection> notPresentSelections = new List<TreatmentToDoListController.BundleSelection>();
            List<Plan_Protocol__c> lPlanProtocols = planToPlanProtocolsMap.get(plan.Id);
            Set<Id> idset = new Set<Id>();
            if(lPlanProtocols != null) {
                for(Plan_Protocol__c protocol : lPlanProtocols) {
                    idset.add(protocol.Protocol__c);
                }
            }


            Map<Id, Protocol__c> sProtocols = new Map<Id, Protocol__c>(protocolSelector.GetById(idset));
            Integer countOfEntries = entries.size();
            //Integer index = countOfEntries - 1;
            for(Bundle_Entry__c entry : entries) {
                BundleSelection iSelection = new BundleSelection();
                iSelection.idVal = entry.Protocol__c;
                if(sProtocols.keySet().contains(entry.Protocol__c)) {
                    Protocol__c protocol = sProtocols.get(entry.Protocol__c);
                    iSelection.inPlan = true;
                    iSelection.name = protocol.Name;
                    selections.add(iSelection);
                }else {
                    Protocol__c protocol = masterProtocols.get(entry.Protocol__c);
                    iSelection.inPlan = false;
                    iSelection.name = protocol.Name;
                    notPresentSelections.add(iSelection);
                }

            }
            //System.debug(selections.size());
            Integer variable = selections.size();
            while(variable >= 3) {

                RowSelection selection = new RowSelection();
                selection.selectionOne =  selections[variable - 1];
                selection.selectionTwo =  selections[variable - 2];
                selection.selectionThree =  selections[variable - 3];
                variable = variable - 4;
                rowSelections.add(selection);
            }

            if (variable == 3) {
                RowSelection selection = new RowSelection();
                selection.selectionOne = selections[0];
                selection.selectionTwo = selections[1];
                selection.selectionThree = selections[3];
                rowSelections.add(selection);
            }
            if (variable == 2) {
                RowSelection selection = new RowSelection();
                selection.selectionOne = selections[0];
                selection.selectionTwo = selections[1];
                BundleSelection opt = new BundleSelection();
                opt.name = 'EMPTY';
                selection.selectionThree = opt;
                rowSelections.add(selection);
            }
            if (variable == 1) {
                RowSelection selection = new RowSelection();
                selection.selectionOne = selections[0];
                BundleSelection opt = new BundleSelection();
                opt.name = 'EMPTY';
                selection.selectionThree = opt;
                selection.selectionTwo = opt;
                rowSelections.add(selection);
            }

            Integer variable2 = notPresentSelections.size();
            if(variable2 > 3) {
                while(variable2 >= 3) {

                    RowSelection selection = new RowSelection();
                    selection.selectionOne =  notPresentSelections[variable2 - 1];
                    selection.selectionTwo =  notPresentSelections[variable2 - 2];
                    selection.selectionThree =  notPresentSelections[variable2 - 3];
                    variable2 = variable2 - 4;
                    notPresentRow.add(selection);
                }
            }

            if (variable2 == 3) {
                RowSelection selection = new RowSelection();
                selection.selectionOne = notPresentSelections[0];
                selection.selectionTwo = notPresentSelections[1];
                selection.selectionThree = notPresentSelections[3];
                notPresentRow.add(selection);
            }
            if (variable2 == 2) {
                RowSelection selection = new RowSelection();
                selection.selectionOne = notPresentSelections[0];
                selection.selectionTwo = notPresentSelections[1];
                BundleSelection opt = new BundleSelection();
                opt.name = 'EMPTY';
                selection.selectionThree = opt;
                notPresentRow.add(selection);
            }
            if (variable2 == 1) {
                RowSelection selection = new RowSelection();
                selection.selectionOne = notPresentSelections[0];
                BundleSelection opt = new BundleSelection();
                opt.name = 'EMPTY';
                selection.selectionThree = opt;
                selection.selectionTwo = opt;
                notPresentRow.add(selection);
            }
            item.notPresentSelections = notPresentRow;
            item.selections = selections;
            System.debug('Row Selections ===> ' + rowSelections);
            item.rowSelections = rowSelections;
            data.add(item);
        }
        for(TreatmentToDoListData item : data) {
            Integer i = data.indexOf(item);
            item.indexVar = i;
        }

        System.debug(data);
        return data;
    }
}