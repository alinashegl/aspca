({
    doInit : function(component, event, helper) {
        var action = component.get("c.getPicklistValues");
        action.setParams({"objectName": component.get("v.objectName"), "fieldName": component.get("v.fieldName")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.options", response.getReturnValue());
            } else {
                console.log('Problem getting field options, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
    },
    handleChange : function(component, event, helper) {
        helper.setPicklistValues(component, event.getParam("value"));
    },
    doValidityCheck : function(component, event){
        var inputCmp = component.find("inputCmp");
        inputCmp.reportValidity();
    }
})