public class ToDoListModWrapper {
    @AuraEnabled
    public String protocolId { get; set; }
    @AuraEnabled
    public Boolean checked { get; set; }
    public ToDoListModWrapper() {}
    public ToDoListModWrapper(String protocolId, Boolean checked) {
        this.protocolId = protocolId;
        this.checked = checked;
    }
}