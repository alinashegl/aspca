import { LightningElement, wire } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import LOCATION_FILTER_CHANNEL from '@salesforce/messageChannel/LocationFilterChannel__c';


export default class TodoListMainARCCARE extends LightningElement {    locations;
    error;
    errorMessage;
    appName = 'ARC/CARE Dog Database';
    appURL = 'Treatments_By_Dog_ARC_CARE';

    connectedCallback(){
        this.subscribeToMessageChannel();
    }

    // By using the MessageContext @wire adapter, unsubscribe will be called
    // implicitly during the component descruction lifecycle.
    @wire(MessageContext)
    messageContext;
    subscription = null;

    // Encapsulate logic for LMS subscribe.
    subscribeToMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            LOCATION_FILTER_CHANNEL,
            (message) => this.handleMessage(message)
        );
    }

    handleMessage(message){
        window.console.log('todolistMainARC, ' + message.locations);
        this.locations = message.locations;
    }
}