import { LightningElement, api, wire } from 'lwc';
import getUserLocation from '@salesforce/apex/ObservationController.getUserLocation';

export default class ObservationMain extends LightningElement {
    @api recordId;
    wireResponse;
    happyTails = [];
    observations = [];
    concerns = [];

    isArcCare = false;

    connectedCallback(){
        if(this.userLocation == undefined || this.userLocation == null){
            getUserLocation()
            .then((result) => {
                this.isArcCare = result;
            });
        }
    }
}