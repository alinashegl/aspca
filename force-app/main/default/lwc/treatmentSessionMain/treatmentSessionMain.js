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
    loading = false;
    activeProtocols = [];
    activeSession = false;
    allColumns = FORM_FACTOR == 'Large' ? true : false;
    wireResponse;

    @wire(getActiveProtocols, {sessionId: '$recordId'})
    response(result){
        this.wireResponse = result;
        if(result.data){
            this.activeProtocols = result.data;
        }
    }

    handleStartSession(){
        this.activeSession = !this.activeSession;
        if(!this.activeSession){
            return refreshApex(this.wireResponse);
        }
    }

    handleModifySession(){

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

    get startSessionLabel(){
        return this.activeSession ? 'Exit Session' : 'Start Session';
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

    recordPageUrl
}