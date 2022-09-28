/**
 * Created by barne on 6/1/2021.
 */

({
    testType : {
        resourceGuardingOne : {
            colOne : 'Resource_Guarding_P1_Touch_Body__c' ,
            colTwo:  'Resource_Guarding_P1_Touch_Neck__c' ,
            colThree:  'Resource_Guarding_P1_Touch_Face__c',
            colFour:   'Resource_Guarding_P1_Push_Face__c',
        } ,
        resourceGuardingTwo: {
            colOne : 'Resource_Guarding_P2_Touch_Body__c' ,
            colTwo:  'Resource_Guarding_P2_Touch_Neck__c' ,
            colThree:  'Resource_Guarding_P2_Touch_Face__c',
            colFour:   'Resource_Guarding_P2_Push_Face__c',
        } ,
        unpleasantTouch: {
            colOne : 'Unpleasant_Touch_1st__c' ,
            colTwo:  'Unpleasant_Touch_2nd__c' ,

        } ,
        puppyResourceGuardingOne : {
            colOne : 'Puppy_Resource_Guarding_P1_Touch_Body__c' ,
            colTwo:  'Puppy_Resource_Guarding_P1_Touch_Neck__c' ,
            colThree:  'Puppy_Resource_Guarding_P1_Touch_Face__c',
            colFour:   'Puppy_Resource_Guarding_P1_Push_Face__c',
        } ,
        puppyResourceGuardingTwo: {
            colOne : 'Puppy_Resource_Guarding_P2_Touch_Body__c' ,
            colTwo:  'Puppy_Resource_Guarding_P2_Touch_Neck__c' ,
            colThree:  'Puppy_Resource_Guarding_P2_Touch_Face__c',
            colFour:   'Puppy_Resource_Guarding_P2_Push_Face__c',
        } ,

    } ,
    processingProcess: function(cmp, currentProcess) {
        let process = {
            'scriptsLoaded': 'scriptsLoaded' ,
            'init': 'init' ,
            'handleSelect' : 'handleSelect' ,
            'setTestType' : 'setTestType' ,
            'handleSelect2' : 'handleSelect2' ,
            'handleSelect3' : 'handleSelect3' ,
            'handleSelect4' : 'handleSelect4' ,
        };

        if(process[currentProcess] == 'init') {
            this.init(cmp, event);
        }else if(process[currentProcess] == 'handleSelect') {
            this.selectOption(cmp, event);
        }else if(process[currentProcess] == 'setTestType') {
                     this.setTestType(cmp, event);
        }else if(process[currentProcess] == 'handleSelect2') {
            this.selectOption2(cmp, event);
        }else if(process[currentProcess] == 'handleSelect3') {
            this.selectOption3(cmp, event);
        }else if(process[currentProcess] == 'handleSelect4') {
            this.selectOption4(cmp, event);
        }
        else {
            console.log('Unexpected Error occured ');
        }
    } ,

    init : function(cmp, event) {
        console.log('Executing!')
        console.log(this.testType);
        console.log(cmp.get('v.type'));
        this.processingProcess(cmp, 'setTestType');
    } ,

    setTestType: function(cmp, event) {
        var t = cmp.get('v.type');
        console.log('Test Type: ',this.testType[t].colOne);
        if(this.testType[t] == 'Resource_Guarding_P1_Touch_Body__c' ) {
            cmp.set('v.col1API', this.testType[t].colOne);
            cmp.set('v.col2API', this.testType[t].colTwo);
            cmp.set('v.col3API', this.testType[t].colThree);
            cmp.set('v.col4API', this.testType[t].colFour);
        } else if(this.testType[t] == 'Resource_Guarding_P2_Touch_Body__c' ) {
            cmp.set('v.col1API', this.testType[t].colOne);
            cmp.set('v.col2API', this.testType[t].colTwo);
            cmp.set('v.col3API', this.testType[t].colThree);
            cmp.set('v.col4API', this.testType[t].colFour);
        } else if(this.testType[t] == 'Unpleasant_Touch_1st__c' ) {
            cmp.set('v.col1API', this.testType[t].colOne);
            cmp.set('v.col2API', this.testType[t].colTwo);
        } else if(this.testType[t] == 'Puppy_Resource_Guarding_P1_Touch_Body__c') {
            cmp.set('v.col1API', this.testType[t].colOne);
            cmp.set('v.col2API', this.testType[t].colTwo);
            cmp.set('v.col3API', this.testType[t].colThree);
            cmp.set('v.col4API', this.testType[t].colFour);
        }  else if(this.testType[t] == 'Puppy_Resource_Guarding_P2_Touch_Body__c') {
            cmp.set('v.col1API', this.testType[t].colOne);
            cmp.set('v.col2API', this.testType[t].colTwo);
            cmp.set('v.col3API', this.testType[t].colThree);
            cmp.set('v.col4API', this.testType[t].colFour);
        }
    } ,

    selectOption : function(cmp, event) {
        var t = cmp.get('v.type');
        var options = cmp.find('opts');
        var p = this.testType[t].colOne;
        var recordid = cmp.get('v.recordId');

        //alert(p);
        var result = [];
        if(Array.isArray(options)) {
            for(var i=0; i<options.length; i++){
                var r = {
                        label: options[i].get('v.label') ,
                        isSelected: options[i].get('v.checked')
                    };
                    result.push(JSON.stringify(r));
            }
        }else {
            var r = {
                label: options.get('v.label') ,
                isSelected: options.get('v.checked')
            };
            result.push(JSON.stringify(r));
        }
        console.log(p + ' ===>' + result);
        this.putSelections(cmp, p, result, recordid);
        $A.get('e.force:refreshView').fire();

    } ,
    selectOption2 : function(cmp, event) {
        var t = cmp.get('v.type');
        var options = cmp.find('opts2');
        var p = this.testType[t].colTwo;
        var recordid = cmp.get('v.recordId');

        //alert(p);
        var result = [];
        if(Array.isArray(options)) {
            for(var i=0; i<options.length; i++){
                var r = {
                        label: options[i].get('v.label') ,
                        isSelected: options[i].get('v.checked')
                    };
                    result.push(JSON.stringify(r));
            }
        }else {
            var r = {
                label: options.get('v.label') ,
                isSelected: options.get('v.checked')
            };
            result.push(JSON.stringify(r));
        }
        console.log(p + ' ===>' + result);
        this.putSelections(cmp, p, result, recordid);
        $A.get('e.force:refreshView').fire();

    } ,
    selectOption3 : function(cmp, event) {
        var t = cmp.get('v.type');
        var options = cmp.find('opts3');
        var p = this.testType[t].colThree;
        var recordid = cmp.get('v.recordId');

        //alert(p);
        var result = [];
        if(Array.isArray(options)) {
            for(var i=0; i<options.length; i++){
                var r = {
                        label: options[i].get('v.label') ,
                        isSelected: options[i].get('v.checked')
                    };
                    result.push(JSON.stringify(r));
            }
        }else {
            var r = {
                label: options.get('v.label') ,
                isSelected: options.get('v.checked')
            };
            result.push(JSON.stringify(r));
        }
        console.log(p + ' ===>' + result);
        this.putSelections(cmp, p, result, recordid);
        $A.get('e.force:refreshView').fire();

    } ,
    selectOption4 : function(cmp, event) {
        var t = cmp.get('v.type');
        var options = cmp.find('opts4');
        var p = this.testType[t].colFour;
        var recordid = cmp.get('v.recordId');

        //alert(p);
        var result = [];
        if(Array.isArray(options)) {
            for(var i=0; i<options.length; i++){
                var r = {
                        label: options[i].get('v.label') ,
                        isSelected: options[i].get('v.checked')
                    };
                    result.push(JSON.stringify(r));
            }
        }else {
            var r = {
                label: options.get('v.label') ,
                isSelected: options.get('v.checked')
            };
            result.push(JSON.stringify(r));
        }
        console.log(p + ' ===>' + result);
        this.putSelections(cmp, p, result, recordid);
        $A.get('e.force:refreshView').fire();

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
            }else if (state == 'ERROR') {
                let err = response.getError();
                console.log('###### Error message =====> ' + JSON.stringify(err));
            }
        });
        $A.enqueueAction(action);
    }

});