({
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