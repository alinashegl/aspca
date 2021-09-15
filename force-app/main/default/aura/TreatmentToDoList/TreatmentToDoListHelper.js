/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */
({


    fetchData : function(cmp, event) {
        var loc = 'MRC';
        var params = { key: loc };
        this.sendPromise(cmp, 'c.listData', params)
        .then(
            function(response) {
                console.log('Response', response);
                var data = response;
                cmp.set('v.data', response);
                console.log('Response Value', response);
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
        } ,
        buttonAction : function(cmp, event, button) {
        if(button == 'showProtocols') {
            this.showProtocols(cmp, event, button);
        }
    } ,

    showProtocols : function (cmp, event, button) {
        //console.log('SHOW PROTOCOLS');
        var cor = cmp.find('dataList').get('v.items');
        console.log('Component', cor);

    }

});