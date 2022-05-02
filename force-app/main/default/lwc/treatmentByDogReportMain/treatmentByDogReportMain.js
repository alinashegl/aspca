import { LightningElement, track, wire} from 'lwc';
import getDogInfo from '@salesforce/apex/TreatmentByDogLWCController.getDogInfo';
import { NavigationMixin } from 'lightning/navigation';

// Import message service features required for subscribing and the message channel
import { subscribe, MessageContext } from 'lightning/messageService';
import DOG_SELECTED_CHANNEL from '@salesforce/messageChannel/DogSelectedChannel__c';

export default class TreatmentByDogReportMain extends NavigationMixin(LightningElement) {
    @track dogList = [];
    recordId;

    @wire(getDogInfo, {recordId: '$recordId'})
    response(result){
        if(result.data){
            this.dogList.push(result.data);
        } else if(result.error){
            this.error = result.error;
            window.console.log('error: ', result.error);
            this.showSpinner = false;
        }
    }

    // By using the MessageContext @wire adapter, unsubscribe will be called
    // implicitly during the component descruction lifecycle.
    @wire(MessageContext)
    messageContext;

    // Encapsulate logic for LMS subscribe.
    subscribeToMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            DOG_SELECTED_CHANNEL,
            (message) => this.handleMessage(message)
        );
    }

    // Handler for message received by component
    handleMessage(message) {
        // this.recordId = message.recordId;
        const dogId = message.recordId;
        window.console.log("dogId: ", dogId);
        window.console.log("isSelected: ", message.isSelected);
        if(message.isSelected){
            this.dogList.push(dogId);
        }
         else {
            const index = this.dogList.indexOf(dogId);
            if (index > -1) {
                this.dogList.splice(index, 1);
            }
        }
    }

    exportAsPdf() {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: '/apex/TreatmentsByDogPdf?dogList=' + this.dogList
            }
        }).then(generatedUrl => {
            window.open(generatedUrl);
        });
    }

    // exportAsPdf() {
    //     this[NavigationMixin.GenerateUrl]({
    //         type: 'standard__webPage',
    //         attributes: {
    //             url: '/apex/TreatmentsByDogPdf'
    //         },
    //         state: {
    //             c__dogList: this.dogList
    //         }
    //     }).then(generatedUrl => {
    //         window.open(generatedUrl);
    //     });
    // }

    // handleMessage(message) {
    //     // this.recordId = message.recordId;
    //     const dogId = message.recordId;
    //     window.console.log("dogId: ", dogId);
    //     window.console.log("isSelected: ", message.isSelected);
    //     if(message.isSelected){
    //         this.recordId = dogId;
    //     }
    //      else {
    //         // const index = this.dogList.Id.indexOf(recordId);
    //         const index = this.dogList.findIndex(dog => dog.Id === dogId);
    //         window.console.log('index: ', index);
    //         if (index > -1) {
    //             this.dogList.splice(index, 1);
    //         }
    //     }
    // }

    // Standard lifecycle hooks used to sub/unsub to message channel
    connectedCallback() {
        this.subscribeToMessageChannel();
    }

}