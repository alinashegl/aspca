import { LightningElement, track, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import TREATMENT_PLAN_ID_FIELD from '@salesforce/schema/Session_Protocol__c.TreatmentSessionId__r.Treatment_Plan__c';
import PROTOCOL_ID_FIELD from '@salesforce/schema/Session_Protocol__c.ProtocolId__c';
import getLastTreatments from '@salesforce/apex/LastTreatmentsController.getLastTreatments';
import SystemModstamp from '@salesforce/schema/ANH__AutoNumberConfigurationSetting__c.SystemModstamp';

const fields = [TREATMENT_PLAN_ID_FIELD, PROTOCOL_ID_FIELD];

export default class Lwc_lastTreatments extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api recordCount;
    allFields = false;

    get protocolLabel() {
        return `Last ${this.recordCount} Treatment Protocols`;
    }

    @wire(getRecord, { recordId: '$recordId', fields })
    sessionProtocol;

    get treatmentPlanId() {
        return getFieldValue(this.sessionProtocol.data, TREATMENT_PLAN_ID_FIELD);
    }

    get protocolId() {
        return getFieldValue(this.sessionProtocol.data, PROTOCOL_ID_FIELD);
    }

    @track lastTreatments = [];
    @wire(getLastTreatments, { treatmentPlanId: '$treatmentPlanId', protocolId: '$protocolId', recordCount: '$recordCount'})
    response(result){
        if(result.data){
            window.console.log('result: ', JSON.stringify(result));
            console.table(result.data[0]);
            this.lastTreatments = result.data;
        }
    }

    // connectedCallback(){
    //     window.console.log('**in connectedCallback');
    //     window.console.log('**treatmentPlanId: ', this.treatmentPlanId);
    //     window.console.log('**protocolId: ', this.protocolId);
    //     window.console.log('**recordCount: ', this.recordCount);
    //     this.recordCount = 5;
    //     if(this.treatmentPlanId != null && this.protocolId != null && this.recordCount != null){
    //         getLastTreatments({
    //             treatmentPlanId: this.treatmentPlanId,
    //             protocolId: this.protocolId,
    //             recordCount: this.recordCount
    //         })
    //         .then((result) =>{
    //             window.console.log('result: ', JSON.stringify(result));
    //             this.lastTreatments = result;
    //         })
    //         .catch(error => {
    //             // this.error = error;
    //         })
    //         .finally(() =>{
    //             // this.showSpinner = false;
    //         });
    //     }
    // }
        

    handleToggle() {
        window.console.log('lastTreatments: ', JSON.stringify(this.lastTreatments));
        this.allFields = !this.allFields;
    }

    //This can likely go away when moving to the detail page layout since it should always have a record by virtue of being on that detail page
    get hasData() {
        return this.lastTreatments.data != undefined && this.lastTreatments.data.length > 0;
    }
}