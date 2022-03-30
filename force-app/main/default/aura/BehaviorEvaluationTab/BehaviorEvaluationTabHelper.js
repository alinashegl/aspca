/**
 * Created by barne on 6/4/2021.
 */

({
    processingProcess: function(cmp, event, currentProcess) {
        let process = {
                    'scriptsLoaded': 'init' ,
                    'init': 'scriptsLoaded' ,
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
    init: function(cmp, event) {
        console.log('Initiated');
    }
});