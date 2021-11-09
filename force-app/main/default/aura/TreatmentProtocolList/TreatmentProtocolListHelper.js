/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */
({
    selectOption : function(cmp, event) {
        let target = event.getSource();
        let protocolId = target.get("v.name");
        let sectionType = cmp.get("v.sectionType");
        let checked = target.get("v.checked");
        let inPlan = !checked && sectionType === 'assigned';
        let protocolSelectEvent = cmp.getEvent("protocolSelectEvent");
        protocolSelectEvent.setParams({
            "protocolId" : protocolId,
            "sectionType" : sectionType,
            "inPlan" : inPlan,
            "checked" : checked 
        });
        protocolSelectEvent.fire();
    }
});