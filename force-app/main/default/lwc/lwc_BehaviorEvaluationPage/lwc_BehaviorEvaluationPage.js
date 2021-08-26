/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */
import { LightningElement, api } from 'lwc';
import getBehaviorReport from '@salesforce/apex/BehaviorEvaluationPageController.getBehaviorReport';
import getBehaviorInKennel from '@salesforce/apex/BehaviorEvaluationPageController.getBehaviorInKennel';

export default class LwcBehaviorEvaluationPage extends LightningElement {
    @api recordId;
    @api tabs = [];
    @api behInKennel = [];
    @api key = 'key';
    connectedCallback() {
        this.doInit();
    }

    doInit(event) {
        this.processingProcess('init');
    }

    processingProcess(currentProcess) {
        let process = {
            'scriptsLoaded' : 'init' ,
            'init' : 'afterInit',
            'handleClick' : 'handleClick' ,
            'handleSelect' : 'handleSelect'
        };
        if (process[currentProcess] == 'init') {
           this.init();
        }else if(process[currentProcess] == 'afterInit') {
          //this.afterInit();
        }
    }

    init() {
        this.loadBehaviorReport();
    }

    loadBehaviorReport(){
        getBehaviorReport( { key: this.recordId})
            .then( (result) => {

            })
            .catch( (error) => {
                console.log('Error Message',error);
            });
    }

    loadTabs() {
        getBehaviorInKennel( { key: this.recordId })
            .then((result) => {
                this.behInKennel = result;
            })
            .catch((error) => {
                console.log(error);
            });
    }

}