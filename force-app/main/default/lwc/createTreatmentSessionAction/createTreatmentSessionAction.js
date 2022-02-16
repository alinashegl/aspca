import { LightningElement, api } from 'lwc';

export default class CreateTreatmentSessionAction extends LightningElement {
    @api animalId;
    @api planId;
    @api smallForm;

    get customLookupTreatmentFields(){
        return ['Name'];
    }
}