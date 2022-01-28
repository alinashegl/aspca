import { LightningElement, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import recreateTasks from '@salesforce/apex/AnimalScheduleQuickActionLWCController.recreateTasks';

export default class AnimalScheduleQuickAction extends LightningElement {
    @api recordId;
    showSpinner = false;
    error = null;

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