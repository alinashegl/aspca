import { LightningElement, api, wire } from 'lwc';

export default class ObservationMain extends LightningElement {
    @api recordId;
    wireResponse;
    happyTails = [];
    observations = [];
    concerns = [];

    // @wire(getObservationLists, {recordId: '$recordId'})
    // response(result){
    //     this.wireResponse = result;
    //     // this.happyTails = [];
    //     // this.observations = [];
    //     // this.concerns = [];
    //     if(result.data){
    //         this.happyTails = result.data.happyTails;
    //         this.observations = result.data.observations;
    //         this.concerns = result.data.concerns;

    //         window.console.log('observations: ', JSON.stringify(this.wireResponse));
    //     }
    // }
}