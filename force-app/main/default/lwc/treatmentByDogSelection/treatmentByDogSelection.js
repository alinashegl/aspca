import { LightningElement, track, wire } from 'lwc';
import getUserLocation from '@salesforce/apex/TreatmentByDogLWCController.getUserLocation';
import getDogList from '@salesforce/apex/TreatmentByDogLWCController.getDogList';
import { publish, MessageContext } from 'lightning/messageService';
import DOG_SELECTED_CHANNEL from '@salesforce/messageChannel/DogSelectedChannel__c';

const DELAY = 200;

export default class TreatmentByDogSelection extends LightningElement {
    userLocation = [];
    dogList = [];
    connectedCallbackRan = false;
    error;
    showSpinner = true;
    showQuerySpinner = false;
    delayTimeout;
    filterText = '';

    @wire(MessageContext)
    messageContext;

    @track locationsDisplay = [];

    connectedCallback(){
        if(!this.connectedCallbackRan ){
            this.connectedCallbackRan = true;
            getUserLocation()
            .then((result) => {
                this.userLocation = result;
                this.selectedLocations = result;
                let locDisplay = [];
                result.forEach(loc => {
                    locDisplay.push ({
                        location: loc,
                        selected: true
                    })
                });
                window.console.log('locationsDisplay: ', JSON.stringify(locDisplay));
                window.console.log('result: ', JSON.stringify(result));
                this.locationsDisplay = locDisplay;
            }) 
            .catch(error => {
                this.error = error;
            })
            .finally(() =>{
                this.showSpinner = false;
            });
        }
    }

    selectedLocations = [];
    wireResponse;
    @wire(getDogList, {selectedLocations: '$selectedLocations', filterText: '$filterText'})
    response(result){
        this.wireResponse = result;
        if(result.data ){
            this.dogList = result.data;
            window.console.log("dogs: ", JSON.stringify(result.data));
            this.showSpinner = false;
        } else if(result.error){
            this.error = result.error;
            this.showSpinner = false;
        }
    }

    selectedARCCARE(){
        this.selectedLocations = ["ARC","CARE"];
    }

    selectedALL(){
        this.selectedLocations = ["ARC","CARE","ARC/CARE","CRC","MRC"];
    }

    handleLocationToggle(event){
        let loc = this.locationsDisplay.find(location => location.location == event.target.dataset.loc);
        loc.selected = !loc.selected;

        let updatedLocations = [];
        this.locationsDisplay.forEach(loc => {
            if(loc.selected){
                updatedLocations.push(loc.location);
            }
        });
        this.selectedLocations = updatedLocations;
    }

    handleToggleChange(event){
        const evt = event.target;
        window.console.log("selectedDog: ", evt.dataset.id);
        window.console.log("checked: ", evt.checked);
        let dog = this.dogList.find(dog => dog.id == evt.dataset.id);
        
        const payload = { recordId: dog.id, isSelected: evt.checked};

        publish(this.messageContext, DOG_SELECTED_CHANNEL, payload);
        
    }

    //When user is typing in the text box, update the query
    handleInputChange(event){
        window.clearTimeout(this.delayTimeout);
        let searchKey = event.target.value;
        this.showSpinner = true;
        this.delayTimeout = setTimeout(() => {
            if(searchKey.length >= 2 || searchKey.length == 0){
                this.filterText = searchKey;
            }
        }, DELAY);
    }
}