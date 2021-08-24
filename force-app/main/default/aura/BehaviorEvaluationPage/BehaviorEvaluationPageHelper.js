/*
 * Created by barne on 4/30/2021.
 */

({
    testType: [
        {label: 'Adult', value: 'Adult' } ,
        {label: 'Puppy', value: 'Puppy' } ,
        { label: 'Dog Fighting', value: 'Dog Fighting' }
    ] ,

    tablist: {
        behaveInKennel: {
            nextTab: 'bol' ,
            lastTab: 'osdt3'
        } ,
        bol : {
            nextTab: 'sbt1' ,
            lastTab: 'behaveInKennel'
        } ,
        sbt1 : {
            nextTab: 'sbt2' ,
            lastTab: 'bol'
        } ,
        sbt2 : {
            nextTab: 'ptt' ,
            lastTab: 'sbt1'
        } ,
        ptt : {
            nextTab: 'utt' ,
            lastTab: 'sbt2'
        } ,
        utt: {
            nextTab: 'pt1' ,
            lastTab: 'ptt'
        } ,
        pt1: {
            nextTab: 'pt2' ,
            lastTab: 'utt'

        } ,
        pt2: {
            nextTab: 'tag' ,
            lastTab: 'pt1'

        } ,
        tag: {
            nextTab: 'rgt1' ,
            lastTab: 'pt2'
        } ,
        rgt1: {
            nextTab: 'rgt2' ,
            lastTab: 'tag'
        } ,
        rgt2: {
            nextTab: 'tdt1' ,
            lastTab: 'rgt1'
        } ,
        tdt1: {
            nextTab: 'tdt2' ,
            lastTab: 'rgt2'
        } ,
        tdt2: {
            nextTab: 'spt1' ,
            lastTab: 'tdt1'
        } ,
        spt1: {
            nextTab: 'spt2' ,
            lastTab: 'tdt2'
        } ,
        spt2: {
            nextTab: 'fdit' ,
            lastTab: 'spt1'
        } ,
        fdit: {
            nextTab: 'ssdt1' ,
            lastTab: 'spt2'
        } ,
        ssdt1: {
            nextTab: 'ssdt2' ,
            lastTab: 'fdit'
        } ,
        ssdt2: {
            nextTab: 'ssdt3' ,
            lastTab: 'ssdt1'
        } ,
        ssdt3: {
            nextTab: 'osdt1' ,
            lastTab: 'ssdt2'
        } ,
        osdt1: {
            nextTab: 'osdt2' ,
            lastTab: 'ssdt3'
        } ,
        osdt2: {
            nextTab: 'osdt3' ,
            lastTab: 'osdt1'
        } ,
        osdt3: {
            nextTab: 'behaveInKennel' ,
            lastTab: 'osdt2'
        } ,
        pbik: {
            nextTab: 'pbol' ,
            lastTab: 'pdi3'
        } ,
        pbol: {
            nextTab: 'psb1',
            lastTab: 'pbik'
        } ,
        psb1: {
            nextTab: 'psb2',
            lastTab: 'pbol'
         } ,
        psb2: {
            nextTab: 'ppt1',
            lastTab: 'psb1'
        } ,
        ppt1: {
            nextTab: 'ppt2' ,
            lastTab: 'psb2'
        } ,
        ppt2: {
            nextTab: 'ppt',
            lastTab: 'ppt1'
        } ,
        ppt: {
            nextTab: 'pr',
            lastTab: 'ppt2'
        } ,
        pr: {
            nextTab: 'prg1',
            lastTab: 'ppt'
        } ,
        prg1: {
            nextTab: 'prg2',
            lastTab: 'pr'
        } ,
        prg2: {
            nextTab: 'pcd1' ,
            lastTab: 'prg1'
        } ,
        pcd1: {
            nextTab: 'pcd2',
            lastTab: 'prg2'
        } ,
        pcd2: {
            nextTab: 'pdi1',
            lastTab: 'pcd1'
        } ,
        pdi1: {
            nextTab: 'pdi2' ,
            lastTab: 'pcd2'
        } ,
        pdi2: {
            nextTab: 'pdi3',
            lastTab: 'pdi1'
        } ,
        pdi3: {
            nextTab: 'pbik',
            lastTab: 'pdi2'
        }
    } ,
    processingProcess: function(cmp, currentProcess,event) {
            let process = {
                'loadTabs': 'loadTabs' ,
                'init': 'init' ,
                'handleSelect' : 'handleSelect' ,
                'loadPuppyTabs' : 'loadPuppyTabs' ,
                'render' : 'render' ,
                'handleCaution' : 'handleCaution',
                'handleUnpleasantTouch' : 'handleUnpleasantTouch'
            };

            if(process[currentProcess] == 'init') {
                this.init(cmp, event);
            }else if(process[currentProcess] == 'handleSelect') {
                this.setEvalType(cmp, event);
            }else if(process[currentProcess] == 'loadTabs'){
                this.loadTabs(cmp, event);
            }else if(process[currentProcess] == 'loadPuppyTabs') {
                this.loadPuppyTabs(cmp, event);
            }else if(process[currentProcess] == 'render') {
                this.render(cmp, event);
            }else if(process[currentProcess] == 'handleCaution') {
                this.handleCaution(cmp, event);
            }else if(process[currentProcess] == 'handleUnpleasantTouch') {
                this.handleUnpleasantTouch(cmp, event);
            }
            else {
                console.log('Unexpected Error occured ');
            }
        } ,
    init : function(cmp, event) {
        cmp.set('v.testTypes', this.testType);
        this.loadBehaviorReport(cmp, event);
    } ,
    handleCaution: function(cmp, event) {
        var rid = cmp.get('v.recordId');
        var apiName = 'Caution__c';
        var ref = cmp.find('cautionInput');
        var state = ref.get('v.checked');
        var status = 'status';
        var t;

        var params = {
            apiName: apiName ,
            values: state ,
            recordId : rid
        };
        this.sendPromise(cmp, 'c.putBoolean', params, status)
        .then(
            function(response) {
                if(response[status] != 'SUCCESS') {
                    var item = response[status];
                    var data = item['data'];
                    var dataitem = data['item'];
                    cmp.set('v.UseCaution', dataitem);
                }
            }
        ).catch(
          function(error) {
              console.log('Error Message', error);
          }
        );
    } ,

    handleUnpleasantTouch: function(cmp, event) {
        var auraId = event.getSource().getLocalId();
        var isFirstTouch = (auraId == 'UnpleasantTouch1stFlankInput') ? true : false;
        console.log('upleasantTouch: ', auraId);


        var rid = cmp.get('v.recordId');
        var apiName = (isFirstTouch) ? 'Unpleasant_Touch_1st_Flank__c' : 'Unpleasant_Touch_2nd_Flank__c';
        var ref = cmp.find(auraId);
        var state = ref.get('v.checked');
        var status = 'status';
        var t;

        var params = {
            apiName: apiName ,
            values: state ,
            recordId : rid
        };
        this.sendPromise(cmp, 'c.putBoolean', params, status)
        .then(
            function(response) {
                if(response[status] != 'SUCCESS') {
                    var item = response[status];
                    var data = item['data'];
                    var dataitem = data['item'];
                    if(isFirstTouch){
                        cmp.set('v.UnpleasantTouch1stFlank', dataitem);
                    } else {
                        cmp.set('v.UnpleasantTouch2ndFlank', dataitem);
                    }
                }
            }
        ).catch(
          function(error) {
              console.log('Error Message', error);
          }
        );
    } ,
    render: function (cmp, event) {
        console.log('AFTER RENDER');
    } ,

    loadTabs : function (cmp, event) {
        /*
        var data = {};
        var tabs = [];
        var params = {
            key: cmp.get('v.recordId')
        };
        var bik = 'behaviorInKennelTest';
        this.sendRequest(cmp, 'c.getBehaviorInKennel', params, bik)
        .then(bik => {
            console.log('BIK Tab result:', JSON.stringify(bik));
            tabs.push(bik);
            cmp.set('v.tabs', tabs);
        })
        .catch(errors => {
           console.log('BIK TAB ERRORS', errors);
        });

        //console.log('$$$$$$$$$$$BIK DATA $$$$$$$$$$ => ', JSON.stringify(bik));
        //tabs.push(data);

        //console.log('############# TAB DATA ################', JSON.stringify(tabs));
        */
        //this.loadBehaviorReport(cmp, event);
        this.loadBehaviorInKennel(cmp, event);
        this.loadBehaviorOnLeash(cmp, event);
        this.loadSocialPartOne(cmp, event);
        this.loadSocialPartTwo(cmp, event);
        this.loadPleasantTouch(cmp, event);
        this.loadUnpleasantTouch(cmp, event);
        this.loadPlayTestPartOne(cmp, event);
        this.loadPlayTestPartTwo(cmp, event);
        this.loadTagTest(cmp, event);
        this.loadResource(cmp, event);
        this.loadResourceTF(cmp, event);
        this.loadResourceTB(cmp, event);
        this.loadResourceTN(cmp, event);
        this.loadResourceTwo(cmp, event);
        this.loadToddlerOne(cmp, event);
        this.loadToddlerTwo(cmp, event);
        this.loadScoldingPersonOne(cmp, event);
        this.loadScoldingPersonTwo(cmp, event);
        this.loadFakeDog(cmp, event);
        this.loadSameSexOne(cmp, event);
        this.loadSameSexTwo(cmp, event);
        this.loadSameSexThree(cmp, event);
        this.loadOppositeSexOne(cmp, event);
        this.loadOppositeSexTwo(cmp, event);
        this.loadOppositeSexThree(cmp, event);
        this.loadResourceTwoTF(cmp, event);
        this.loadResourceTwoTN(cmp, event);
        this.loadResourceTwoTB(cmp, event);
        //cmp.set('v.tabId', 'behaveInKennel');

    } ,
    getVal : function(cmp, attr) {
        return cmp.get('v.' + attr);
    } ,
    setVal: function(cmp, attr, value) {
        return cmp.set('v.' + attr, value);
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


    sendRequest : function(cmp, methodName, params, attr, setValue) {
            var action = cmp.get(methodName);
            action.setParams(params);
            action.setCallback(this, function(response) {
                var state = response.getState();
                var result = response.getReturnValue();
                console.log(result);
                if(state == 'SUCCESS') {

                    if(setValue == false) {
                    }else {
                    this.setVal(cmp, attr, result);
                    }
                    //console.log(result.skipField);
                    //console.log(methodName + '@@@RETURNED VALUE ===>   ' + JSON.stringify(result));
                    return result;
                }else if (state == 'ERROR') {
                    let err = response.getError();
                    console.log('###### Error message =====> ' + JSON.stringify(err));
                }
            });
            $A.enqueueAction(action);
    } ,

    checkValidity: function(cmp,event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var status = 'status';
        var item = 'item';
        var m_item = {};
        this.sendPromise(cmp, 'c.handleValidity', params, status)
        .then(
            function(response) {
                if(response[status] != 'SUCCESS') {
                    var result = response[status];
                    m_item = result['data'];
                    console.log('Items', m_item);
                    if(m_item['item'].endsWith(':')) {
                        cmp.find('lib').showToast({
                            'title': 'Success' ,
                            'message': 'Evaluation has been completed successfully' ,
                            'variant': 'success'
                        });
                    }else {
                        console.log('Result',result);
                        var data = result['data'];
                        console.log('Data',data);
                        var item = data['item'];
                        console.log('Item', item);
                        //confirm(JSON.stringify(item));
                        cmp.find('lib').showToast({
                            'title': 'ERROR' ,
                            'message': item,
                            'variant': 'error'
                        });
                    }

                }
            }
        ).then(
            function(m_item) {
                console.log('next thing ',m_item.length);
            }
        ).catch(
            function(error) {
                console.log('Error Message',error);
            }
        );

    } ,

    validCheck: function(error) {
        alert(error);
    } ,

    loadBehaviorReport : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'behaviorReport';
        var data;
        this.sendPromise(cmp, 'c.getBehaviorReport', params, attr)
        .then(
            function(response, data) {
                console.log('PROMISE RESPONSE', response[attr]);
                cmp.set('v.UseCaution', response[attr].UseCaution);

                console.log('1st Touch = ', response[attr].UnpleasantTouch1stFlank);
                console.log('2nd Touch = ', response[attr].UnpleasantTouch2ndFlank);
                cmp.set('v.UnpleasantTouch1stFlank', response[attr].UnpleasantTouch1stFlank);
                cmp.set('v.UnpleasantTouch2ndFlank', response[attr].UnpleasantTouch2ndFlank);
                cmp.set('v.PuppySingly', response[attr].puppyHousing == 'Singly-housed' ? true : false);
                cmp.set('v.PuppyCoHoused', response[attr].puppyHousing == 'Co-housed' ? true : false);
                cmp.set('v.PuppyMuzzle1', response[attr].puppyMuzzledDogInteraction1);
                cmp.set('v.PuppyMuzzle2', response[attr].puppyMuzzledDogInteraction2);
                cmp.set('v.PuppyMuzzle3', response[attr].puppyMuzzledDogInteraction3);
                cmp.set('v.MuzzleSSD3', response[attr].muzzledSameSexDog3);
                cmp.set('v.MuzzleOSD3', response[attr].muzzledOppositeSexDog3);

                if(response[attr].IsAdult == true) {
                    cmp.set('v.IsAdult', true);
                    console.log('IS ADULT TEST');
                    if(response[attr].IsDogFighting == true) {
                        cmp.set('v.IsDogFighting', true);
                        console.log('Is Dog Fighting?', response[attr].IsDogFighting);
                    }
                    cmp.set('v.tabId', 'behaveInKennel');
                    data = 'Adult';
                    this.processingProcess(cmp, 'loadTabs');
                }
                if(response[attr].IsPuppy == true) {
                    cmp.set('v.IsPuppy', true);
                    console.log('IS PUPPY TEST');
                    cmp.set('v.tabId', 'pbik');
                    data = 'Puppy'
                    this.processingProcess(cmp, 'loadPuppyTabs');
                }
            }
        ).catch(
            function(error) {
                console.log('Error Message',error);
            }
        );
        console.log('Data', data);
        if(data == undefined) {
            if (data == 'Adult') {

            }
            if (data == 'Puppy') {

            }
            this.processingProcess(cmp, 'loadTabs');
            this.processingProcess(cmp, 'loadPuppyTabs');
        }
    } ,

    loadBehaviorInKennel : function(cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'behaviorInKennelTest';
        this.sendRequest(cmp, 'c.getBehaviorInKennel', params, attr);

    } ,

    loadBehaviorOnLeash : function(cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'behaviorOnLeashTest';
        this.sendRequest(cmp, 'c.getBehaviorOnLeash', params, attr);
    } ,
    loadSocialPartOne : function(cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'socialBehaviorTestPart1';
        this.sendRequest(cmp, 'c.getSocialBehaviorTestOne', params, attr);

    } ,
    loadSocialPartTwo : function(cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'socialBehaviorTestPart2';
        this.sendRequest(cmp, 'c.getSocialBehaviorTestTwo', params, attr);

    } ,
    loadPleasantTouch : function(cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'pleasantTouchTest';
        this.sendRequest(cmp, 'c.getPleasantTouchTest', params, attr);

    } ,
    loadUnpleasantTouch : function(cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'unpleasantTouchTest';
        this.sendRequest(cmp, 'c.getUnpleasantTouchTestOne', params, attr);
    } ,

    loadPlayTestPartOne : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'playTestPart1';
        this.sendRequest(cmp, 'c.getPlayTestPartOne', params, attr);
    } ,
    loadPlayTestPartTwo : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'playTestPart2';
        this.sendRequest(cmp, 'c.getPlayTestPartTwo', params, attr);
    } ,
    loadTagTest : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'tagTest';
        this.sendRequest(cmp, 'c.getTagTest', params, attr);
    } ,
    loadResource : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'resourceGuardingTestPart1';
        this.sendRequest(cmp, 'c.getResourceGuardingOnePF', params, attr);

    } ,
    loadResourceTF : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'resourceGuardingTestPart1TF';
        this.sendRequest(cmp, 'c.getResourceGuardingOneTF', params, attr);
    } ,
    loadResourceTN : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'resourceGuardingTestPart1TN';
        this.sendRequest(cmp, 'c.getResourceGuardingOneTN', params, attr);
    } ,
    loadResourceTB : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'resourceGuardingTestPart1TB';
        this.sendRequest(cmp, 'c.getResourceGuardingOneTB', params, attr);
    } ,
    loadResourceTwo : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'resourceGuardingTestPart2';
        this.sendRequest(cmp, 'c.getResourceGuardingTwo', params, attr);
    } ,
    loadResourceTwoTF : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'resourceGuardingTestPart2TF';
        this.sendRequest(cmp, 'c.getResourceGuardingTF', params, attr);
    } ,
    loadResourceTwoTN : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'resourceGuardingTestPart2TN';
        this.sendRequest(cmp, 'c.getResourceGuardingTwoTN', params, attr);
    } ,
    loadResourceTwoTB : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'resourceGuardingTestPart2TB';
        this.sendRequest(cmp, 'c.getResourceGuardingTwoTB', params, attr);
    } ,
    loadToddlerOne : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'toddlerDollTestPart1';
        this.sendRequest(cmp, 'c.getToddlerDollTestOne', params, attr);
    } ,
    loadToddlerTwo : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'toddlerDollTestP2';
        this.sendRequest(cmp, 'c.getToddlerDollTestTwo', params, attr);
    } ,
    loadScoldingPersonOne : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'scoldingPersonTestP1';
        this.sendRequest(cmp, 'c.getScoldingPersonTestOne', params, attr);

    } ,
    loadScoldingPersonTwo : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'scoldingPersonTestP2';
        this.sendRequest(cmp, 'c.getScoldingPersonTestTwo', params, attr);
    } ,
    loadFakeDog : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'fakeDogInteractionTest';
        this.sendPromise(cmp, 'c.getFakeDogTest', params, attr)
        .then(
            function(response) {
                cmp.set('v.fakeDogInteractionTest', response[attr]);
            }
        ).catch(
            function(error) {
                console.log('Error Message',error);
            }
        );
    } ,
    loadSameSexOne : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'sameSexDogTestPart1';
        this.sendPromise(cmp, 'c.getSameSexDogTestOne', params, attr)
        .then(
            function(response) {
                cmp.set('v.sameSexDogTestPart1', response[attr]);
            }
        ).catch(
            function(error) {
                console.log('Error Message',error);
            }
        );
    } ,
    loadSameSexTwo : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'sameSexDogTestPart2';
        this.sendPromise(cmp, 'c.getSameSexDogTestTwo', params, attr)
        .then(
            function(response) {
                cmp.set('v.sameSexDogTestPart2', response[attr]);
            }
        ).catch(
            function(error) {
                console.log('Error Message',error);
            }
        );
    } ,
    loadSameSexThree : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'sameSexDogTestPart3';
        this.sendPromise(cmp, 'c.getSameSexDogTestThree', params, attr)
        .then(
            function(response) {
                cmp.set('v.sameSexDogTestPart3', response[attr]);
            }
        ).catch(
            function(error) {
                console.log('Error Message',error);
            }
        );
    } ,
    loadOppositeSexOne : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'oppositeSexDogTestPart1';
        this.sendPromise(cmp, 'c.getOppositeSexDogTestOne', params, attr)
        .then(
            function(response) {
                cmp.set('v.oppositeSexDogTestPart1', response[attr]);;
            }
        ).catch(
            function(error) {
                console.log('Error Message',error);
            }
        );
    } ,
    loadOppositeSexTwo : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'oppositeSexDogTestPart2';
        this.sendPromise(cmp, 'c.getOppositeSexDogTestTwo', params, attr)
        .then(
            function(response) {
                cmp.set('v.oppositeSexDogTestPart2', response[attr]);
            }
        ).catch(
            function(error) {
                console.log('Error Message',error);
            }
        );
    } ,
    loadOppositeSexThree : function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'oppositeSexDogTestPart3';
        this.sendPromise(cmp, 'c.getOppositeSexDogTestThree', params, attr)
        .then(
            function(response) {
                cmp.set('v.oppositeSexDogTestPart3', response[attr]);
                //cmp.set('v.tabId', 'behaveInKennel');
            }
        ).catch(
            function(error) {
                console.log('Error Message',error);
            }
        );
    } ,
    /*******************************************************************************************************************/
    /************** Puppy Properties ***********************************************************************************/
    /******************************************************************************************************************/

    loadPuppyBIK: function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'puppyBehaviorInKennel';
        this.sendRequest(cmp, 'c.getPuppyBehaviorInKennel', params, attr);
    } ,
    loadPuppyBOL: function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'puppyBehaviorOnLeash';
        this.sendRequest(cmp, 'c.getPuppyBehaviorOnLeash', params, attr);
    } ,
    loadPuppySB1: function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'puppySocialBehaviorPart1';
        this.sendRequest(cmp, 'c.getPuppySocialBehaviorPart1', params, attr);
    } ,
    loadPuppySB2: function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'puppySocialBehaviorPart2';
        this.sendRequest(cmp, 'c.getPuppySocialBehaviorPart2', params, attr);
    } ,
    loadPuppyPTug1: function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'puppyPlayTestTugPart1';
        this.sendRequest(cmp, 'c.getPuppyPlayTestTugP1', params, attr);
    } ,
    loadPuppyPTug2: function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'puppyPlayTestTugPart2';
        this.sendRequest(cmp, 'c.getPuppyPlayTestTugP2', params, attr);
    } ,
    loadPuppyPT: function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'puppyPlayTestTag';
        this.sendRequest(cmp, 'c.getPuppyPlayTestTugTug', params, attr);
    } ,
    loadPuppyRestraint: function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'puppyRestraint';
        this.sendRequest(cmp, 'c.getPuppyRestraint', params, attr);
    } ,
    loadPuppyChildDollOne: function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'puppyChildDollPart1';
        this.sendRequest(cmp, 'c.getPuppyChildDollOne', params, attr);
    } ,
    loadPuppyChildDollTwo: function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'puppyChildDollPart2';
        this.sendRequest(cmp, 'c.getPuppyChildDollTwo', params, attr);
    } ,
    loadPuppyResourceGuardingOne: function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'puppyResourceGuardingPart1';
        this.sendRequest(cmp, 'c.getPuppyResourceGuardingPartOne', params, attr);
    } ,
    loadPuppyResourceGuardingTwo: function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'puppyResourceGuardingPart2';
        this.sendRequest(cmp, 'c.getPuppyResourceGuardingPartTwo', params, attr);
    } ,
    loadPuppyDogInteractionOne: function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'puppyDogInteractionPart1';
        this.sendRequest(cmp, 'c.getPuppyDogInteractionOne', params, attr);
    } ,
    loadPuppyDogInteractionTwo: function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'puppyDogInteractionPart2';
        this.sendRequest(cmp, 'c.getPuppyDogInteractionTwo', params, attr);
    } ,
    loadPuppyDogInteractionThree: function (cmp, event) {
        var params = {
            key: cmp.get('v.recordId')
        };
        var attr = 'puppyDogInteractionPart3';
        var result = [];
        this.sendPromise(cmp, 'c.getPuppyDogInteractionThree', params, attr)
        .then(
            function(response) {
                console.log('End of Puppy', response[attr]);
                cmp.set('v.puppyDogInteractionPart3', response[attr]);
                if(cmp.get('v.IsPuppy')) {
                    cmp.set('v.tabId', 'pbik');
                }
            }
        ).catch(
            function(error) {
                console.log('Error Message',error);
            }
        );
    } ,


    loadPuppyTabs : function (cmp, event) {
        this.loadPuppyBIK(cmp, event);
        this.loadPuppyBOL(cmp, event);
        this.loadPuppySB1(cmp, event);
        this.loadPuppySB2(cmp, event);
        this.loadPuppyPTug1(cmp, event);
        this.loadPuppyPTug2(cmp, event);
        this.loadPuppyPT(cmp, event);
        this.loadPuppyRestraint(cmp, event);
        this.loadPuppyChildDollOne(cmp, event);
        this.loadPuppyChildDollTwo(cmp, event);
        this.loadPuppyResourceGuardingOne(cmp, event);
        this.loadPuppyResourceGuardingTwo(cmp, event);
        this.loadPuppyDogInteractionOne(cmp, event);
        this.loadPuppyDogInteractionTwo(cmp, event);
        this.loadPuppyDogInteractionThree(cmp, event);

    } ,

    buttonAction : function(cmp, event, button) {
        if(button == 'nextTab') {
            this.handleNextTab(cmp, event, button);
        }else if (button == 'prevTab') {
            this.handlePrevTab(cmp, event, button);
        }else if (button == 'showHelperDog') {
            this.showHelperDog(cmp, event, button);
        }else if (button == 'closeModal') {
            this.closeModal(cmp, event, button);
        }else if (button == 'chooseEvalType') {
            this.chooseEvalType(cmp, event, button);
        }else if(button = 'cancel') {
            this.closeModal(cmp, event, button);
        }
    } ,
    closeModal : function(cmp, event, button) {
        cmp.set('v.showModal', false);
    } ,
    showHelperDog : function(cmp, event, button) {
        cmp.set('v.showModal', true);
    } ,
    handleNextTab : function(cmp, event, button) {
        var c = cmp.get('v.tabId');
        var x = this.tablist[c];
        var i_DogFight = cmp.get('v.IsDogFighting');
        //console.log(i_DogFight);
        //console.log(i_IsAdult);
        if((x['nextTab'] == 'ssdt1')&& (cmp.get('v.UseCaution') == true))  {
            cmp.find('lib').showToast({
                'title': 'CAUTION' ,
                'message': 'USE CAUTION FOR REAL DOG TEST',
                'variant': 'error'
            });
            /*
            cmp.find('overlayLib').showCustomModal({
                header: 'CAUTION',
                body: 'USE CAUTION FOR REAL DOG TEST',
                showCloseButton: true
            });
            */
            confirm('Use Caution for Real Dog Test');
        }
        if((x['nextTab'] == 'osdt1')&& (cmp.get('v.UseCaution') == true)) {
             cmp.find('lib').showToast({
                'title': 'CAUTION' ,
                'message': 'USE CAUTION FOR REAL DOG TEST',
                'variant': 'error'
             });
             confirm('Use Caution for Real Dog Test');
        }
        if(i_DogFight == false || i_DogFight == undefined) {
                    if(x['nextTab'] == 'fdit') {
                        x = this.tablist['fdit'];
                    }
                    cmp.set('v.tabId' , x['nextTab']);
                }else {
                    cmp.set('v.tabId' , x['nextTab']);
                }
        $A.get('e.force:refreshView').fire();
    } ,
    handlePrevTab: function(cmp, event, button) {
        var c = cmp.get('v.tabId');
        var x = this.tablist[c];
        var i_DogFight = cmp.get('v.IsDogFighting');
        cmp.set('v.tabId', x['lastTab']);
        if(i_DogFight == false || i_DogFight == undefined) {
            if(x['lastTab'] == 'fdit') {
                x = this.tablist['fdit'];
            }
            cmp.set('v.tabId' , x['lastTab']);
        }else {
            cmp.set('v.tabId' , x['lastTab']);
        }
        if((x['lastTab'] == 'ssdt1')&& (cmp.get('v.UseCaution') == true)) {
                    cmp.find('lib').showToast({
                        'title': 'CAUTION' ,
                        'message': 'USE CAUTION FOR REAL DOG TEST',
                        'variant': 'error'
                    });
                    confirm('Use Caution for Real Dog Test');
                }
        if((x['lastTab'] == 'osdt1')&& (cmp.get('v.UseCaution') == true)) {
                    cmp.find('lib').showToast({
                        'title': 'CAUTION' ,
                        'message': 'USE CAUTION FOR REAL DOG TEST',
                        'variant': 'error'
                    });
                    confirm('Use Caution for Real Dog Test');
                }
        $A.get('e.force:refreshView').fire();
    } ,
    chooseEvalType: function(cmp, event, button) {
        cmp.set('v.iShowModal', true);
    } ,
    setEvalType: function(cmp, event) {
        var test = cmp.find('types').get('v.value');
        console.log(test);
        if(test == 'Adult') {
            cmp.set('v.IsAdult', true);
            cmp.set('v.iShowModal',false);
            this.processingProcess(cmp, 'loadTabs');
            //$A.get('e.force:refreshView').fire();
        }else if(test =='Puppy') {
            cmp.set('v.IsPuppy', true);
            cmp.set('v.iShowModal', false);
            this.processingProcess(cmp, 'loadPuppyTabs');
            //$A.get('e.force:refreshView').fire();
        }else if(test =='Dog Fighting') {
           cmp.set('v.IsAdult', true);
           cmp.set('v.IsDogFighting', true);
           cmp.set('v.iShowModal',false);
           this.processingProcess(cmp, 'loadTabs');
           console.log('DOG FIGHTING CASE');
           //$A.get('e.force:refreshView').fire();
        }
    },
    setHousing: function(cmp, event) {
        var rid = cmp.get('v.recordId');
        var apiName = 'Puppy_BIK_Housing__c';
        var clicked = event.target.value;
        var state = clicked == 'singly' ? 'Singly-housed' : 'Co-housed';
        var status = 'status';

        var params = {
            apiName: apiName ,
            values: state ,
            recordId : rid
        };
        this.sendPromise(cmp, 'c.putSelection', params, status)
        .then(
            function(response) {
                if(response[status].status != 'success') {
                    cmp.set('v.PuppySingly', state == 'Singly-housed' ? false : true);
                    cmp.set('v.PuppyCoHoused', state == 'Co-housed' ? false : true);
                }
            }
        ).catch(
          function(error) {
              console.log('Error Message', error);
          }
        );
    },
    setMuzzle: function(cmp, event) {
        var rid = cmp.get('v.recordId');
        var cmpId = event.target.id;
        var status = 'status';
        var apiName;
        var cmpAttr;
        switch(cmpId) {
            case 'PMuzzled1':
            case 'PNotMuzzled1':
                apiName = 'Puppy_Muzzled_DI_P1__c';
                cmpAttr = 'v.PuppyMuzzle1';
                break;
            case 'PMuzzled2':
            case 'PNotMuzzled2':
                apiName = 'Puppy_Muzzled_DI_P2__c';
                cmpAttr = 'v.PuppyMuzzle2';
                break;
            case 'PMuzzled3':
            case 'PNotMuzzled3':
                apiName = 'Puppy_Muzzled_DI_P3__c';
                cmpAttr = 'v.PuppyMuzzle3';
                break;
            case 'SMuzzled3':
            case 'SNotMuzzled3':
                apiName = 'Muzzled_SSD_P3__c';
                cmpAttr = 'v.MuzzleSSD3';
                break;
            case 'OMuzzled3':
            case 'ONotMuzzled3':
                apiName = 'Muzzled_OSD_P3__c';
                cmpAttr = 'v.MuzzleOSD3';
                break;
            default:
                console.log(`Field not mapped for ${cmpId}.`);
                return;
        }
        var value = cmp.get(cmpAttr);

        var params = {
            apiName: apiName,
            values: !value,
            recordId : rid
        };
        this.sendPromise(cmp, 'c.putBoolean', params, status)
        .then(
            function(response) {
                if(response[status].status != 'success') {
                    cmp.set(cmpAttr, value);
                }
                else {
                    cmp.set(cmpAttr, !value);
                }
            }
        ).catch(
          function(error) {
              console.log('Error Message', error);
          }
        );
    }
});