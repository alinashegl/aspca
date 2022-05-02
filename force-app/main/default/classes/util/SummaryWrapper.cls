public class SummaryWrapper implements Comparable {
    public Integer labelOrder { get; set; }
    public String labelValue { get; set; }
    public String testName { get; set; }
    public Test_Config__mdt config {get; set;}
    public SummaryWrapper() {}
    public SummaryWrapper(Integer labelOrder, String labelValue) {
        this.labelOrder = labelOrder;
        this.labelValue = labelValue;
    }

    public SummaryWrapper(Integer labelOrder, String labelValue, String testName) {
        this.labelOrder = labelOrder;
        this.labelValue = labelValue;
        this.testName = testName;
    }

    public SummaryWrapper(Integer labelOrder, String testName, Test_Config__mdt config) {
        this.labelOrder = labelOrder;
        this.testName = testName;
        this.config = config;
    }

    public Integer compareTo(Object compare) {
        SummaryWrapper eval = (SummaryWrapper)compare;
        Integer returnValue = 0;
        if (this.labelOrder > eval.labelOrder) {
            returnValue = 1;
        }
        else if (this.labelOrder < eval.labelOrder) {
            returnValue = -1;
        }
        return returnValue;
    }
}