import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import getActiveProtocols from '@salesforce/apex/TreatmentSessionLWCController.getActiveProtocolsForSession';
import hasRemoveFromPlanPermission from '@salesforce/customPermission/Remove_Protocol_From_Plan';
import FORM_FACTOR from '@salesforce/client/formFactor'
import { refreshApex } from '@salesforce/apex';

export default class TreatmentSessionMain extends NavigationMixin(LightningElement) {
    @api recordId;

    activeProtocols = [];
    activeSession = false;
    allColumns = FORM_FACTOR == 'Large' ? true : false;
    isLargeDisplay = FORM_FACTOR == 'Large' ? true : false;
    wireResponse;
    showModifySession = false;
    refresh = false;
    refreshProtocolLists = false;
    sessionListRefresh = false;

    requiredProtocols = [];
    @wire(getActiveProtocols, {sessionId: '$recordId', refresh: '$refresh'})
    response(result){
        this.wireResponse = result;
        this.activeProtocols = [];
        if(result.data){
            this.requiredProtocols = result.data.requiredProtocols;
            this.setIconAndAltText(result.data.sessionProtocolInfos);
        }
    }

    setIconAndAltText(data){
        this.activeProtocols = JSON.parse(JSON.stringify(data));
        this.activeProtocols.forEach(protocol => {
            let urlIcon = protocol.status.replace('<img src="', '');
            protocol.urlIcon = urlIcon;
        })
    }

    handleStartSession(){
        window.console.log('handleStartSession');
        this.activeSession = !this.activeSession;
        this.showModifySession = false;
        refreshApex(this.wireResponse);
        this.refreshProtocolLists = this.activeSession ? !this.refreshProtocolLists : this.refreshProtocolLists;
    }

    handleModifySession(){
        window.console.log('handleModifySession');
        this.showModifySession = !this.showModifySession;
        refreshApex(this.wireResponse);
        this.sessionListRefresh = (this.showModifySession) ? !this.sessionListRefresh : this.sessionListRefresh;
    }

    handleToggleFields(){
        this.allColumns = !this.allColumns;
    }

    handleNavigateToRecord(event) {
        window.console.log("handleNavigateToRecord: ", event.target.dataset.id);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.dataset.id,
                objectApiName: 'Session_Protocol__c',
                actionName: 'view'
            }
        });
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

    get modifySessionLabel(){
        return this.showModifySession ? 
        (this.activeSession ? 'Return to Session' :'Protocol List')
        : 'Modify Session';
    }
}