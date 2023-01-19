import { LightningElement, api, wire, track } from 'lwc';
import getAnimalLocations from '@salesforce/apex/LocationFilterController.getAnimalLocations';

import { publish, MessageContext } from 'lightning/messageService';
import LOCATION_FILTER_CHANNEL from '@salesforce/messageChannel/LocationFilterChannel__c';
import SystemModstamp from '@salesforce/schema/ANH__AutoNumberConfigurationSetting__c.SystemModstamp';

export default class LocationFilter extends LightningElement {
    @api applicationType
    @api appName
    @track animalLocations = [];
    hasLocations = true;

    animalLocationsWireResponse;
    locationString;
    error;
    errorMessage;


    @wire(MessageContext)
    messageContext;

    connectedCallback(){
        window.console.log("locationFilter connectedCallback()");
        getAnimalLocations({applicationType : this.applicationType, currentApp : this.appName})
        .then((result) => {
            if(result){
                this.animalLocationsWireResponse = result;
                if(result.locations != null){
                    if(result.locations.length > 1){
                        result.locations.forEach(element => {
                            let tempLoc = {...element};
                            tempLoc.variant = 'brand';
                            tempLoc.selected = true;
                            this.animalLocations.push(tempLoc);
                        });
                        this.prepLocationsString();
                    } else{
                        this.publishLocationString(result.locations);
                    }
                } else {
                    this.publishLocationString(null);
                }                
            }
            else if(result.error){
                this.error = result.error;
                this.errorMessage = 'Error retrieving animal locations.';
            }
        });
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
        this.publishLocationString(locations);
    }

    publishLocationString(locations){
        let locationsMap = {...this.animalLocationsWireResponse};
        locationsMap.locations = locations != null ? locations.toString() : null;
        const tempLocationString = JSON.stringify(locationsMap);

        this.locationString = tempLocationString;
        window.console.log('this.locationString: ', this.locationString);        

        const payload = { locations: this.locationString};

        window.console.log('payload: ', payload);
        if(this.hasAccess){
            publish(this.messageContext, LOCATION_FILTER_CHANNEL, payload);
        }
    }

    get hasAccess(){
        return this.animalLocationsWireResponse != undefined && (
            this.animalLocationsWireResponse.showAllLocations || this.animalLocationsWireResponse.hasConfigWithLocations);
    }

    get showLocations(){
        return this.animalLocations != undefined && this.animalLocations.length > 1;
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