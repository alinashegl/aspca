/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentToDoListController {
    public class TreatmentToDoListData{
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public Animal__c animal { get; set; }
        @AuraEnabled public Treatment_Plan__c plan { get; set; }
        @AuraEnabled public String aspcaname { get; set; }
        @AuraEnabled public String priority { get; set; }
        @AuraEnabled public String assignment { get; set; }
        @AuraEnabled public Integer treatmentcount { get; set; }
        @AuraEnabled public String colorCode { get; set; }
        @AuraEnabled public Boolean hasProtocols { get; set; }
        @AuraEnabled public List<BundleSelection> selections { get; set; }
        @AuraEnabled public List<RowSelection> rowSelections { get; set; }
        @AuraEnabled public List<RowSelection> notPresentSelections { get; set; }
        @AuraEnabled public Boolean displayProtocols { get; set; }
        @AuraEnabled public Integer indexVar { get; set; }
        @AuraEnabled public Boolean displayNotPresent { get; set; }
        @AuraEnabled public List<String> shelterLocation { get; set; }
        @AuraEnabled public String sex { get; set; }
        @AuraEnabled public Decimal age { get; set; }
        @AuraEnabled public String grade { get; set; }
        @AuraEnabled public String location { get; set; }

        public TreatmentToDoListData(String name, String aspcaname, String priority, String assignment, Integer treatmentCount, String colorCode,
            Boolean hasProtocols, List<BundleSelection> selections, List<RowSelection> rowSelections, Boolean displayProtocols,
            Boolean displayNotPresent, Integer indexVar, List<RowSelection> notPresentSelections, List<String> shelterLocation,
            String sex, Decimal age, String grade, String location) {
            this.name = name;
            this.aspcaname = aspcaname;
            this.priority = priority;
            this.assignment = assignment;
            this.treatmentcount = treatmentCount;
            this.colorCode = colorCode;
            this.hasProtocols = hasProtocols;
            this.selections = selections;
            this.rowSelections = rowSelections;
            this.displayProtocols = displayProtocols;
            this.displayNotPresent = displayNotPresent;
            this.indexVar = indexVar;
            this.notPresentSelections = notPresentSelections;
            this.shelterLocation = shelterLocation;
            this.sex = sex;
            this.age = age;
            this.grade = grade;
            this.location = location;
        }

        public TreatmentToDoListData() { }
    }

    public class BundleSelection {
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String idVal { get; set; }
        @AuraEnabled public Boolean inPlan { get; set; }

        public BundleSelection(String name, String idval, Boolean inPlan) {
            this.name = name;
            this.idVal = idval;
            this.inPlan = inPlan;
        }

        public BundleSelection() { }
    }

    public class RowSelection {
        @AuraEnabled public BundleSelection selectionOne { get; set; }
        @AuraEnabled public BundleSelection selectionTwo { get; set; }
        @AuraEnabled public BundleSelection selectionThree { get; set; }
        @AuraEnabled public BundleSelection selectionFour { get; set; }
        @AuraEnabled public BundleSelection selectionFive { get; set; }

        public RowSelection(BundleSelection selectionOne, BundleSelection selectionTwo, BundleSelection
                selectionThree, BundleSelection selectionFour, BundleSelection selectionFive) {
            this.selectionOne = selectionOne;
            this.selectionTwo = selectionTwo;
            this.selectionThree = selectionThree;
            this.selectionFour = selectionFour;
            this.selectionFive = selectionFive;
        }

        public RowSelection(BundleSelection selectionOne, BundleSelection selectionTwo, BundleSelection
                selectionThree, BundleSelection selectionFour) {
            this.selectionOne = selectionOne;
            this.selectionTwo = selectionTwo;
            this.selectionThree = selectionThree;
            this.selectionFour = selectionFour;
        }

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

    public class SelectOption {
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String label { get; set; }

        public SelectOption(String name, String label) {
            this.name = name;
            this.label = label;
        }

        public SelectOption() { }
    }

    @AuraEnabled
    public static List<SelectOption> selectOPT(String key) {
        List<SelectOption> options = new List<SelectOption>();
        for(PicklistEntry entry : Animal__c.Shelter_Location2__c.getDescribe().getPicklistValues()) {
            SelectOption opt = new SelectOption();
            opt.name = entry.label;
            opt.label = entry.label;

            options.add(opt);
        }
        return options;
    }
    @AuraEnabled
    public static List<TreatmentToDoListData> listData(String key) {
        List<Treatment_Plan__c> treatmentPlans = [SELECT Id, Name, Treatment_Priority__c, Animal__c, IsActive__c,
                Animal__r.Animal_Name__c, Animal__r.Name, Animal__r.Location__c, Animal__r.Shelter_Location2__c, Animal__r.Number_of_Treatments__c,
                Animal__r.Gender__c, Animal__r.Current_Animal_Age_Estimate__c, Animal__r.Current_Behavior_Grade__c, Animal__r.Shelter_Location__c,
                AssignedTreatmentBundleId__c, Shelter_Color_Code__c FROM Treatment_Plan__c WHERE Animal__r.Shelter_Location2__c =: key
                AND IsActive__c = TRUE];

        List<TreatmentToDoListData> data = new List<TreatmentToDoListData>();
        Map<Id, List<Plan_Protocol__c>> planToPlanProtocolsMap = new Map<Id, List<Plan_Protocol__c>>();
        Treatment_Bundle__c master = [SELECT Id, IsMaster__c from Treatment_Bundle__c WHERE IsActive__c = true AND IsMaster__c = true LIMIT 1];
        List<Bundle_Entry__c> entries = [SELECT Id, Protocol__c, Protocol__r.Name, Treatment_Bundle__c FROM Bundle_Entry__c WHERE
                Treatment_Bundle__c =: master.Id ORDER BY Protocol__r.Name DESC];
        System.debug(entries.size());

        Set<Id> masterSet = new Set<Id>();
        for(Bundle_Entry__c entry : entries) {
            masterSet.add(entry.Protocol__c);
        }
        Map<Id, Protocol__c> masterProtocols = new Map<Id, Protocol__c>([SELECT Id, Name FROM Protocol__c WHERE Id IN :masterSet]);
        Map<Id, Plan_Protocol__c> protocols = new Map<Id, Plan_Protocol__c>([SELECT Id, Treatment_Plan__c, Protocol__c, IsRemoved__c FROM Plan_Protocol__c]);

        for(Treatment_Plan__c plan : treatmentPlans) {
            List<Plan_Protocol__c> planProtocols = new List<Plan_Protocol__c>();
            for(Plan_Protocol__c protocol : protocols.values()) {
                if(protocol.Treatment_Plan__c == plan.Id) {
                    planProtocols.add(protocol);
                }
            }
            planToPlanProtocolsMap.put(plan.Id, planProtocols);
        }

        for(Treatment_Plan__c plan : treatmentPlans) {
            List<RowSelection> notPresentRow = new List<TreatmentToDoListController.RowSelection>();
            Animal__c animal = plan.Animal__r;
            TreatmentToDoListData item = new TreatmentToDoListData();
            item.name = animal.Name == null ? 'None Found' : animal.Name;
            item.aspcaname = animal.Animal_Name__c == null ? 'None Found' : animal.Animal_Name__c;
            item.priority = plan.Treatment_Priority__c == null ? 'None Found' : plan.Treatment_Priority__c;
            List<RowSelection> rowSelections = new List<TreatmentToDoListController.RowSelection>();

            Treatment_Bundle__c bundle = new Treatment_Bundle__c();
            if(plan.AssignedTreatmentBundleId__c != null) {
                bundle = [SELECT Name, Id FROM Treatment_Bundle__c WHERE Id =: plan.AssignedTreatmentBundleId__c];
            }

            item.sex = animal.Gender__c;
            item.age = animal.Current_Animal_Age_Estimate__c;
            item.grade = animal.Current_Behavior_Grade__c;
            item.location = animal.Shelter_Location__c;
            item.assignment = bundle == null ? 'None Found' : bundle.Name;
            item.colorCode = plan.Shelter_Color_Code__c == null ? 'None Found' : plan.Shelter_Color_Code__c;
            item.treatmentcount = animal.Number_of_Treatments__c == null ? 0 : Integer.valueOf(animal.Number_of_Treatments__c);
            item.animal = animal;
            item.plan = plan;
            item.displayProtocols = false;


            List<BundleSelection> selections = new List<TreatmentToDoListController.BundleSelection>();
            List<BundleSelection> notPresentSelections = new List<TreatmentToDoListController.BundleSelection>();
            List<Plan_Protocol__c> lPlanProtocols = planToPlanProtocolsMap.get(plan.Id);
            Set<Id> idset = new Set<Id>();
            Set<Id> removedIdSet = new Set<Id>();
            if(lPlanProtocols != null) {
                for(Plan_Protocol__c protocol : lPlanProtocols) {
                    if (protocol.IsRemoved__c) {
                        removedIdSet.add(protocol.Protocol__c);
                    }
                    else {
                        idset.add(protocol.Protocol__c);
                    }
                }
            }

            for(Bundle_Entry__c entry : entries) {
                BundleSelection iSelection = new BundleSelection();
                iSelection.idVal = entry.Protocol__c;
                if(idset.contains(entry.Protocol__c)) {
                    iSelection.inPlan = true;
                    iSelection.name = entry.Protocol__r.Name;
                    selections.add(iSelection);
                }
                else if(removedIdSet.contains(entry.Protocol__c)) {
                    iSelection.inPlan = false;
                    iSelection.name = entry.Protocol__r.Name;
                    selections.add(iSelection);
                }
                else if (masterProtocols.keySet().contains(entry.Protocol__c)) {
                    iSelection.inPlan = false;
                    iSelection.name = entry.Protocol__r.Name;
                    notPresentSelections.add(iSelection);
                }
            }
            //System.debug(selections.size());
            Integer variable = selections.size();
            while(variable >= 5) {

                RowSelection selection = new RowSelection();
                selection.selectionOne =  selections[variable - 1];
                selection.selectionTwo =  selections[variable - 2];
                selection.selectionThree =  selections[variable - 3];
                selection.selectionFour = selections[variable - 4];
                selection.selectionFive = selections[variable - 5];
                variable = variable - 5;
                rowSelections.add(selection);
            }


            if (variable == 4) {
                RowSelection selection = new RowSelection();
                selection.selectionOne = selections[3];
                selection.selectionTwo = selections[2];
                selection.selectionThree = selections[1];
                selection.selectionFour = selections[0];
                BundleSelection opt = new BundleSelection();
                opt.name = 'EMPTY';
                selection.selectionFive = opt;
                rowSelections.add(selection);
            }
            if (variable == 3) {
                RowSelection selection = new RowSelection();
                selection.selectionOne = selections[2];
                selection.selectionTwo = selections[1];
                selection.selectionThree = selections[0];
                BundleSelection opt = new BundleSelection();
                opt.name = 'EMPTY';
                selection.selectionFour = opt;
                selection.selectionFive = opt;
                rowSelections.add(selection);
            }
            if (variable == 2) {
                RowSelection selection = new RowSelection();
                selection.selectionOne = selections[1];
                selection.selectionTwo = selections[0];
                BundleSelection opt = new BundleSelection();
                opt.name = 'EMPTY';
                selection.selectionThree = opt;
                selection.selectionFour = opt;
                selection.selectionFive = opt;
                rowSelections.add(selection);
            }
            if (variable == 1) {
                RowSelection selection = new RowSelection();
                selection.selectionOne = selections[0];
                BundleSelection opt = new BundleSelection();
                opt.name = 'EMPTY';
                selection.selectionFour = opt;
                selection.selectionFive = opt;
                selection.selectionThree = opt;
                selection.selectionTwo = opt;
                rowSelections.add(selection);
            }

            Integer variable2 = notPresentSelections.size();
            if(variable2 > 5) {
                while(variable2 >= 5) {

                    RowSelection selection = new RowSelection();
                    selection.selectionOne =  notPresentSelections[variable2 - 1];
                    selection.selectionTwo =  notPresentSelections[variable2 - 2];
                    selection.selectionThree =  notPresentSelections[variable2 - 3];
                    selection.selectionFour = notPresentSelections[variable2 - 4];
                    selection.selectionFive = notPresentSelections[variable2 - 5];
                    variable2 = variable2 - 5;
                    notPresentRow.add(selection);
                }
            }
            if (variable2 == 4) {
                RowSelection selection = new RowSelection();
                selection.selectionOne = notPresentSelections[3];
                selection.selectionTwo = notPresentSelections[2];
                selection.selectionThree = notPresentSelections[1];
                selection.selectionFour = notPresentSelections[0];
                BundleSelection opt = new BundleSelection();
                opt.name = 'EMPTY';
                selection.selectionFive = opt;
                notPresentRow.add(selection);
            }

            if (variable2 == 3) {
                RowSelection selection = new RowSelection();
                selection.selectionOne = notPresentSelections[2];
                selection.selectionTwo = notPresentSelections[1];
                selection.selectionThree = notPresentSelections[0];
                BundleSelection opt = new BundleSelection();
                opt.name = 'EMPTY';
                selection.selectionFive = opt;
                selection.selectionFour = opt;
                notPresentRow.add(selection);
            }
            if (variable2 == 2) {
                RowSelection selection = new RowSelection();
                selection.selectionOne = notPresentSelections[1];
                selection.selectionTwo = notPresentSelections[0];
                BundleSelection opt = new BundleSelection();
                opt.name = 'EMPTY';
                selection.selectionFive = opt;
                selection.selectionFour = opt;
                selection.selectionThree = opt;
                notPresentRow.add(selection);
            }
            if (variable2 == 1) {
                RowSelection selection = new RowSelection();
                selection.selectionOne = notPresentSelections[0];
                BundleSelection opt = new BundleSelection();
                opt.name = 'EMPTY';
                selection.selectionFive = opt;
                selection.selectionFour = opt;
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

    @AuraEnabled
    public static Integer saveChanges(String planId, List<ToDoListModWrapper> assigned, List<ToDoListModWrapper> unassigned) {
        List<Plan_Protocol__c> protocolMod = new List<Plan_Protocol__c>();
        List<Plan_Protocol__c> existing = [SELECT Id, Treatment_Plan__c, Protocol__c, IsRemoved__c FROM Plan_Protocol__c WHERE Treatment_Plan__c = :planId];
        for (ToDoListModWrapper assignedProtocol : assigned) {
            for (Plan_Protocol__c existingProtocol : existing) {
                if (existingProtocol.Protocol__c == assignedProtocol.protocolId) {
                    existingProtocol.IsRemoved__c = !assignedProtocol.checked;
                    protocolMod.add(existingProtocol);
                }
            }
        }
        for (ToDoListModWrapper unassignedProtocol : unassigned) {
            Plan_Protocol__c newProtocol = new Plan_Protocol__c(Treatment_Plan__c = planId, Protocol__c = unassignedProtocol.protocolId);
            protocolMod.add(newProtocol);
        }
        upsert protocolMod;
        return protocolMod.size();
    }
}