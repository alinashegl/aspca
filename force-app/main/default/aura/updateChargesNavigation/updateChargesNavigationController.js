({
	init : function(cmp, event, helper) {
		var navService = cmp.find("navService");
        var recordId = cmp.get("v.recordId");
        var pageReference = {
        	"type" : "standard__component",
        	"attributes" : {
                "componentName" : "c__updateCharges"
        	},
            "state" : {
                "c__caseID" : recordId
        	}
        };
        navService.navigate(pageReference);
	}
})