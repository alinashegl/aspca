/**
 * Created by barne on 6/7/2021.
 */

public with sharing class BehaviorEvalPDFController {
    public Behavior_Evaluation__c behaviorEvaluation;
    public Animal__c animal;
    public BehaviorEvalPDFController()
    {
        dao_Animal daoAnimal = new dao_Animal();
        dao_BehaviorEvaluations daoBehaviorEvaluations = new dao_BehaviorEvaluations();
        //PageReference page = new PageReference('/apex/KennelSignage');
        PageReference page = ApexPages.currentPage();
        System.debug('######Current Page   =' + page);

        behaviorEvaluation = daoBehaviorEvaluations.findOne(page.getParameters().get('id'));
        System.debug('### Value of current animal  ' + behaviorEvaluation);

        animal = daoAnimal.findOne(String.valueOf(behaviorEvaluation.Animal__c));
        getBik_NotConcOptions();
    }

    /*******************************************************************************************************************/
    /************************* Behavior In Kennel Properties    *******************************************************/
    /*******************************************************************************************************************/

    //REFACTOR - MAKE PRIVATE METHOD
    public class PDFSelection {
        public String label { get; set; }
        public String longDesc { get; set; }
        public Boolean isSelected { get; set; }

        public PDFSelection(String label, String longDesc, Boolean isSelected) {
            this.label = label;
            this.longDesc = longDesc;
            this.isSelected = isSelected;
        }
        public PDFSelection () { }
    }
    public List<PDFSelection> bik_NotConcOptions { get; set; }
    public List<PDFSelection> bik_RedFlagOptions { get; set; }
    public  List<PDFSelection> bik_AlertOptions { get; set; }
    public  List<PDFSelection> getBik_NotConcOptions() {
        DescribeFieldResult fieldResult = Behavior_Evaluation__c.Behavior_in_Kennel__c.getDescribe();
        ControllerHelper.Properties prop = ControllerHelper.getFieldProperties(Behavior_Evaluation__c.Behavior_in_Kennel__c);
        List<Picklist_Description_Config__mdt>sConfigs = MetadataUtil.getFieldValues(prop.id);
        List<String> entries = String.isEmpty(behaviorEvaluation.Behavior_in_Kennel__c) ? null : behaviorEvaluation.Behavior_in_Kennel__c.split(';');
        List<PDFSelection> selections = new List<PDFSelection>();
        for (Picklist_Description_Config__mdt config : sConfigs) {
            PDFSelection options = new PDFSelection();
            options.label = config.Field_Value__c;
            options.longDesc = config.Field_Description__c;
            System.debug('$$$$ NOT BIK OPTIIONS ===> ' + config);
            if (config.Value_Category__c.equals('1')) {
                bik_NotConcOptions.add(options);
            }
            if (!entries.isEmpty()) {
                if (entries.contains(config.Field_Value__c)) {
                    options.isSelected = true;
                } else {
                    options.isSelected = false;
                }
            }
            selections.add(options);


    }
        return selections;
    }
    public  List<PDFSelection> getBik_RedFlagOptions() {
        DescribeFieldResult fieldResult = Behavior_Evaluation__c.Behavior_in_Kennel__c.getDescribe();
        ControllerHelper.Properties prop = ControllerHelper.getFieldProperties(Behavior_Evaluation__c.Behavior_in_Kennel__c);
        List<Picklist_Description_Config__mdt>sConfigs = MetadataUtil.getFieldValues(prop.id);
        List<String> entries = String.isEmpty(behaviorEvaluation.Behavior_in_Kennel__c) ? null : behaviorEvaluation.Behavior_in_Kennel__c.split(';');
        List<PDFSelection> selections = new List<PDFSelection>();
        for (Picklist_Description_Config__mdt config : sConfigs) {
            PDFSelection options = new PDFSelection();
            options.label = config.Field_Value__c;
            options.longDesc = config.Field_Description__c;
            System.debug('$$$$ NOT BIK OPTIIONS ===> ' + config);
            if (config.Value_Category__c.equals('2')) {
                bik_NotConcOptions.add(options);
            }
            if (!entries.isEmpty()) {
                if (entries.contains(config.Field_Value__c)) {
                    options.isSelected = true;
                } else {
                    options.isSelected = false;
                }
            }
            selections.add(options);


        }
        return selections;
    }
    public  List<PDFSelection> getBik_AlertOptions() {
        DescribeFieldResult fieldResult = Behavior_Evaluation__c.Behavior_in_Kennel__c.getDescribe();
        ControllerHelper.Properties prop = ControllerHelper.getFieldProperties(Behavior_Evaluation__c.Behavior_in_Kennel__c);
        List<Picklist_Description_Config__mdt>sConfigs = MetadataUtil.getFieldValues(prop.id);
        List<String> entries = String.isEmpty(behaviorEvaluation.Behavior_in_Kennel__c) ? null : behaviorEvaluation.Behavior_in_Kennel__c.split(';');
        List<PDFSelection> selections = new List<PDFSelection>();
        for (Picklist_Description_Config__mdt config : sConfigs) {
            PDFSelection options = new PDFSelection();
            options.label = config.Field_Value__c;
            options.longDesc = config.Field_Description__c;
            System.debug('$$$$ NOT BIK OPTIIONS ===> ' + config);
            if (config.Value_Category__c.equals('3')) {
                bik_NotConcOptions.add(options);
            }
            if (!entries.isEmpty()) {
                if (entries.contains(config.Field_Value__c)) {
                    options.isSelected = true;
                } else {
                    options.isSelected = false;
                }
            }
            selections.add(options);


        }
        return selections;
    }
    public PageReference showBikNc() {
        for (PDFSelection selection : bik_NotConcOptions) {
            System.debug(selection.label + '=====>' + selection.longDesc );
        }
        return null;
    }
    public PageReference showBikRf() {
        for (PDFSelection selection : bik_RedFlagOptions) {
            System.debug(selection.label + '=====>' + selection.longDesc );
        }
        return null;
    }
    public PageReference showBikAo() {
        for (PDFSelection selection : bik_AlertOptions) {
            System.debug(selection.label + '=====>' + selection.longDesc );
        }
        return null;
    }



}