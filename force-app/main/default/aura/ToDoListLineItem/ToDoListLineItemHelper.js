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
            }else if(button == 'updatePlanProtocols') {
                this.updatePlanProtocols(cmp, event, button);
            }
        } ,
        updatePlanProtocols : function (cmp, event, button) {
            var data = cmp.get('v.Data');
            var rid = cmp.get('v.PlanId');

            var params = {
                planId : rid ,
                data : data
            };

            this.sendPromise(cmp, 'c.saveChanges', params)
            .then(
                function(response) {
                    console.log('Response', response);
                }
            ).catch(
                function(error) {
                    console.log('Error Message', error);
                }
            );
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
        } ,
        sendPromise : function(cmp, methodName, params, category) {
            return new Promise($A.getCallback(function(resolve, reject) {
            let action = cmp.get(methodName);

            action.setParams(params);

            action.setCallback(self, function(res) {
              let state = res.getState();

              if(state === 'SUCCESS') {
                let result = {};


                if(typeof category == 'undefined') {
                    result = res.getReturnValue();
                } else {
                    result[category] = res.getReturnValue();
                }

                resolve(result);
              } else if(state === 'ERROR') {
                reject(action.getError());
              } else {
                reject(action.getError());
              }
            });
            $A.enqueueAction(action);
        }));
    }
});