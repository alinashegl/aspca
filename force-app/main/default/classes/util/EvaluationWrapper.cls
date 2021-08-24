/*
 * Created by barne on 5/12/2021.
 */

public with sharing class EvaluationWrapper {

    // Constructor for Options
    public class ListItems {
        @AuraEnabled public String label;
        @AuraEnabled public String value;

        public ListItems(String label, String value){
            this.label = label;
            this.value = value;
        }
        public ListItems() { }
    }
    public class Options {
        @AuraEnabled public String label;
        @AuraEnabled public String longDesc;
        @AuraEnabled public String pleApiName;
        @AuraEnabled public Boolean IsSelected;


        public Options(String label, String longDesc, String pleApiName, Boolean IsSelected) {
            this.label = label;
            this.longDesc = longDesc;
            this.pleApiName = pleApiName;
            this.IsSelected = IsSelected;
        }
        public Options () { }
    }
    public class FieldContents {
        @AuraEnabled public String id;
        @AuraEnabled public Object value;

        public FieldContents (String id, Object value) {
            this.id = id;
            this.value = value;
        }
        public FieldContents() { }
    }

    /*
    * Constructor for Evaluations in Behavior Evaluation Page Controller
     */
    @AuraEnabled public String id { get; set; }
    @AuraEnabled public String label { get; set;}
    @AuraEnabled public List<Options> mZeroOptions { get; set;}
    @AuraEnabled public List<Options> mNotConcerningOptions { get; set; }
    @AuraEnabled public List<Options> mRedFlagOptions { get; set; }
    @AuraEnabled public List<Options> mAlertOptions { get; set; }
    @AuraEnabled public List<Options> mInconclusiveOptions { get; set;}
    @AuraEnabled public List<Options> tOptions { get; set; }
    @AuraEnabled public Integer index { get; set; }
    @AuraEnabled public Boolean isParent { get; set; }
    @AuraEnabled public String parentTestApiName { get; set; }
    @AuraEnabled public EvaluationWrapper wrapper1 { get; set; }
    @AuraEnabled public EvaluationWrapper wrapper2 { get; set; }
    @AuraEnabled public EvaluationWrapper wrapper3 { get; set; }
    @AuraEnabled public EvaluationWrapper wrapper4 { get; set; }

    @AuraEnabled public Boolean isSkipped { get; set; }
    @AuraEnabled public FieldContents testComments { get; set; }
    @AuraEnabled public FieldContents skipField { get; set; }


    public EvaluationWrapper(
            String id,
            String label,
            Boolean isSkipped,
            FieldContents testComments ,
            List<Options> tOptions,
            List<Options> mZeroOptions ,
            List<Options> mNotConcerningOptions ,
            List<Options> mRedFlagOptions ,
            List<Options> mAlertOptions ,
            List<Options> mInconclusiveOptions ,
            FieldContents skipField ,
            Integer index ,
            Boolean isParent ,
            String parentTestApiName ,
            EvaluationWrapper wrapper1,
            EvaluationWrapper wrapper2,
            EvaluationWrapper wrapper3,
            EvaluationWrapper wrapper4
    ) {
        this.id = id;
        this.label = label;
        this.isSkipped = isSkipped;
        this.testComments = testComments;
        this.tOptions = tOptions;
        this.mZeroOptions = mZeroOptions;
        this.mNotConcerningOptions = mNotConcerningOptions;
        this.mRedFlagOptions = mRedFlagOptions;
        this.mAlertOptions = mAlertOptions;
        this.mInconclusiveOptions = mInconclusiveOptions;
        this.skipField = skipField;
        this.index = index;
        this.isParent = isParent;
        this.parentTestApiName = parentTestApiName;
        this.wrapper1  = wrapper1;
        this.wrapper2 = wrapper2;
        this.wrapper3 = wrapper3;
        this.wrapper4 = wrapper4;
    }

    public EvaluationWrapper() {}
}