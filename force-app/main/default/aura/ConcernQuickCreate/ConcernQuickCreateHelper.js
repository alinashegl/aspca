({
    validateObservationForm: function(component) {
        var validObservation = true;

        // Show error messages if required fields are blank
        var allValid = component.find('observationField').reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);

        if (allValid) {
            // Verify we have an enrichment to attach it to
            var enrichment = component.get("v.enrichment");
            if($A.util.isEmpty(enrichment)) {
                validObservation = false;
                console.log("Quick action context doesn't have a valid enrichment.");
            }
        }

        return(validObservation);
    }
})