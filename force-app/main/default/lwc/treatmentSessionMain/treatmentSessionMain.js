import { LightningElement, api } from 'lwc';
import getActiveProtocols from '@salesforce/apex/TreatmentSessionLWCController.getActiveProtocols';

const columns = [
    { label: 'Name', fieldName: 'Protocol_Name__c' },
    { label: 'Fear - Best', fieldName: 'Fear_Best__c' },
    { label: 'Fear - Worst', fieldName: 'Fear_Worst__c' },
    { label: 'Agressive - Worst', fieldName: 'Aggressive_Worst__c' },
    { label: 'Arousal - Best', fieldName: 'Arousal_Best__c' },
    { label: 'Arousal - Worst', fieldName: 'Arousal_Worst__c' },
    { label: 'Social - Best', fieldName: 'Social_Best__c' },
    { label: 'Overall Score', fieldName: 'Overall_Score__c'},
    { label: 'Needs Review', fieldName: 'Needs_Review__c', type: 'boolean'},
    { label: 'Skip Protocol', fieldName: 'IsSkipped__c', type: 'boolean'}
];

export default class TreatmentSessionMain extends LightningElement {
    @api recordId;

    columns = columns;
    loading = false;
    activeProtocols = [];
    activeSession = false;

    showPicklist = true;

    connectedCallback(){
        this.loading = true;
        getActiveProtocols({'sessionId' : this.recordId})
        .then(result => {
            if (result) {
                window.console.log('active Protocols: ', JSON.stringify(result));
                this.activeProtocols = result;
            }
        })
        .catch(error => {
            window.console.log('connectedCallback: -------error-------------'+error);
            window.console.log(error);
        })
        .finally(() => {
            this.loading = false;
        });
    }

    handleClick(){
        this.activeSession = !this.activeSession;
    }
}