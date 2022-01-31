import { LightningElement, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import recreateTasks from '@salesforce/apex/AnimalScheduleQuickActionLWCController.recreateTasks';
import getDateRange from '@salesforce/apex/AnimalScheduleQuickActionLWCController.getDateRange';

export default class AnimalScheduleQuickAction extends LightningElement {
    @api recordId;
    showSpinner = false;
    error = null;
    startDate;
    endDate;
    startDay;
    endDay;

    connectedCallback(){
        if(this.startDate == undefined || this.endDate == undefined){
            this.showSpinner = true;
            getDateRange({})
            .then((result) =>{
                window.console.log('result: ', result);
                this.startDate = result.startDateFormatted;
                this.endDate = result.endDateFormatted;
                this.startDay = result.startDateDay;
                this.endDay = result.endDateDay;
            })
            .catch(error => {
                this.error = error;
            })
            .finally(() =>{
                this.showSpinner = false;
            });
        }
    }

    handleYesClick(){
        window.console.log('yes: ', this.recordId);
        this.error = null;
        this.showSpinner = true;
        recreateTasks({animalId : this.recordId})
        .then((result) =>{
            window.console.log('result: ', result);
            if(result == 'success'){
                this.dispatchEvent(new CloseActionScreenEvent());
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Tasks have been created',
                        variant: 'success'
                    })
                );
            }
        })
        .catch(error => {
            this.error = error;
        })
        .finally(() =>{
            this.showSpinner = false;
        });
    }

    handleCancelClick(){
        window.console.log('cancel');
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}