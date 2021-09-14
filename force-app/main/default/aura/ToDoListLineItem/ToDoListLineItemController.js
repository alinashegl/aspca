/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */
({
    handleClick : function(cmp, event, helper) {
            var button = event.getSource().get('v.name');
            helper.buttonAction(cmp, event, button);
        }
});