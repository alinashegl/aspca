({
	init : function(cmp, event, helper) {
		var pageRef = cmp.get("v.pageReference");
        var caseID = pageRef.state.c__caseID;
        //var caseID = cmp.get("v.recordId");
        cmp.set("v.caseID", caseID);
        var sentenceOptions
        var actionCharges = cmp.get("c.getCharges");
        actionCharges.setParams({
            caseID : caseID
        })
        actionCharges.setCallback(this, function(responseCharges){
            var stateCharges = responseCharges.getState();
            if(stateCharges === "SUCCESS"){
                var chargesResult = responseCharges.getReturnValue();
                cmp.set("v.chargeList", chargesResult);
                for (var i = 0; i < chargesResult.length; i++) {
					var sentenceValue = chargesResult[i].Sentence_Details_Picklist__c;
                    if(sentenceValue != null && sentenceValue != ""){
                        var splitSentenceValue = [];
                        splitSentenceValue = sentenceValue.toString().split(';');
                        var sentenceSelections = cmp.find("sentencePicklist")[i];
                        sentenceSelections.set("v.value", splitSentenceValue);                        
                    }
                }
            }
        });
        var actionDisposition = cmp.get("c.dispositionOptions");
        actionDisposition.setCallback(this, function(responseDisposition){
            var stateDisposition = responseDisposition.getState();
            if(stateDisposition === "SUCCESS"){
                cmp.set("v.dispositionOptions", responseDisposition.getReturnValue());
            }
        });
		var actionSentence = cmp.get("c.sentenceOptions");
        actionSentence.setCallback(this, function(responseSentence){
            var stateSentence = responseSentence.getState();
            if(stateSentence === "SUCCESS"){
                var sentenceResult = responseSentence.getReturnValue();
                var sentenceOptions = [];
                var blankOptions = [];
                for (var i = 0; i < sentenceResult.length; i++) {
                    sentenceOptions.push({
                        label: sentenceResult[i],
                        value: sentenceResult[i]
                    });
                }
                blankOptions.push({
                        label: "None",
                        value: null
                    });
                cmp.set("v.sentenceOptions", sentenceOptions);
                cmp.set("v.blankOptions", blankOptions);
            }
        });
        $A.enqueueAction(actionCharges);
        $A.enqueueAction(actionDisposition);
        $A.enqueueAction(actionSentence);
	},
    saveCharges : function(cmp, event, helper) {
        var charges = cmp.get("v.chargeList");
        var caseID = cmp.get("v.caseID");
        var action = cmp.get("c.updateCharges")
        action.setParams({
            updatedCharges : charges
        })
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
            	cmp.find("navigationService").navigate({
        			"type": "standard__recordPage",
        			"attributes": {
                		"recordId": caseID,
            			"objectApiName": "Case",
            			"actionName": "view"
        			}
    			});
            }
        });
        $A.enqueueAction(action);
	},
    cancelEdit : function(cmp, event, helper) {
        var caseID = cmp.get("v.caseID");
        cmp.find("navigationService").navigate({
       		"type": "standard__recordPage",
        	"attributes": {
                "recordId": caseID,
            	"objectApiName": "Case",
            	"actionName": "view"
        	}
    	});
	}
})