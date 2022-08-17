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

    @wire(getLastTreatments, { treatmentPlanId: '$treatmentPlanId', protocolId: '$protocolId', recordCount: '$recordCount'})
    lastTreatments;

    handleToggle() {
        window.console.log('lastTreatments: ', JSON.stringify(this.lastTreatments));
        this.allFields = !this.allFields;
    }

    get hasData() {
        return this.lastTreatments.data != undefined && this.lastTreatments.data.length > 0;
    }
}