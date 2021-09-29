/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */
({
    assignedModified: [],
    unassignedModified: [],
    buttonAction : function(cmp, event, button) {
        if(button == 'showProtocols') {
            this.showProtocols(cmp, event, button);
        }
        else if(button == 'showNotPresent') {
            this.showNotPresent(cmp, event, button);
        }
        else if(button == 'updatePlanProtocols') {
            this.updatePlanProtocols(cmp, event, button);
        }
    } ,
    updatePlanProtocols : function (cmp, event, button) {
        if (this.assignedModified.length === 0 && this.unassignedModified.length === 0) {
            let toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "No changes",
                "message": "Please check or uncheck items in the Assigned Protocols\nor Unassigned Protocols before attempting to save changes.",
                "type": "info"
            });
            toastEvent.fire();
        }
        else {
            let planId = cmp.get('v.PlanId');

            var params = {
                planId: planId ,
                assigned: this.assignedModified,
                unassigned: this.unassignedModified
            };
            let action = cmp.get('c.saveChanges');
            action.setParams(params);
            action.setCallback(cmp,
                function(response) {
                    let state = response.getState();
                    if (state === 'SUCCESS'){
                        let toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "Changes saved.",
                            "type": "success"
                        });
                        toastEvent.fire();
                        //Save event for handling data reset before refresh
                        let protocolSaveEvent = cmp.getEvent("protocolSaveEvent");
                        protocolSaveEvent.fire();
                    } else {
                        let errors = response.getError();
                        let toastEvent = $A.get("e.force:showToast");
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                toastEvent.setParams({
                                    "title": "Error!",
                                    "message": errors[0].message,
                                    "type": "error"
                                });
                            }
                        } else {
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "Unknown error",
                                "type": "error"
                            });
                        }
                        toastEvent.fire();
                    }
                }
            );
            $A.enqueueAction(action);
        }
    },
    showProtocols : function (cmp, event, button) {
        var cor = cmp.get('v.RenderProtocols');
        if(cor == true) {
            cmp.set('v.RenderProtocols', false);
        }
        else {
            cmp.set('v.RenderProtocols', true);
        }
    },
    showNotPresent : function (cmp, event, button) {
        var cor = cmp.get('v.RenderNotPresentData');
        if(cor == true) {
            cmp.set('v.RenderNotPresentData', false);
        }
        else {
            cmp.set('v.RenderNotPresentData', true);
        }
    },
    handleSelectData : function(cmp, event) {
        let protocolId = event.getParam("protocolId");
        let sectionType = event.getParam("sectionType");
        let checked = event.getParam("checked");
        
        if (sectionType === 'assigned') {
            let found = this.assignedModified.find(x => x.protocolId === protocolId);
            if (found) {
                this.assignedModified = this.assignedModified.filter(x => x.protocolId !== protocolId);
            }
            else {
                this.assignedModified.push({"protocolId": protocolId, "checked": checked});
            }
        }
        else if (sectionType === 'unassigned') {
            let found = this.unassignedModified.find(x => x.protocolId === protocolId);
            if (found) {
                this.unassignedModified = this.unassignedModified.filter(x => x.protocolId !== protocolId);
            }
            else {
                this.unassignedModified.push({"protocolId": protocolId, "checked": checked});
            }
        }
    },
    handleSave : function(cmp, event) {
        this.assignedModified = [];
        this.unassignedModified = [];
        $A.get('e.force:refreshView').fire();
    }
});