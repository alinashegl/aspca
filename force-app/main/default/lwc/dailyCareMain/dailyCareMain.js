import { LightningElement, wire } from 'lwc';
import getDailyCare from '@salesforce/apex/DailyCareLWCController.getDailyCare';

export default class DailyCareMain extends LightningElement {

    careDate;
    dailyCareId;

    @wire(getDailyCare, {careDate: '$careDate'})
    response(result) {
        if(result.data){
            this.dailyCareId = result.data;
        }
    }

    connectedCallback(){
        if(this.careDate == undefined){
            let today = new Date();
            window.console.log('today: ', today);
            window.console.log('Year: ', today.getFullYear());
            window.console.log('Month: ', today.getMonth());
            window.console.log('Day: ', today.getDay());

            window.console.log('iso: ', today.toISOString().substring(0, 10));
            this.careDate = today.toISOString().substring(0, 10);
        }
    }

    dateChange(event){
        window.console.log('date selected = ', event.target.value);
        this.careDate = event.target.value;
    }

    get hasDate(){
        return this.careDate != undefined && this.careDate != null;
    }

    get date(){
        return this.hasDate ? this.careDate : null;
    }
}