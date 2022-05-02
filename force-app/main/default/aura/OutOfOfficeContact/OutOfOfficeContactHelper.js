({
    getOOORecordTypes: function(component, event, helper) {
        var action = component.get("c.getOutOfOfficeRTs");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue()
                component.set("v.recordTypes", result);
                if(result.length > 0){
                    //this.getContact(component, event);
                } else {
                    this.showToast("You dont have access to Out of office record types, please check with System Administrator", "Error");
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    getContact : function(component, event){
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
                    this.showToast(result.message, result.messageType);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    showToast : function(message, messageType) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": messageType,
            "title": messageType,
            "message": message
        });
        toastEvent.fire();
    }
})