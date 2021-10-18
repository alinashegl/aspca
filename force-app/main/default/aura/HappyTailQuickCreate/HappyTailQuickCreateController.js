({
    doInit : function(component, event, helper) {
        var action = component.get("c.getEnrichmentNotes");
        action.setParams({"enrichmentId": component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.enrichment", response.getReturnValue());
                let enrichmentNotes = response.getReturnValue();
                component.set("v.newObservation.Observation_Type__c", "Happy Tail");
                component.set("v.newObservation.Daily_Enrichment__c", component.get("v.recordId"));
                if (enrichmentNotes.Animal__c) {
                    component.set("v.newObservation.Animal__c", enrichmentNotes.Animal__c);
                }
                if (enrichmentNotes.Notes__c) {
                    component.set("v.newObservation.Observation_Notes__c", enrichmentNotes.Notes__c);
                }
            } else {
                console.log('Problem getting enrichment, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
    },

    handleSaveObservation: function(component, event, helper) {
        if(helper.validateObservationForm(component)) {
            
            var saveObservationAction = component.get("c.createQuickObservation");
            saveObservationAction.setParams({
                "observation": component.get("v.newObservation")
            });

            // Configure the response handler for the action
            saveObservationAction.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {

                    // Prepare a toast UI message
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Happy Tail Saved",
                        "message": "The new observation was created."
                    });

                    // Update the UI: close panel, show toast, refresh page
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire();
                    $A.get("e.force:refreshView").fire();
                }
                else if (state === "ERROR") {
                    console.log('Problem saving observation, response state: ' + state);
                }
                else {
                    console.log('Unknown problem, response state: ' + state);
                }
            });

            $A.enqueueAction(saveObservationAction);
        }
        
    },

    handleCancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})