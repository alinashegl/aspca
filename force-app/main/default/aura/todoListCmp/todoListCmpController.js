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
    },

    handleLocationFilterMessage : function(cmp, message){
        window.console.log('message recieved: ', JSON.stringify(message));
        cmp.set("v.locations",message.getParam('locations'));
    }
})