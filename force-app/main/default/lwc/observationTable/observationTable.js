import { LightningElement, api, wire } from 'lwc';
import getObservations from '@salesforce/apex/ObservationController.getObservations';


export default class ObservationTable extends LightningElement {
    @api recordId;
    @api observationType;
    count = 5;
    observationList = [];
    wireResponse;

    @wire(getObservations, {recordId: '$recordId', observationType: '$observationType', count: '$count'})
    response(result){
        this.wireResponse = result;
        this.observationList = result.data;
    }

    handleNew(){
        window.console.log('new button clicked');
    }

    toggleViewAll(){
        this.count = this.count == 5 ? null : 5;
    }

    get observatinLenght(){
        return this.observationList.data.length;
    }

    get titleLabel(){
        return this.observationList ? this.observationType +  's (' +  this.observationList.length + ')' : this.observationType +  's (0)';
    }

    get footerButtonLabel(){
        return this.count == 5? 'View All' : 'Collapse View';
    }

    get newButtonLabel(){
        return 'New ' + this.observationType;
    }
}