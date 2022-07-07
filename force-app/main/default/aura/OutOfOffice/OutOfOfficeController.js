({
    doInit: function(component, event, helper) {
        var action = component.get("c.getOutOfOfficeRTs");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.recordTypes", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    handleOnload : function(component, event, helper){
        //component.find("contactLookup").set("v.value", component.get("v.recordId"));
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
        component.set("v.isModalOpen", false);
    },
    
    handleSuccess : function(component, event, helper) {
        helper.showToast("The record has been created successfully.", "Success");
        component.set("v.isModalOpen", false);
    },
    
    handleError : function(component, event, helper) {
        var errors = event.getParams();
        console.log("response", JSON.stringify(errors));
        component.set("v.isModalOpen", true);  
    },
    
    openModel: function(component, event, helper) {
        let recTypes = component.get("v.recordTypes");
        if(recTypes.length > 0){
            var action = component.get("c.getContactId");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    let result = response.getReturnValue();
                    if(result.isSuccess){
                        component.set("v.recordId",result.contactId);
                        component.set("v.recordName",result.contactName);
                        component.set("v.isRecordTypeSelectionVisible", true);
                        component.set("v.isModalOpen", true); 
                    } else {
                        helper.showToast(result.message, result.messageType);
                    }
                }
                else {
                    console.log("Failed with state: " + state);
                }
            });
            $A.enqueueAction(action);
        } else {
            helper.showToast("You dont have access to Out of office record types, please check with System Administrator", "Error");
        }
    },   
})