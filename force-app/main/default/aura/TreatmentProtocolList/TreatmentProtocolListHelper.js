/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
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
        var data = cmp.get('v.data');
        console.log('Selections', data);
    }
});