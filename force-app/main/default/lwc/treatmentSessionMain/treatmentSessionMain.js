import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import getActiveProtocols from '@salesforce/apex/TreatmentSessionLWCController.getActiveProtocols';
import hasRemoveFromPlanPermission from '@salesforce/customPermission/Remove_Protocol_From_Plan';
import FORM_FACTOR from '@salesforce/client/formFactor'
import { refreshApex } from '@salesforce/apex';

const columns = [
    {   label: "Name",
        type: "button",
        typeAttributes: { label: { fieldName: "Protocol_Name__c" }, name: "gotoProtocol", variant: "base" }
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

const limitedColumns = [
    {   label: "Name",
        type: "button",
        typeAttributes: { label: { fieldName: "Protocol_Name__c" }, name: "gotoProtocol", variant: "base" }
    },
    { label: 'Overall Score', fieldName: 'Overall_Score__c'},
    { label: 'Needs Review', fieldName: 'Needs_Review__c', type: 'boolean'},
    { label: 'Skip Protocol', fieldName: 'IsSkipped__c', type: 'boolean'}
];

export default class TreatmentSessionMain extends NavigationMixin(LightningElement) {
    @api recordId;

    columns = columns;
    activeProtocols = [];
    activeSession = false;
    allColumns = FORM_FACTOR == 'Large' ? true : false;
    wireResponse;
    showModifySession = false;
    refresh = false;

    @wire(getActiveProtocols, {sessionId: '$recordId', refresh: '$refresh'})
    response(result){
        this.wireResponse = result;
        this.activeProtocols = [];
        if(result.data){
            this.activeProtocols = result.data;
            window.console.log('getActiveProtocols.length: ', result.data.length);
        }
    }

    handleRefresh(){
        getActiveProtocols({sessionId: this.recordId})
        .then((result) => {
            this.activeProtocols = [];
            window.console.log('handleRefresh.length: ', result.length);
            this.activeProtocols = result;
        });
    }

    handleRefreshEvent(){
        window.console.log('inhandleRefreshEvent');
        refreshApex(this.wireResponse);
    }

    handleStartSession(){
        window.console.log('handleStartSession');
        this.activeSession = !this.activeSession;
        this.showModifySession = false;
        refreshApex(this.wireResponse);
    }

    handleModifySession(){
        window.console.log('handleModifySession');
        this.showModifySession = !this.showModifySession;
        refreshApex(this.wireResponse);
    }

    handleToggleFields(){
        this.allColumns = !this.allColumns;
    }

    handleRowAction(event) {
        if (event.detail.action.name === "gotoProtocol") {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.detail.row.Id,
                    objectApiName: 'Session_Protocol__c',
                    actionName: 'view'
                }
            });
        }
    }

    get showTogglefields(){
        return !this.activeSession && !this.showModifySession ?  true : false;
    }

    get startSessionLabel(){
        return this.activeSession ? 
        (this.showModifySession ? 'Protocol List' : 'Exit Session' )
        : 'Start Session';
    }

    get canRemoveProtocol() {
        return hasRemoveFromPlanPermission;
    }

    get tableClass(){
        return this.allColumns ? "slds-max-medium-table_stacked" : '' ;
    }

    get tableColumns(){
        return this.allColumns ? columns : limitedColumns;
    }

    get modifySessionLabel(){
        return this.showModifySession ? 
        (this.activeSession ? 'Return to Session' :'Protocol List')
        : 'Modify Session';
    }
}