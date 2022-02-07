import { LightningElement, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import recreateTasks from '@salesforce/apex/AnimalScheduleQuickActionLWCController.recreateTasks';
import getDateRange from '@salesforce/apex/AnimalScheduleQuickActionLWCController.getDateRange';

export default class AnimalScheduleQuickAction extends LightningElement {
    @api recordId;
    showSpinner = false;
    error = null;
    showOptions = false;
    thisWeek;
    nextWeek;
    thisWeekSelected = false;
    nextWeekSelected = false;

    connectedCallback(){
        if(this.thisWeek == undefined || this.nextWeek == undefined){
            this.showSpinner = true;
            getDateRange({})
            .then((result) =>{
                this.thisWeek = result.thisWeek;
                this.nextWeek = result.nextWeek;
                this.showOptions = true;
            })
            .catch(error => {
                this.error = error;
            })
            .finally(() =>{
                this.showSpinner = false;
            });
        }
    }

    handleContinueClick(){
        this.error = null;
        this.showSpinner = true;
        recreateTasks({animalId : this.recordId, startDate: this.startDate, endDate: this.endDate})
        .then((result) =>{
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
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    thisWeekChanged(event){
        this.thisWeekSelected = event.target.checked;
    }

    nextWeekChanged(event){
        this.nextWeekSelected = event.target.checked;
    }

    get thisWeekToggleLabel(){
        return this.thisWeek != undefined && this.thisWeek.isMonday ? 'This Week: today only' : 'This Week: Today through ' + this.thisWeek.endDay + ', ' + this.thisWeek.endDateFormatted;
    }

    get nextWeekToggleLabel(){
        return this.nextWeek != undefined ? 'Next Week: ' + this.nextWeek.startDay + ', ' + this.nextWeek.startDateFormatted + ' through ' + this.nextWeek.endDay + ', ' + this.nextWeek.endDateFormatted : null;
    }

    get startDate(){
        let startDate;
        if(this.thisWeekSelected && this.thisWeek.startDate != null){
            startDate = this.thisWeek.startDate;
        } 
        else if(this.nextWeekSelected && this.nextWeek.startDate != null){
            startDate = this.nextWeek.startDate;
        }
        
        return startDate;
    }

    get endDate(){
        let endDate;
        if(this.nextWeekSelected && this.nextWeek.endDate != null){
            endDate = this.nextWeek.endDate;
        }

        else if(this.thisWeekSelected && this.thisWeek.endDate != null){
            endDate = this.thisWeek.endDate;
        }
        
        return endDate;
    }

    get disableContinue(){
        return this.startDate == undefined || this.endDate == undefined;
    }
}