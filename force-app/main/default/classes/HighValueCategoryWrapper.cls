public class HighValueCategoryWrapper {
    public String fieldApiName { get; set; }
    public String fieldValue { get; set; }
    public String testName { get; set; }
    public HighValueCategoryWrapper() {}
    public HighValueCategoryWrapper(String fieldApiName, String fieldValue, String testName) {
        this.fieldApiName = fieldApiName;
        this.fieldValue = fieldValue;
        this.testName = testName;
    }
}