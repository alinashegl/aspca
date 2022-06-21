({
    doInit : function(component, event, helper) {
        var action = component.get("c.getToDoListVisibility");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                let result = response.getReturnValue();
                if(result){
                    component.set("v.isVisible", result.mrcTodoList);
                }
            }
    	});
        $A.enqueueAction(action);
    }
})