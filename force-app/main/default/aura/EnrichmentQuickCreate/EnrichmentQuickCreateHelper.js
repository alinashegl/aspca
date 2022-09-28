({
    validateEnrichmentForm: function(component) {
        var validEnrichment = true;

        // Show error messages if required fields are blank
        var allValid = component.find('enrichmentField').reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);

        if (allValid) {
            //Verify coordinator
            var coordinator = component.get("v.newEnrichment.Enrichment_Coordinator__c");
            var coordinatorCmp = component.find("enrichmentCoordinator");
            coordinatorCmp.doValidityCheck();
            if($A.util.isUndefinedOrNull(coordinator) || $A.util.isEmpty(coordinator)) {
                validEnrichment = false;
                console.log("Quick action context missing coordinator.");
            }
        }

        return(validEnrichment);
    }
})