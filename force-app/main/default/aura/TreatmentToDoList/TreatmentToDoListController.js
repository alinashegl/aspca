/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */
({
    init : function(cmp , event, helper) {
        cmp.set('v.columns', [
            { label: 'Animal', fieldName: 'name' , type: 'text' } ,
            { label: 'Treatment Priority', fieldName: 'priority', type: 'text'} ,
            { label: 'Bundle Assignment' , fieldName: 'assignment',type: 'text' } ,
            { label: 'Treatment Count', fieldName: 'treatmentcount', type: 'text' } ,
            { label: 'Shelter Color Code', fieldName: 'colorCode', type: 'text' } ,
            { label: 'Button Placeholder', fieldName: 'animal' , type: 'text' }
        ]);
        helper.fetchData(cmp, event);
    },
    handleClick : function(cmp, event, helper) {
        var button = event.getSource().get('v.name');
        helper.buttonAction(cmp, event, button);
    }
});