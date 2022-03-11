import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getActiveTreatmentPlan from '@salesforce/apex/createTreatmentSessionController.getActiveTreatmentPlan';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// import SystemModstamp from '@salesforce/schema/APXT_BPM__Conductor__c.SystemModstamp';

export default class CreateTreatmentSession extends NavigationMixin(LightningElement) {
    @api animalId;
    @api smallForm;

    planId;
    preferredMotivators;
    showSpinner = false;
    customLookupContactId;
    requiredContact = true;
    noPlan = true;

    get hasPlan(){
        return  this.planId != undefined && this.planId != null;
    }

    // @wire(getActiveTreatmentPlan, {animalId: '$animalId'})
    // response(result){
    //     window.console.log('result: ', JSON.stringify(result));
    //     this.planId = result.data;
    // }

    connectedCallback(){
        getActiveTreatmentPlan({animalId: this.animalId})
        .then((result) => {
            window.console.log('result: ', JSON.stringify(result));
            if(result){
                this.planId = result.Id;
                this.preferredMotivators = result.Preferred_Motivators__c;
                this.noPlan = false;
            } else {
                this.noPlan = true;
            }
        });
    }

    customLookupEvent(event){
        this.customLookupContactId = event.detail.data.recordId;
    }

    handleCustomLookupExpandSearch(event){
        let data = event.detail.data;
        let dataId = data.elementId;
        // this.template.querySelector('[data-id="' + dataId + '"]').className =
        //     data.expandField ? 'slds-col slds-size_1-of-1' : data.initialColSize;
    }

    handleSubmit(event){
        event.preventDefault();
        this.showSpinner = true;
        const fields = event.detail.fields;
        if(this.customLookupContactId != undefined){
            fields.Session_Contact__c = this.customLookupContactId;
        }
        fields.Animal__c = this.animalId;
        fields.Treatment_Plan__c = this.planId;
        
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(event) {
        let sessionId = event.detail.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: sessionId,
                actionName: 'view',
            }
        });
         // Prepare a toast UI message
         this.dispatchEvent(
            new ShowToastEvent({
                title: "",
                message: "Treatment Session was created.",
                variant: "success"
            })
        );
    }
    
    handleCancel(){
        const selectedEvent = new CustomEvent('cancel', {});
        this.dispatchEvent(selectedEvent);
    }
    
    
    get customLookupTreatmentFields(){
        return ['Name'];
    }

    get customLookupContactFields(){
        return ['Name','Email','Phone'];
    }

    get customLookupContactDisplayFields(){
        return 'Name, Email, Phone';
    }


}