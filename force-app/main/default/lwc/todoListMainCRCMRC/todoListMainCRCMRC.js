import { LightningElement, wire } from 'lwc';
import getToDoListVisibility from '@salesforce/apex/HomeBannerLWCController.getToDoListVisibility';
import { subscribe, MessageContext } from 'lightning/messageService';
import LOCATION_FILTER_CHANNEL from '@salesforce/messageChannel/LocationFilterChannel__c';

export default class TodoListMainCRCMRC extends LightningElement {
    locations;
    isVisible = false; 
    error;
    errorMessage;
    appName = 'CRC Dog Database';
    appURL = 'Treatments_By_Dog_CRC';

    connectedCallback(){
        this.subscribeToMessageChannel();
        getToDoListVisibility()
        .then((result) => {
            if(result){
                this.isVisible = result.mrcTodoList;
            }
            else if(result.error){
                this.error = result.error;
                this.errorMessage = 'Error retrieving animal locations.';
            }
        });
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
        window.console.log('todolistMainCRC, ' + message.locations);
        this.locations = message.locations;
    }
}