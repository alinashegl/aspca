/**
 * Created by barne on 5/24/2021.
 */

({
    doInit : function (cmp, event, helper)
    {
        helper.processingProcess(cmp, 'init');
    } ,
    handleSkip : function(cmp, event, helper)
    {
        helper.processingProcess(cmp, 'handleSkip');
    } ,
    handleCancel: function(cmp, event, helper)
    {
        helper.processingProcess(cmp, 'handleCancel');
    } ,
    handleSave: function(cmp, event, helper)
    {
        helper.processingProcess(cmp, 'handleSave');
    } ,
    handleTabSave: function(cmp, event, helper)
    {
        helper.processingProcess(cmp, 'handleTabSave');
    } ,
    handleChange: function(cmp, event, helper)
    {
        helper.processingProcess(cmp, 'handleChange');
    } ,
    handleNewSkip: function(cmp, event, helper)
    {
        helper.processingProcess(cmp, 'handleNewSkip');
    } ,
    handleAuraMethod : function(cmp, event, helper){
        let params = event.getParam('arguments');
        if (params) {
            console.log(JSON.stringify(params));
            console.log('skipreason:' + cmp.get('v.skipReason'))
            helper.sendValues(cmp, 
                              params.evalObj.recordId, 
                              params.evalObj.apiName, 
                              params.evalObj.values, 
                              params.evalObj.methodName); 
            
        }
    }
    
});