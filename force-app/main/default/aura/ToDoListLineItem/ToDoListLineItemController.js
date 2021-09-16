/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */
({
    init : function(cmp, event, helper) {

    } ,
    onAnimalChange : function(cmp, event) {
        var data = cmp.get('v.AnimalId');
       cmp.set('v.AnimalUrlPath', '/' + data);
       console.log(data);

    } ,
    onPlanChange : function (cmp, event) {
        var data = cmp.get('v.PlanId');
        cmp.set('v.TreatmentPlanURLPath', '/' + data);
    } ,
    handleClick : function(cmp, event, helper) {
            var button = event.getSource().get('v.name');
            helper.buttonAction(cmp, event, button);
        }
});