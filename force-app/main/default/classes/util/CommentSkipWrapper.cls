public class CommentSkipWrapper {
    public String testName { get; set; }
    public String commentField { get; set; }
    public String skipField { get; set; }
    public CommentSkipWrapper() {}
    public CommentSkipWrapper(String testName, String commentField, String skipField) {
        this.testName = testName;
        this.commentField = commentField;
        this.skipField = skipField;
    }
}