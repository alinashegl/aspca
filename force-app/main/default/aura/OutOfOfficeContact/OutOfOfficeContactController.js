({
    doInit: function(component, event, helper) {
        helper.getOOORecordTypes(component, event);
    },
    
    handleOnload : function(component, event, helper){
        //component.find("createooo").set("v.value", component.get("v.recordId"));
    },
    
    handleChange: function(component, event, helper){
        let recType = event.getParam("value");
        component.set("v.selectedRecordType", recType);
        let obj = component.get("v.recordTypes").find(o => o.value === recType);
        component.set("v.selectedRecordTypeLabel", obj.label);
        component.set("v.isRecordTypeSelectionVisible", false);
    },
    
    handleSubmit: function(component, event, helper){
        component.find("createooo").submit();
    },
    
    handleCancel: function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    
    handleSuccess : function(component, event, helper) {
        helper.showToast("The record has been created successfully.", "Success");
        $A.get("e.force:closeQuickAction").fire();
    },
    
    handleError : function(component, event, helper) {
        var errors = event.getParams();
        console.log("response", JSON.stringify(errors));
    }  
})