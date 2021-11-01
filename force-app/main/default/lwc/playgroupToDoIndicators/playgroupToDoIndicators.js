import { api, LightningElement, wire } from 'lwc';
import getMedicalIndicators from '@salesforce/apex/PlaygroupToDoListController.getMedicalIndicators';

export default class PlaygroupToDoIndicators extends LightningElement {
    @api
    animalId;
    @api
    handlerCode;

    @wire(getMedicalIndicators, { animalId: '$animalId'})
    medicalIndicators;

    get noData() {
        return this.medicalIndicators.data != undefined && this.medicalIndicators.data.length === 0 && this.handlerCode !== '';
    }

    get handlerVariant() {
        return this.handlerCode === 'Yellow' ? 'warning' : this.handlerCode === 'Red (designated)' ? 'error' : '';
    }
}