/*
 * Created by barne on 4/30/2021.
 */

({
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
        cmp.set("v.spinner", true);
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

        var rid = cmp.get('v.recordId');
        var apiName = (isFirstTouch) ? 'Unpleasant_Touch_1st_Flank__c' : 'Unpleasant_Touch_2nd_Flank__c';
        var ref = cmp.find(auraId);
        var state = ref.get('v.checked');
        var status = 'status';

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

    loadTabs : function (cmp, event) {
        this.loadAdultBehaviorData(cmp);
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
        var params1 = {
            key: cmp.get('v.recordId')
        };
        var self = this;

        var attr = 'behaviorReport';
        self.sendPromise(cmp, 'c.getOne', params1)
        .then(
            function(response) {
                cmp.set('v.behaviorRecord', response);
                var params2 = {
                    behaviorEvaluation: response
                }
                return self.sendPromise(cmp, 'c.getBehaviorReport', params2, attr)
            }
        )
        .then(
            function(response) {
                cmp.set('v.UseCaution', response[attr].UseCaution);
                cmp.set('v.UnpleasantTouch1stFlank', response[attr].UnpleasantTouch1stFlank);
                cmp.set('v.UnpleasantTouch2ndFlank', response[attr].UnpleasantTouch2ndFlank);
                cmp.set('v.PuppySingly', response[attr].puppyHousing == 'Singly-housed' ? true : false);
                cmp.set('v.PuppyCoHoused', response[attr].puppyHousing == 'Co-housed' ? true : false);
                cmp.set('v.PuppyMuzzle1', response[attr].puppyMuzzledDogInteraction1);
                cmp.set('v.PuppyMuzzle2', response[attr].puppyMuzzledDogInteraction2);
                cmp.set('v.PuppyMuzzle3', response[attr].puppyMuzzledDogInteraction3);
                cmp.set('v.MuzzleSSD3', response[attr].muzzledSameSexDog3);
                cmp.set('v.MuzzleOSD3', response[attr].muzzledOppositeSexDog3);
                cmp.set('v.IsAdult', response[attr].IsAdult);
                cmp.set('v.IsDogFighting', response[attr].IsDogFighting);
                cmp.set('v.IsDogOnly', response[attr].IsDogOnly);
                cmp.set('v.IsPuppy', response[attr].IsPuppy);

                if (response[attr].IsAdult) {
                    if (response[attr].IsDogOnly) {
                        cmp.set('v.tabId', 'ssdt1');
                    }
                    else {
                        cmp.set('v.tabId', 'behaveInKennel');
                    }
                    self.processingProcess(cmp, 'loadTabs');
                }
                else if (response[attr].IsPuppy) {
                    cmp.set('v.tabId', 'pbik');
                    self.processingProcess(cmp, 'loadPuppyTabs');
                }
            }
        )
        .catch(
            function(error) {
                console.log('Error Message',error);
            }
        );
    } ,
    loadAdultBehaviorData : function(cmp) {
        var allTabsArr = Object.keys(this.tablist);
        var params = {
            evaluation: cmp.get('v.behaviorRecord')
        };
        this.sendPromise(cmp, 'c.getAdultEvaluation', params)
        .then(
            function(response) {
                cmp.set('v.behaviorInKennelTest', response[0]);
                cmp.set('v.behaviorOnLeashTest', response[1]);
                cmp.set('v.socialBehaviorTestPart1', response[2]);
                cmp.set('v.socialBehaviorTestPart2', response[3]);
                cmp.set('v.pleasantTouchTest', response[4]);
                //Gather multi-column data by value category
                let ut = response[5];
                let utvc0 = new Array();
                for (let i = 0; i < ut.wrapper1.mZeroOptions.length; i++) {
                    utvc0.push({"column1": ut.wrapper1.mZeroOptions[i], "column2": ut.wrapper2.mZeroOptions[i]});
                }
                let utvc1 = new Array();
                for (let i = 0; i < ut.wrapper1.mNotConcerningOptions.length; i++) {
                    utvc1.push({"column1": ut.wrapper1.mNotConcerningOptions[i], "column2": ut.wrapper2.mNotConcerningOptions[i]});
                }
                let utvc2 = new Array();
                for (let i = 0; i < ut.wrapper1.mRedFlagOptions.length; i++) {
                    utvc2.push({"column1": ut.wrapper1.mRedFlagOptions[i], "column2": ut.wrapper2.mRedFlagOptions[i]});
                }
                let utvc3 = new Array();
                for (let i = 0; i < ut.wrapper1.mAlertOptions.length; i++) {
                    utvc3.push({"column1": ut.wrapper1.mAlertOptions[i], "column2": ut.wrapper2.mAlertOptions[i]});
                }
                let utvc4 = new Array();
                for (let i = 0; i < ut.wrapper1.mInconclusiveOptions.length; i++) {
                    utvc4.push({"column1": ut.wrapper1.mInconclusiveOptions[i], "column2": ut.wrapper2.mInconclusiveOptions[i]});
                }
                ut.VC0 = utvc0;
                ut.VC1 = utvc1;
                ut.VC2 = utvc2;
                ut.VC3 = utvc3;
                ut.VC4 = utvc4;
                cmp.set('v.unpleasantTouchTest', ut);
                cmp.set('v.playTestPart1', response[6]);
                cmp.set('v.playTestPart2', response[7]);
                cmp.set('v.tagTest', response[8]);
                //Gather multi-column data by value category
                let rg1 = response[9];
                let rg1vc1 = new Array();
                for (let i = 0; i < rg1.wrapper1.mNotConcerningOptions.length; i++) {
                    rg1vc1.push({"column1": rg1.wrapper1.mNotConcerningOptions[i], "column2": rg1.wrapper2.mNotConcerningOptions[i], "column3": rg1.wrapper3.mNotConcerningOptions[i], "column4": rg1.wrapper4.mNotConcerningOptions[i]});
                }
                let rg1vc2 = new Array();
                for (let i = 0; i < rg1.wrapper1.mRedFlagOptions.length; i++) {
                    rg1vc2.push({"column1": rg1.wrapper1.mRedFlagOptions[i], "column2": rg1.wrapper2.mRedFlagOptions[i], "column3": rg1.wrapper3.mRedFlagOptions[i], "column4": rg1.wrapper4.mRedFlagOptions[i]});
                }
                let rg1vc3 = new Array();
                for (let i = 0; i < rg1.wrapper1.mAlertOptions.length; i++) {
                    rg1vc3.push({"column1": rg1.wrapper1.mAlertOptions[i], "column2": rg1.wrapper2.mAlertOptions[i], "column3": rg1.wrapper3.mAlertOptions[i], "column4": rg1.wrapper4.mAlertOptions[i]});
                }
                let rg1vc4 = new Array();
                for (let i = 0; i < rg1.wrapper1.mInconclusiveOptions.length; i++) {
                    rg1vc4.push({"column1": rg1.wrapper1.mInconclusiveOptions[i], "column2": rg1.wrapper2.mInconclusiveOptions[i], "column3": rg1.wrapper3.mInconclusiveOptions[i], "column4": rg1.wrapper4.mInconclusiveOptions[i]});
                }
                rg1.VC1 = rg1vc1;
                rg1.VC2 = rg1vc2;
                rg1.VC3 = rg1vc3;
                rg1.VC4 = rg1vc4;
                cmp.set('v.resourceGuardingTestPart1', rg1);
                //Gather multi-column data by value category
                let rg2 = response[10];
                let rg2vc1 = new Array();
                for (let i = 0; i < rg2.wrapper1.mNotConcerningOptions.length; i++) {
                    rg2vc1.push({"column1": rg2.wrapper1.mNotConcerningOptions[i], "column2": rg2.wrapper2.mNotConcerningOptions[i], "column3": rg2.wrapper3.mNotConcerningOptions[i], "column4": rg2.wrapper4.mNotConcerningOptions[i]});
                }
                let rg2vc2 = new Array();
                for (let i = 0; i < rg2.wrapper1.mRedFlagOptions.length; i++) {
                    rg2vc2.push({"column1": rg2.wrapper1.mRedFlagOptions[i], "column2": rg2.wrapper2.mRedFlagOptions[i], "column3": rg2.wrapper3.mRedFlagOptions[i], "column4": rg2.wrapper4.mRedFlagOptions[i]});
                }
                let rg2vc3 = new Array();
                for (let i = 0; i < rg2.wrapper1.mAlertOptions.length; i++) {
                    rg2vc3.push({"column1": rg2.wrapper1.mAlertOptions[i], "column2": rg2.wrapper2.mAlertOptions[i], "column3": rg2.wrapper3.mAlertOptions[i], "column4": rg2.wrapper4.mAlertOptions[i]});
                }
                let rg2vc4 = new Array();
                for (let i = 0; i < rg2.wrapper1.mInconclusiveOptions.length; i++) {
                    rg2vc4.push({"column1": rg2.wrapper1.mInconclusiveOptions[i], "column2": rg2.wrapper2.mInconclusiveOptions[i], "column3": rg2.wrapper3.mInconclusiveOptions[i], "column4": rg2.wrapper4.mInconclusiveOptions[i]});
                }
                rg2.VC1 = rg2vc1;
                rg2.VC2 = rg2vc2;
                rg2.VC3 = rg2vc3;
                rg2.VC4 = rg2vc4;
                cmp.set('v.resourceGuardingTestPart2', rg2);
                cmp.set('v.toddlerDollTestPart1', response[11]);
                cmp.set('v.toddlerDollTestP2', response[12]);
                cmp.set('v.scoldingPersonTestP1', response[13]);
                cmp.set('v.scoldingPersonTestP2', response[14]);
                cmp.set('v.fakeDogInteractionTest', response[15]);
                cmp.set('v.sameSexDogTestPart1', response[16]);
                cmp.set('v.sameSexDogTestPart2', response[17]);
                cmp.set('v.sameSexDogTestPart3', response[18]);
                cmp.set('v.oppositeSexDogTestPart1', response[19]);
                cmp.set('v.oppositeSexDogTestPart2', response[20]);
                cmp.set('v.oppositeSexDogTestPart3', response[21]);
                let tabAttributeMap = {};
                tabAttributeMap.behaveInKennel = 'behaviorInKennelTest';
                tabAttributeMap.bol = 'behaviorOnLeashTest';
                tabAttributeMap.sbt1 = 'socialBehaviorTestPart1';
                tabAttributeMap.sbt2 = 'socialBehaviorTestPart2';
                tabAttributeMap.ptt = 'pleasantTouchTest';
                tabAttributeMap.utt = 'unpleasantTouchTest';
                tabAttributeMap.pt1 = 'playTestPart1';
                tabAttributeMap.pt2 = 'playTestPart2';
                tabAttributeMap.tag = 'tagTest';
                tabAttributeMap.rgt1 = 'resourceGuardingTestPart1';
                tabAttributeMap.rgt2 = 'resourceGuardingTestPart2';
                tabAttributeMap.tdt1 = 'toddlerDollTestPart1';
                tabAttributeMap.tdt2 = 'toddlerDollTestP2';
                tabAttributeMap.spt1 = 'scoldingPersonTestP1';
                tabAttributeMap.spt2 = 'scoldingPersonTestP2';
                tabAttributeMap.fdit = 'fakeDogInteractionTest';
                tabAttributeMap.ssdt1 = 'sameSexDogTestPart1';
                tabAttributeMap.ssdt2 = 'sameSexDogTestPart2';
                tabAttributeMap.ssdt3 = 'sameSexDogTestPart3';
                tabAttributeMap.osdt1 = 'oppositeSexDogTestPart1';
                tabAttributeMap.osdt2 = 'oppositeSexDogTestPart2';
                tabAttributeMap.osdt3 = 'oppositeSexDogTestPart3';
                cmp.set("v.tabsAttributeMap", tabAttributeMap);
                cmp.set("v.spinner", false);
            }
        ).catch(
            function(error) {
                console.log('Error Message',error);
            }
        );
    },
    loadPuppyBehaviorData : function(cmp) {
        var params = {
            evaluation: cmp.get('v.behaviorRecord')
        };
        this.sendPromise(cmp, 'c.getPuppyEvaluation', params)
        .then(
            function(response) {
                cmp.set('v.puppyBehaviorInKennel', response[0]);
                cmp.set('v.puppyBehaviorOnLeash', response[1]);
                cmp.set('v.puppySocialBehaviorPart1', response[2]);
                cmp.set('v.puppySocialBehaviorPart2', response[3]);
                cmp.set('v.puppyPlayTestTugPart1', response[4]);
                cmp.set('v.puppyPlayTestTugPart2', response[5]);
                cmp.set('v.puppyPlayTestTag', response[6]);
                cmp.set('v.puppyRestraint', response[7]);
                cmp.set('v.puppyChildDollPart1', response[8]);
                cmp.set('v.puppyChildDollPart2', response[9]);
                //Gather multi-column data by value category
                let rg1 = response[10];
                let rg1vc1 = new Array();
                for (let i = 0; i < rg1.wrapper1.mNotConcerningOptions.length; i++) {
                    rg1vc1.push({"column1": rg1.wrapper1.mNotConcerningOptions[i], "column2": rg1.wrapper2.mNotConcerningOptions[i], "column3": rg1.wrapper3.mNotConcerningOptions[i], "column4": rg1.wrapper4.mNotConcerningOptions[i]});
                }
                let rg1vc2 = new Array();
                for (let i = 0; i < rg1.wrapper1.mRedFlagOptions.length; i++) {
                    rg1vc2.push({"column1": rg1.wrapper1.mRedFlagOptions[i], "column2": rg1.wrapper2.mRedFlagOptions[i], "column3": rg1.wrapper3.mRedFlagOptions[i], "column4": rg1.wrapper4.mRedFlagOptions[i]});
                }
                let rg1vc3 = new Array();
                for (let i = 0; i < rg1.wrapper1.mAlertOptions.length; i++) {
                    rg1vc3.push({"column1": rg1.wrapper1.mAlertOptions[i], "column2": rg1.wrapper2.mAlertOptions[i], "column3": rg1.wrapper3.mAlertOptions[i], "column4": rg1.wrapper4.mAlertOptions[i]});
                }
                let rg1vc4 = new Array();
                for (let i = 0; i < rg1.wrapper1.mInconclusiveOptions.length; i++) {
                    rg1vc4.push({"column1": rg1.wrapper1.mInconclusiveOptions[i], "column2": rg1.wrapper2.mInconclusiveOptions[i], "column3": rg1.wrapper3.mInconclusiveOptions[i], "column4": rg1.wrapper4.mInconclusiveOptions[i]});
                }
                rg1.VC1 = rg1vc1;
                rg1.VC2 = rg1vc2;
                rg1.VC3 = rg1vc3;
                rg1.VC4 = rg1vc4;
                cmp.set('v.puppyResourceGuardingPart1', rg1);
                //Gather multi-column data by value category
                let rg2 = response[11];
                let rg2vc1 = new Array();
                for (let i = 0; i < rg2.wrapper1.mNotConcerningOptions.length; i++) {
                    rg2vc1.push({"column1": rg2.wrapper1.mNotConcerningOptions[i], "column2": rg2.wrapper2.mNotConcerningOptions[i], "column3": rg2.wrapper3.mNotConcerningOptions[i], "column4": rg2.wrapper4.mNotConcerningOptions[i]});
                }
                let rg2vc2 = new Array();
                for (let i = 0; i < rg2.wrapper1.mRedFlagOptions.length; i++) {
                    rg2vc2.push({"column1": rg2.wrapper1.mRedFlagOptions[i], "column2": rg2.wrapper2.mRedFlagOptions[i], "column3": rg2.wrapper3.mRedFlagOptions[i], "column4": rg2.wrapper4.mRedFlagOptions[i]});
                }
                let rg2vc3 = new Array();
                for (let i = 0; i < rg2.wrapper1.mAlertOptions.length; i++) {
                    rg2vc3.push({"column1": rg2.wrapper1.mAlertOptions[i], "column2": rg2.wrapper2.mAlertOptions[i], "column3": rg2.wrapper3.mAlertOptions[i], "column4": rg2.wrapper4.mAlertOptions[i]});
                }
                let rg2vc4 = new Array();
                for (let i = 0; i < rg2.wrapper1.mInconclusiveOptions.length; i++) {
                    rg2vc4.push({"column1": rg2.wrapper1.mInconclusiveOptions[i], "column2": rg2.wrapper2.mInconclusiveOptions[i], "column3": rg2.wrapper3.mInconclusiveOptions[i], "column4": rg2.wrapper4.mInconclusiveOptions[i]});
                }
                rg2.VC1 = rg2vc1;
                rg2.VC2 = rg2vc2;
                rg2.VC3 = rg2vc3;
                rg2.VC4 = rg2vc4;
                cmp.set('v.puppyResourceGuardingPart2', rg2);
                cmp.set('v.puppyDogInteractionPart1', response[12]);
                cmp.set('v.puppyDogInteractionPart2', response[13]);
                cmp.set('v.puppyDogInteractionPart3', response[14]);
                let tabAttributeMap = {};
                tabAttributeMap.pbik = 'puppyBehaviorInKennel';
                tabAttributeMap.pbol = 'puppyBehaviorOnLeash';
                tabAttributeMap.psb1 = 'puppySocialBehaviorPart1';
                tabAttributeMap.psb2 = 'puppySocialBehaviorPart2';
                tabAttributeMap.ppt1 = 'puppyPlayTestTugPart1';
                tabAttributeMap.ppt2 = 'puppyPlayTestTugPart2';
                tabAttributeMap.ppt = 'puppyPlayTestTag';
                tabAttributeMap.pr = 'puppyRestraint';
                tabAttributeMap.prg1 = 'puppyResourceGuardingPart1';
                tabAttributeMap.prg2 = 'puppyResourceGuardingPart2';
                tabAttributeMap.pcd1 = 'puppyChildDollPart1';
                tabAttributeMap.pcd2 = 'puppyChildDollPart2';
                tabAttributeMap.pdi1 = 'puppyDogInteractionPart1';
                tabAttributeMap.pdi2 = 'puppyDogInteractionPart2';
                tabAttributeMap.pdi3 = 'puppyDogInteractionPart2';
                let tabsAttributeMap = cmp.get("v.tabsAttributeMap");
                if(!tabsAttributeMap){
                    tabsAttributeMap = {};
                }
                let allTabsAttributeMap = Object.assign(tabsAttributeMap, tabAttributeMap);
                cmp.set("v.tabsAttributeMap", allTabsAttributeMap);
                cmp.set("v.spinner", false);
            }
        ).catch(
            function(error) {
                console.log('Error Message',error);
            }
        );
    },

    loadPuppyTabs : function (cmp, event) {
        this.loadPuppyBehaviorData(cmp);
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
        var i_Adult = cmp.get('v.IsAdult');
        var i_DogFight = cmp.get('v.IsDogFighting');
        var i_DogOnly = cmp.get('v.IsDogOnly');
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
        if ((i_Adult && !i_DogFight && !i_DogOnly && x['nextTab'] == 'fdit') || (i_DogOnly && x['nextTab'] == 'behaveInKennel')) {
            x = this.tablist['fdit'];
        }
        cmp.set('v.tabId' , x['nextTab']);
        let tabsAttributeMap = cmp.get("v.tabsAttributeMap");
        let attributeName = tabsAttributeMap[c];
        let tabValueArr = Object.values(this.tablist);
        let skippedAttribute = cmp.get("v."+attributeName)[0];
        if(skippedAttribute.isSkipped === true){
            var index = tabValueArr.findIndex(function(item, i){
                return item.nextTab === c
            });
            tabValueArr.splice(0,index);
            for(let i = 0; i < tabValueArr.length; i++){
                if(tabValueArr[i].nextTab.substring(0, tabValueArr[i].nextTab.length - 1) !== c.substring(0, c.length - 1)){
                    let newTabId = tabValueArr[i].nextTab;
                    if ((i_Adult && !i_DogFight && !i_DogOnly && newTabId == 'fdit') || (i_DogOnly && newTabId == 'behaveInKennel')) {
                        newTabId = this.tablist['fdit'].nextTab;
                    }
                    cmp.set('v.tabId', newTabId);
                    break;
                } else {
                    if(!$A.util.isUndefinedOrNull(cmp.get("v.behaviorEvaluation"))){
                        let bEval = cmp.get("v.behaviorEvaluation").data.item[0];
                        let obj = cmp.get("v."+tabsAttributeMap[tabValueArr[i].nextTab]);
                        obj[0].isSkipped = skippedAttribute.isSkipped;
                        obj[0].skipField.value = bEval[skippedAttribute.skipField.id];
                        console.log(obj[0].skipField);
                        cmp.set("v."+tabsAttributeMap[tabValueArr[i].nextTab], obj);
                        let behEvalTabFooter = cmp.find("behEvalTabFooter");
                        let evalparam = {}; 
                        evalparam.recordId = cmp.get("v.recordId");
                        evalparam.apiName = obj[0].skipField.id;
                        evalparam.values = obj[0].skipField.value;
                        evalparam.methodName = "c.updateEval";
                        if(!Array.isArray(behEvalTabFooter)){
                            behEvalTabFooter.updateEvaluation(evalparam);
                        } else {
                            behEvalTabFooter[behEvalTabFooter.length-1].updateEvaluation(evalparam);
                        }
                    }
                }
            }
            
        }
        
        $A.get('e.force:refreshView').fire();
    } ,
    handlePrevTab: function(cmp, event, button) {
        var c = cmp.get('v.tabId');
        var x = this.tablist[c];
        var i_Adult = cmp.get('v.IsAdult');
        var i_DogFight = cmp.get('v.IsDogFighting');
        var i_DogOnly = cmp.get('v.IsDogOnly');
        cmp.set('v.tabId', x['lastTab']);
        if (i_Adult && !i_DogFight && !i_DogOnly && x['lastTab'] == 'fdit') {
            x = this.tablist['fdit'];
        }
        else if (i_DogOnly && x['lastTab'] == 'fdit') {
            x = this.tablist['behaveInKennel'];
        }
        cmp.set('v.tabId' , x['lastTab']);
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
    },

    handleSkipSubsequentTest: function(cmp, event){
        var params = event.getParam("params");
        console.log('**params: ', JSON.stringify(params));
        if(params.values != null){
            let subTests = this.getSubsequentTests(params.apiName);
            console.log('subTests: ', subTests);

            for (let i = 0; i < subTests.length; i++) {
                let subTest = subTests[i];
                let subTestObj = cmp.get("v."+subTest)[0];

                subTestObj.isSkipped = true;
                cmp.set("v." + subTest, subTestObj);
            }
        }
    },

    getSubsequentTests: function(apiName){
        let subTests = [];
        switch(apiName) {
            case 'Skipped_SB_P1__c':
                subTests = ['socialBehaviorTestPart2'];
                break;
            case 'Skipped_Play_Tug_P1__c':
                subTests = ['playTestPart2'];
                break;
            case 'Skipped_RG_P1__c':
                subTests = ['resourceGuardingTestPart2'];
                break;
            case 'Puppy_Skipped_CD_P1__c':
                subTests = ['toddlerDollTestP2'];                
                break;
            case 'Skipped_SP_P1__c':
                subTests = ['scoldingPersonTestP2'];
                break;
            case 'Skipped_SSD_P1__c':
                subTests = ['sameSexDogTestPart2', 'sameSexDogTestPart3'];
                break;
            case 'Skipped_OSD_P1__c':
                subTests = ['oppositeSexDogTestPart2','oppositeSexDogTestPart3'];
                break;

            default:
        }
        return subTests;
    }
});