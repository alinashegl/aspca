/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */
({
    processingProcess : function (cmp, currentProcess) {
        let process = {
            'init' : 'init'
        };
        if(process[currentProcess] == 'init') {
            this.init(cmp, event);
        }
    } ,
    // INIT FUNCTION BELOW
    init : function(cmp, event) {
        var columns = [
            {
                type: 'text' ,
                fieldName: 'planName',
                label: 'Plan Name'
            },
            {
                type: 'text' ,
                fieldName: 'assignedBundleName',
                label: 'Assigned Treatment Bundle'
            },
            {
                type: 'boolean' ,
                fieldName: 'isActive',
                label: 'Is Active Treatment Plan'
            },
            {
                type: 'url' ,
                fieldName: 'animalRecord',
                label: 'Animal' ,
                typeAttributes: {
                    label: { fieldName: 'animalRecordName'}
                }
            }
        ];
        cmp.set('v.gridColumns', columns);
        var nestedData = [
            {
                "name" : '123456' ,
                "planName" : 'Plan Alpha' ,
                "isActive" : true ,
                'animalRecord' : 'https://domain.com/plan-alpha' ,
                'animalRecordName' : 'Bilbo Swaggins' ,
                //add lines here for more _children records
                "_children" : [
                    {
                        "name" : '123456-A' ,
                        "planName" : 'Session Alpha One' ,
                        "isActive" : false ,
                        'animalRecord' : 'https://domain.com/plan-alpha' ,
                        'animalRecordName' : 'Bilbo Swaggins'
                    }
                ]
            } ,
            {
                "name" : '123456' ,
                "planName" : 'Plan Alpha' ,
                "isActive" : true ,
                'animalRecord' : 'https://domain.com/plan-alpha' ,
                'animalRecordName' : 'Bilbo Swaggins' ,
                //add lines here for more _children records
                "_children" : [
                    {
                        "name" : '123456-A' ,
                        "planName" : 'Session Alpha One' ,
                        "isActive" : false ,
                        'animalRecord' : 'https://domain.com/plan-alpha' ,
                        'animalRecordName' : 'Bilbo Swaggins'
                    }
                ]
            } ,
            {
                "name" : '123456' ,
                "planName" : 'Plan Alpha' ,
                "isActive" : true ,
                'animalRecord' : 'https://domain.com/plan-alpha' ,
                'animalRecordName' : 'Bilbo Swaggins' ,
                //add lines here for more _children records
                "_children" : [
                    {
                        "name" : '123456-A' ,
                        "planName" : 'Session Alpha One' ,
                        "isActive" : false ,
                        'animalRecord' : 'https://domain.com/plan-alpha' ,
                        'animalRecordName' : 'Bilbo Swaggins'
                    }
                ]
            } ,
        ]
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
    }
});