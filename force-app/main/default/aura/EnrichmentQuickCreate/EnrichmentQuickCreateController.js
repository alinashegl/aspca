({
    doInit : function(component, event, helper) {
        var action = component.get("c.getTreatmentPlan");
        action.setParams({"animalId": component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.treatmentPlan", response.getReturnValue());
                let treatmentPlan = response.getReturnValue();
                component.set("v.newEnrichment.Animal__c", component.get("v.recordId"));
                if (treatmentPlan) {
                    if (treatmentPlan.Id) {
                        component.set("v.newEnrichment.Related_Treatment_Plan__c", treatmentPlan.Id);
                    }
                    if (treatmentPlan.Treatment_Bundle__c) {
                        component.set("v.newEnrichment.Related_Treatment_Bundle__c", treatmentPlan.AssignedTreatmentBundleId__c);
                    }
                    if (treatmentPlan.Enrichment_Activities__c) {
                        component.set("v.newEnrichment.Enrichment_Activities__c", treatmentPlan.Enrichment_Activities__c);
                    }
                    else {
                        component.set("v.newEnrichment.Enrichment_Activities__c", "");
                    }
                    if (treatmentPlan.Shelter_Color_Code__c) {
                        component.set("v.colorCode", treatmentPlan.Shelter_Color_Code__c);
                    }
                }
                else {
                    component.set("v.newEnrichment.Enrichment_Activities__c", "");
                }
            } else {
                console.log('Problem getting treatment plan, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
    },

    handleSaveEnrichment: function(component, event, helper) {
        if(helper.validateEnrichmentForm(component)) {
            
            var saveEnrichmentAction = component.get("c.createQuickEnrichment");
            saveEnrichmentAction.setParams({
                "enrichment": component.get("v.newEnrichment")
            });

            // Configure the response handler for the action
            saveEnrichmentAction.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {

                    // Prepare a toast UI message
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Daily Enrichment Saved",
                        "message": "The new enrichment was created."
                    });

                    // Update the UI: close panel, show toast, refresh page
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire();
                    $A.get("e.force:refreshView").fire();
                }
                else if (state === "ERROR") {
                    console.log('Problem saving enrichment, response state: ' + state);
                }
                else {
                    console.log('Unknown problem, response state: ' + state);
                }
            });

            $A.enqueueAction(saveEnrichmentAction);
        }
        
    },

    handleCancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})