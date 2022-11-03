import { LightningElement, api, wire, track } from 'lwc';
import getAnimalLocations from '@salesforce/apex/LocationFilterController.getAnimalLocations';

import { publish, MessageContext } from 'lightning/messageService';
import LOCATION_FILTER_CHANNEL from '@salesforce/messageChannel/LocationFilterChannel__c';

export default class LocationFilter extends LightningElement {
    @api applicationType
    @track animalLocations = [];
    hasLocations = true;
    locationString;
    error;
    errorMessage;

    @wire(MessageContext)
    messageContext;

    @wire(getAnimalLocations, {applicationType : '$applicationType'})
    response(result){
        if(result.data){
            result.data.forEach(element => {
                if(element['configFound'] != null){
                    this.hasLocations = element['configFound'];
                } else{
                    let tempLoc = {...element};
                    tempLoc.variant = 'brand';
                    tempLoc.selected = true;
                    this.animalLocations.push(tempLoc);
                }
            });
            this.prepLocationsString();
        }
        else if(result.error){
            this.error = result.error;
            this.errorMessage = 'Error retrieving animal locations.';
        }
    }

    handleOnclick(event){
        window.console.log('button: ', event.target.dataset.type);
        const buttonType = event.target.dataset.type;
        this.animalLocations.forEach(loc => {
            if(loc.label == buttonType){
                loc.selected = !loc.selected;
                loc.variant = loc.variant == 'brand' ? 'brand-outlne' : 'brand';
            }
        });
        this.prepLocationsString();
    }

    prepLocationsString(){
        let locations =  this.animalLocations.map(a => a.selected ? a.value : null).filter(function (el) {
            return el != null;
        });
        if(!this.hasLocations && locations == ''){
            locations = 'All';
        }
        this.locationString = locations.toString();
        const payload = { locations: this.locationString};

        window.console.log('payload: ', payload);
        publish(this.messageContext, LOCATION_FILTER_CHANNEL, payload);
    }
}

/*
to subscirbe LWC:

    // Import message service features required for subscribing to the message channel
    import { subscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
    import LOCATIONS_FILTER_UPDATED_CHANNEL from '@salesforce/messageChannel/LocationFilterChannel__c';

    // By using the MessageContext @wire adapter, unsubscribe will be called
    // implicitly during the component descruction lifecycle.
    @wire(MessageContext)
    messageContext;
    subscription = null;

    // Encapsulate logic for LMS subscribe.
    subscribeToMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            LOCATIONS_FILTER_UPDATED_CHANNEL,
            (message) => this.handleMessage(message),
            { scope: APPLICATION_SCOPE }
        );
    }

    handleMessage(message){
        window.console.log('message: ', message);
        this.locations = message.locations;
    }
*/

/*
to subscribe with Aura:

    <lightning:messageChannel 
        type="LocationFilterChannel__c"
        onMessage="{!c.handleLocationFilterMessage}" 
        scope="APPLICATION"
    />

    handleLocationFilterMessage : function(cmp, message){
        cmp.set("v.locations",message.getParam('locations'));
    }
*/
