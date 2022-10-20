/*
 * Created by barne on 4/29/2021.
 */

({

    doInit : function (cmp, event, helper)
    {
        helper.processingProcess(cmp, 'init');
    },
    handleChange : function(cmp) {
        var selected = cmp.get("v.tabId");
        cmp.find('tabs').set('v.selectedTabId', selected);
        console.log('Selected Tab Id ====> ' + cmp.get('v.tabId'));

        var selectedSubtab = cmp.get('v.subTabId');
        if(selectedSubtab == !undefined ) {
            this.handleSubtabs(cmp, event, selectedSubtab);
            //alert('ITS WORKING');
        }
    } ,
    handleClick : function(cmp, event, helper) {
        var button = event.getSource().get('v.name');
        //var ctab = cmp.get('v.tabId');
        //alert('This is the event: ' + button);
        //alert('Current Tab ===> ' + ctab);
        helper.buttonAction(cmp, event, button);
    } ,
    handleSelect: function(cmp, event, helper){
        helper.processingProcess(cmp, 'handleSelect');
    } ,
    handleCaution: function(cmp, event, helper){
        helper.processingProcess(cmp, 'handleCaution');
    } ,
    activetab: function (cmp, event) {
        var a = cmp.get('v.UseCaution');
        console.log(a);
    } ,
    refresh: function (cmp, event, helper) {
        helper.checkValidity(cmp, event);
        $A.get('e.force:refreshView').fire();
    } ,
    handleUnpleasantTouch: function(cmp, event, helper){
        helper.processingProcess(cmp, 'handleUnpleasantTouch', event);
    } ,
    handleHousing: function(cmp, event, helper) {
        helper.setHousing(cmp, event);
    },
    handleMuzzle: function(cmp, event, helper) {
        helper.setMuzzle(cmp, event);
    },
    handleSkipSaveEvent: function(cmp, event, helper) {
        var behaviorEvalObj = event.getParam("behaviorEvalObj");
        cmp.set("v.behaviorEvaluation",behaviorEvalObj);        
        // helper.handleSkipSubsequentTest(cmp, event);
    },

    handleLocationChange : function (cmp, event, helper) {
        // confirm('You have unsaved data. Do you want to leave?');
        var rid = cmp.get('v.recordId');
        var apiName = 'IsLocked__c';
        var state = true;
        var status = 'status';
        var t;

        var params = {
            apiName: apiName ,
            values: state ,
            recordId : rid
        };
        helper.sendPromise(cmp, 'c.putBoolean', params, status)
        .then(
            function(response) {
            }
        ).catch(
          function(error) {
              console.log('Error Message', error);
          }
        );
        event.preventDefault();
     },

     handleMessage : function(component, message, helper) {
        helper.handleMessage(component, message);
    },

    handleEvalUpdateMessage : function(component, message, helper) {
        helper.handleEvalUpdateMessage(component, message);
    },
});