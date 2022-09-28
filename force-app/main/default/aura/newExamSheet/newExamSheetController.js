({
    init: function(cmp, event, helper) {
        var recordTypeId = cmp.get("v.pageReference").state.recordTypeId;
        cmp.set("v.recordTypeId", recordTypeId);
        
        var pageRef = cmp.get("v.pageReference");
        console.log(JSON.stringify(pageRef));
        var state = pageRef.state;
        console.log('state = '+JSON.stringify(state));
        var base64Context = state.inContextOfRef;
        console.log('base64Context = '+base64Context);
        if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
            console.log('base64Context = '+base64Context);
        }
        var addressableContext = JSON.parse(window.atob(base64Context));
        console.log('addressableContext = '+JSON.stringify(addressableContext));
        cmp.set("v.animalId", addressableContext.attributes.recordId);
    },
    reInit: function(cmp, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    handleCancel: function(cmp, event, helper) {
		var params = event.getParams();
        var animalId = cmp.get("v.animalId");
        
    	cmp.find("navService").navigate({
        	"type": "standard__recordPage",
        	"attributes": {
            	"recordId": animalId,
            	"objectApiName": "Animal__c",
            	"actionName": "view"
        	}
    	});
    },
    success: function(cmp, event, helper) {
    	var params = event.getParams();
        var animalId = cmp.get("v.animalId");
        
    	cmp.find("navService").navigate({
        	"type": "standard__recordPage",
        	"attributes": {
                "recordId": params.response.id,
            	"objectApiName": "Animal__c",
            	"actionName": "view"
        	}
    	});
    }
})