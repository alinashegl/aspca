public class CommentSkipWrapper {
    public String testName { get; set; }
    public String commentField { get; set; }
    public String skipField { get; set; }
    public String highValueField { get; set; }
    public String summaryField { get; set; }
    
    public CommentSkipWrapper() {}
    public CommentSkipWrapper(String testName, String commentField, String skipField) {
        this.testName = testName;
        this.commentField = commentField;
        this.skipField = skipField;

    }

    public CommentSkipWrapper(String testName, String commentField, String skipField, String highValueField) {
        this.testName = testName;
        this.commentField = commentField;
        this.skipField = skipField;
        this.highValueField = highValueField;
    }

    public CommentSkipWrapper(String testName, String commentField, String skipField, String highValueField, String summaryField) {
        this.testName = testName;
        this.commentField = commentField;
        this.skipField = skipField;
        this.highValueField = highValueField;
        this.summaryField = summaryField;
    }
}