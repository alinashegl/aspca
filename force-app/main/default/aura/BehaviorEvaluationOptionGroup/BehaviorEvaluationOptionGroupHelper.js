/**
 * Created by barne on 5/20/2021.
 */

({
    processingProcess: function(cmp, currentProcess) {
        let process = {
            'scriptsLoaded': 'scriptsLoaded' ,
            'init': 'init' ,
            'handleSelect' : 'handleSelect'
        };

        if(process[currentProcess] == 'init') {
            this.init(cmp, event);
        }else if(process[currentProcess] == 'handleSelect') {
            this.selectOption(cmp, event);
        }
        else {
            console.log('Unexpected Error occured ');
        }
    } ,

    init : function(cmp, event) {
       // console.log('Executing!')
    } ,

    selectOption : function(cmp, event) {
        var options = cmp.find('opts');
        //console.log('Options',options);
        //console.log('Options Params', cmp.get('v.options'));
        var variable = cmp.get('v.options');
        var p =  ''; //options[0].get('v.name');
        var recordid = cmp.get('v.recordId');
        var clearSkipReason = false;

        //alert(p);
        var result = [];
        if(options.length > 1) {
            p = options[0].get('v.name');
            for(var i=0; i<options.length; i++){
               var r = {
                   label: options[i].get('v.label') ,
                    isSelected: options[i].get('v.checked')
               };
               if(r.isSelected){
                clearSkipReason = true;
               }
               try {
                 result.push(JSON.stringify(r));
               }catch(err) {
                   console.log(err);
               }
            }
        }else {

            var s = cmp.get('v.options');
            //ps = s[0];
            console.log('Opt Param 1 ',s[0]);
            p = s[0].pleApiName;
            var x = {
                label: s[0].label ,
                isSelected: s[0].IsSelected
            };
            try {
                result.push(JSON.stringify(x));
            }catch(err){
                alert(err);
            }
        }

        console.log(p + ' ===>' + result);
        this.putSelections(cmp, p, result, recordid);
        if(clearSkipReason){
            this.sendValues(cmp, recordId, apiName.id, reason, 'c.updateEval');
        }
        $A.get('e.force:refreshView').fire();
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

    putSelections : function(cmp, p, result, recordid) {
        var params = {
            apiName: p ,
            values: result ,
            recordId: recordid
        };
        this.sendRequest(cmp, 'c.putSelections', params);

    } ,

    getAttribute : function(cmp, attr) {
        return cmp.get('v.' + attr);
    } ,
    setAttribute: function(cmp, attr, value) {
        return cmp.set('v.' + attr, value);
    } ,

    sendRequest : function(cmp, methodName, params) {
        var action = cmp.get(methodName);
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if(state == 'SUCCESS') {
                return result;
                cmp.find('lib').showToast({
                            'title': 'Success' ,
                            'message': 'Saved Successfully, Proceed to the Next Tab to see the' +
                            ' Change' ,
                            'variant': 'success'
                        });
            }else if (state == 'ERROR') {
                let err = response.getError();
                console.log('###### Error message =====> ' + JSON.stringify(err));
            }
        });
        $A.enqueueAction(action);
    }

});