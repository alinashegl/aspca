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
    }
});