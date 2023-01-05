import { LightningElement, track, wire, api} from 'lwc';
import getDogInfo from '@salesforce/apex/TreatmentByDogLWCController.getDogInfo';
import { NavigationMixin } from 'lightning/navigation';

// Import message service features required for subscribing and the message channel
import { subscribe, MessageContext } from 'lightning/messageService';
import DOG_SELECTED_CHANNEL from '@salesforce/messageChannel/DogSelectedChannel__c';

export default class TreatmentByDogReportMain extends NavigationMixin(LightningElement) {
    @track dogList = [];
    appName;

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
        window.console.log('appName: ', message.appName);
        if(message.isSelected){
            this.dogList.push(dogId);
        }
         else {
            const index = this.dogList.indexOf(dogId);
            if (index > -1) {
                this.dogList.splice(index, 1);
            }
        }

        if(message.appName != undefined && message.appName != null){
            this.appName = message.appName;
        }
    }

    exportAsPdf() {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: '/apex/TreatmentsByDogPdf?dogList=' + this.dogList + '&appName=' + this.appName
            }
        }).then(generatedUrl => {
            window.open(generatedUrl);
        });
    }

    // Standard lifecycle hooks used to sub/unsub to message channel
    connectedCallback() {
        this.subscribeToMessageChannel();
    }

}