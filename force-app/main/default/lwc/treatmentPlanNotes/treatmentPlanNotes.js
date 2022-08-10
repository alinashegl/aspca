import { LightningElement, api, wire } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import TREATMENT_PLAN_FIELD from '@salesforce/schema/Treatment_Session__c.Treatment_Plan__c';
import PLAN_NOTES_FIELD from '@salesforce/schema/Treatment_Plan__c.Plan_Notes__c';

export default class TreatmentPlanNotes extends LightningElement {
    @api recordId;
    treatmentPlanId;
    planNotes;
    showSpinner = false;
    planNotesApiName = PLAN_NOTES_FIELD.fieldApiName;

    error;
    errorMessage;

    @wire(getRecord, { recordId: '$recordId', fields: [TREATMENT_PLAN_FIELD] })
    wiredTreatmentSessionRecord({ error, data }) {
        if (data) {
            this.treatmentPlanId = data.fields.Treatment_Plan__c.value;
        }
    }

    @wire(getRecord, { recordId: '$treatmentPlanId', fields: [PLAN_NOTES_FIELD] })
    wiredTreatmentPlanRecord({ error, data }) {
        if (data) {
            this.planNotes = data.fields.Plan_Notes__c.value;
        }
    }

    handleInputBlur(event){
        this.showSpinner = true;

        const fields = {};
        fields[event.target.dataset.field] = event.target.value;
        fields['Id'] = this.treatmentPlanId;

        const recordInput = { fields };

        updateRecord(recordInput)
        .then(() => {
            window.console.log('success');
        })
        .catch(error => {
            window.console.log('error: ', error.body.message);
            this.errorMessage = 'Error updating Plan Notes';
            this.error = error;
        })
        .finally(() => {
            this.showSpinner = false;
        });
    }

}