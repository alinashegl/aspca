/**
 * Created by barne on 4/16/2021.
 */

({
    downloadDocument : function(component, event, helper) {

        var sendDataProc = component.get("v.sendData");
        var dataToSend = {
            "label" : "Placeholder"
        };

        sendDataProc(dataToSend, function() {

           //handle callback
        });
    }
});