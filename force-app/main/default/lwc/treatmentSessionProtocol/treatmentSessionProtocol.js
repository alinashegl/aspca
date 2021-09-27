import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import FEAR_BEST_FIELD from '@salesforce/schema/Session_Protocol__c.Fear_Best__c';
import FEAR_WORST_FIELD from '@salesforce/schema/Session_Protocol__c.Fear_Worst__c';
import AGGRESIVE_WORST_FIELD from '@salesforce/schema/Session_Protocol__c.Aggressive_Worst__c';
import AROUSAL_BEST_FIELD from '@salesforce/schema/Session_Protocol__c.Arousal_Best__c';
import AROUSAL_WORST_FIELD from '@salesforce/schema/Session_Protocol__c.Arousal_Worst__c';
import SOCIAL_BEST_FIELD from '@salesforce/schema/Session_Protocol__c.Social_Best__c';
import OVERALL_SCORE_FIELD from '@salesforce/schema/Session_Protocol__c.Overall_Score__c';
import getActiveProtocolsAndFields from '@salesforce/apex/TreatmentSessionLWCController.getActiveProtocolsAndFields';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';

export default class TreatmentSessionProtocol extends LightningElement {
    @api recordId;
    @api sessionId;
    @api protocolName;

    @api showPicklist = false;

    // picklistFields = picklistFields;

    protocolStatus = 'NotStarted';
    toggleForm = false;

    inputval;

    handleClick(){
        this.toggleForm = !this.toggleForm;
        window.console.log(this.protocolName, 'has been clicked');
    }

    handleChange(event) {
        this.inputVal = event.target.value;
        window.console.log('inputVal = ', this.inputVal);
      }

    // @wire(getPicklistValues, {
    //     recordTypeId: '',
    //     fieldApiName: FEAR_BEST_FIELD
    // })
    fearBestField;

    // @wire(getPicklistValues, {
    //     recordTypeId: '',
    //     fieldApiName: FEAR_WORST_FIELD
    // })
    fearWorstField;

    connectedCallback(){
        this.loading = true;
        getActiveProtocolsAndFields({'sessionId': this.sessionId})
        .then(result => {
            if (result) {
                this.activeProtocols = result.protocols;
                this.fearBestField = result.fearBestField;
                this.fearWorstField = result.fearWorstField;
            }

            window.console.log('activeProtocols: ', JSON.stringify(this.activeProtocols));
            window.console.log('fearBestField: ', this.fearBestField);
            window.console.log('fearWorstField: ', this.fearWorstField);
        })
        .catch(error => {
            // this.showLogs('connectedCallback: -------error-------------'+error);
            window.console.log('error: ', error);
        })
        .finally(() => {
            this.loading = false;
        });
    }

    handleRadioChange(event) {
        const selectedOption = event.detail.value;
        window.console.log('selectedOption: ', selectedOption);
    }
}