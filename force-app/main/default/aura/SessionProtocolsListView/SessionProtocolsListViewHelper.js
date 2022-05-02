/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */
({

    processingProcess : function (cmp, currentProcess, event)
    {
        let process = {
            'init' : 'init' ,
            'render' : 'render'
        };

        if(process[currentProcess] == 'init') {
            this.init(cmp, event);
        }

    } ,

    init : function(cmp, event) {
        var rid = cmp.get('v.recordId');
        var params = {
            recordId : rid
        };
        var status = 'status';
        this.sendPromise(cmp, 'c.renderView', params)
        .then(
            function(response) {
              console.log('Response', response);
              $A.get('e.force:refreshView').fire();
            }
        ).catch(
            function(error) {
                console.log('Error Message', error);
            }
        );
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