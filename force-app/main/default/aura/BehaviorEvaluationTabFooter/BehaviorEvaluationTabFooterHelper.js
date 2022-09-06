/**
 * Created by barne on 5/24/2021.
 */

({
    /*
    skipReasons: [
        {label: 'Skipped to safeguard welfare of the animal' , value: 'Skipped to safeguard welfare of the animal'} ,
        {label: 'Skipped due to risk to the handler' , value: 'Skipped due to risk to the handler'} ,
        {label: 'Skipped for medical reason' , value: 'Skipped for medical reason'} ,
        {label: 'Skipped due to not having an appropriate helper dog' , value: 'Skipped due to not having an appropriate helper dog'} ,
        {label: 'Skipped due to risk to the helper dog' , value: 'Skipped due to risk to the helper dog'} ,
        {label: 'Skipped not necessary' , value: 'Skipped not necessary'}
    ] ,
    */

    processingProcess: function(cmp, currentProcess)
    {
        let process =
        {
            'handleCancel': 'handleCancel' ,
            'init': 'init' ,
            'handleSkip' : 'handleSkip' ,
            'handleTabSave' : 'putComments' ,
            'handleSave' : 'putSkipReason' ,
            'handleModal' : 'handleModal' ,
            'refresh' : 'refresh' ,
            'handleChange': 'handleChange' ,
            'handleNewSkip': 'handleNewSkip'
        };

        if(process[currentProcess] == 'init')
        {
            this.init(cmp, event);
        }
        else if(process[currentProcess] == 'handleSkip')
        {
            this.handleSkip(cmp, event);
        }
        else if(process[currentProcess] == 'handleCancel')
        {
            this.handleCancel(cmp, event);
        }
        else if(process[currentProcess] == 'putComments')
        {
            this.putComments(cmp, event);
        }
        else if(process[currentProcess] == 'putSkipReason')
        {
            this.putSkipReason(cmp, event);
        }
        else if(process[currentProcess]== 'handleModal')
        {
            this.handleModal(cmp, event);
        }else if(process[currentProcess] == 'handleChange')
        {
            this.handleChange(cmp, event);
        }else if(process[currentProcess] == 'handleNewSkip')
        {
            this.handleNewSkip
        }
        else
        {
            console.log('Unexpected Error occured ');
        }
    } ,
    init: function(cmp)
    {
        //console.log('Footer is Executing!!!');
        var params = { key: 0};
        this.sendRequest(cmp, 'c.getSkipReasons', params, 'skipReasons');
    } ,
    handleChange: function(cmp, event)
    {
        console.log('CHANGE EVENT', cmp.find('reasons'));
    } ,
    handleSkip : function (cmp, event)
    {
        let skipVal = cmp.get("v.IsSkipped");
        if(skipVal){
            cmp.set('v.showModal', true);
        } else {
            cmp.set('v.skipReason', null);
            this.putSkipReason(cmp, event);
        }
    } ,
    handleModal: function(cmp, event)
    {
        cmp.set('v.showModal', false);
        $A.get('e.force:refreshView').fire();
    } ,
    handleCancel: function(cmp, event)
    {
        cmp.set('v.IsSkipped', false);
        this.processingProcess(cmp, 'handleModal');
    } ,
    handleNewSkip: function(cmp, event)
    {
        var reason = cmp.find('newReasons');
        console.log(reason);
    } ,
    putSkipReason : function(cmp, event)
    {
       var reason = cmp.get('v.skipReason');
       //var r = cmp.find('reasons').get('v.value');
       var apiName = cmp.get('v.skipVal');
       var recordId = cmp.get('v.recordId');
       //console.log('Skip Reason => ', r);
       console.log('###VARIABLE', reason);
       //console.log('Skip API Name ---> ' + JSON.stringify(apiName.id));
       this.processingProcess(cmp, 'handleModal');
       this.sendValues(cmp, recordId, apiName.id, reason, 'c.updateEval');
       $A.get('e.force:refreshView').fire();
    } ,

    sendRequest : function(cmp, methodName, params, attr) {
                var action = cmp.get(methodName);
                action.setParams(params);
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    var result = response.getReturnValue();
                    if(state == 'SUCCESS') {
                        //console.log('@@ SUCCESS action ==> ' + action);
                        //console.log('@@@@ This ' + JSON.stringify(action) + ' Has this result =====> ' + JSON.stringify(result));
                        this.setVal(cmp, attr, result);
                        return result;
                    }else if (state == 'ERROR') {
                        let err = response.getError();
                        console.log('###### Error message =====> ' + JSON.stringify(err));
                    }
                });
                $A.enqueueAction(action);
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
                reject(action.getError())
              } else {
                reject(action.getError())
              }
            });
            $A.enqueueAction(action);
        }));
    } ,
    getVal : function(cmp, attr) {
        return cmp.get('v.' + attr);
    } ,
    setVal: function(cmp, attr, value) {
        return cmp.set('v.' + attr, value);
    } ,

    sendValues: function(cmp, recordId, apiName, values, methodName) {
        var params = {
            apiName: apiName ,
            values: values ,
            recordId: recordId
        };

        var mName = methodName;

        //alert(JSON.stringify(params['apiName']));

        //this.sendRequest(cmp, 'c.updateEval', params);
		var comp = cmp;
        this.sendPromise(cmp, mName, params, params[apiName])
        .then(
          function(response) {
              console.log('SENT VALUES RESPONSE', response);
              $A.get('e.force:refreshView').fire();
              var compEvent = comp.getEvent("skipSaveEvt");
              compEvent.setParams({
                  behaviorEvalObj: response,
                  params: params
              });
              compEvent.fire();
          }
        ).catch(
            function(error) {
                console.log(error)
            }
        );
    } ,
    putComments : function (cmp, event) {
        var c = cmp.find('testComments');
        var a = cmp.get('v.testName');
        var v = c.get('v.value');
        var rId = cmp.get('v.recordId');

        var params = {
            apiName: a.id ,
            values: v ,
            recordId: rId
        };
        this.sendPromise(cmp, 'c.updateEval', params, a.id)
        .then(
            function(response) {
                console.log('PROMISE RESPONSE', response[a.id]);
                $A.get('e.force:refreshView').fire();
                cmp.find('lib').showToast({
                            'title': 'Success' ,
                            'message': 'Test Comments Were Saved Successfully, Proceed to the Next Tab to see the' +
                            ' Change' ,
                            'variant': 'success'
                        });
            }
        ).catch(
            function(error) {
                console.log(error)
            }
        );

        //this.sendValues(cmp, recordId, apiName.id, val);


    }
});