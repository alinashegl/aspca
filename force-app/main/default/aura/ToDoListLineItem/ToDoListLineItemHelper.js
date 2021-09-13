/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */
({
    buttonAction : function(cmp, event, button) {
            if(button == 'showProtocols') {
                this.showProtocols(cmp, event, button);
            }else if(button == 'showNotPresent') {
                this.showNotPresent(cmp, event, button);
            }
        } ,
        showProtocols : function (cmp, event, button) {
               //console.log('SHOW PROTOCOLS');
            var cor = cmp.get('v.RenderProtocols');
            if(cor == true) {
                cmp.set('v.RenderProtocols', false);
            }else {
                cmp.set('v.RenderProtocols', true);
            }
            console.log('Component', cor);

        } ,
        showNotPresent : function (cmp, event, button) {
            var cor = cmp.get('v.RenderNotPresentData');
            if(cor == true) {
                cmp.set('v.RenderNotPresentData', false);
            }else {
                cmp.set('v.RenderNotPresentData', true);
            }
            //console.log('Component', cor);
        }
});