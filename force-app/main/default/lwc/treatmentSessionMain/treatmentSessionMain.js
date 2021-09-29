import { LightningElement, api } from 'lwc';
import getActiveProtocols from '@salesforce/apex/TreatmentSessionLWCController.getActiveProtocols';
import hasRemoveFromPlanPermission from '@salesforce/customPermission/Remove_Protocol_From_Plan';

const columns = [
    { label: 'Name', fieldName: 'protoUrl', type:'url',
        typeAttributes: {
            label: { 
                fieldName: 'Protocol_Name__c' 
            },
            target : '_blank'
        }
    },
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
                let baseUrl = 'https://'+location.host+'/';
                result.forEach(protoRec => {
                    protoRec.protoUrl = baseUrl+protoRec.Id;
                });
            }
            this.activeProtocols = result;
        })
        .catch(error => {
            window.console.log('connectedCallback: -------error-------------'+error);
            window.console.log(error);
        })
        .finally(() => {
            // window.console.log('activeProtocols: ', JSON.stringify(this.activeProtocols));
            this.loading = false;
        });
    }

    handleStartSession(){
        this.activeSession = !this.activeSession;
    }

    handleModifySession(){

    }

    get startSessionLabel(){
        return this.activeSession ? 'Exit Session' : 'Start Session';
    }

    get canRemoveProtocol() {
        return hasRemoveFromPlanPermission;
    }
}