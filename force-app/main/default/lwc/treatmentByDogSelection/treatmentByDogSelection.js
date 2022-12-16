import { LightningElement, track, wire, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getUserLocation from '@salesforce/apex/TreatmentByDogLWCController.getUserLocation';
import getDogList from '@salesforce/apex/TreatmentByDogLWCController.getDogList';
import { publish, MessageContext } from 'lightning/messageService';
import DOG_SELECTED_CHANNEL from '@salesforce/messageChannel/DogSelectedChannel__c';

const DELAY = 200;

export default class TreatmentByDogSelection extends NavigationMixin(LightningElement) {
    userLocation = [];
    @track dogList = [];
    connectedCallbackRan = false;
    error;
    showSpinner = true;
    showQuerySpinner = false;
    delayTimeout;
    filterText = '';
    selectedDogs = [];

    @api appName;
    @api allowedLocationsString;
    allowedLocationsList;

    @wire(MessageContext)
    messageContext;

    @track locationsDisplay = [];

    connectedCallback(){
        if(!this.connectedCallbackRan ){
            this.connectedCallbackRan = true;
            this.allowedLocationsList = this.allowedLocationsString.split(",");
            getUserLocation()
            .then((result) => {
                this.userLocation = result;
                // this.selectedLocations = result;
                let locDisplay = [];

                result.forEach(loc => {
                    if(this.allowedLocationsList.includes(loc)){
                        if(this.appName == 'CRC Dog Database' && loc == 'CRC'){
                            locDisplay.push ({
                                location: loc,
                                selected: true
                            })
                        }
                        else {
                            locDisplay.push ({
                                location: loc,
                                selected: false
                            })
                        }
                    }
                });
                window.console.log('locationsDisplay: ', JSON.stringify(locDisplay));
                window.console.log('result: ', JSON.stringify(result));
                this.locationsDisplay = locDisplay;
                this.updateLocationFilter();

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
            let tempDogList = JSON.parse(JSON.stringify(result.data));
            window.console.log("dogs: ", JSON.stringify(tempDogList));
            tempDogList.forEach(dog => {
                if(this.selectedDogs.includes(dog.id)){
                    dog.selected = true;
                }
            });

            this.dogList = tempDogList;
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
        this.selectedLocations = ["ARC","CARE","CRC","CRC-MRC"];
    }

    handleLocationToggle(event){
        let loc = this.locationsDisplay.find(location => location.location == event.target.dataset.loc);
        loc.selected = !loc.selected;
        this.updateLocationFilter();
        const element = this.template.querySelector("[data-name='selectAll']");
        element.checked = false;
    }

    updateLocationFilter(){
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
        let dog = this.dogList.find(dog => dog.id == evt.dataset.id);

        if(this.selectedDogs.includes(dog.id)){
            this.selectedDogs = this.selectedDogs.filter(item => item !== dog.id);
        } else {
            this.selectedDogs.push(dog.id);
        }
        
        
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

    handeSelectAllClick(event){
        const checked = event.target.checked;                   
        this.dogList.forEach(dog => {
            dog.selected = checked;

            // let dog = this.dogList.find(dog => dog.id == evt.dataset.id);

            if(checked == true && !this.selectedDogs.includes(dog.id)){
                this.selectedDogs.push(dog.id);
                const payload = { recordId: dog.id, isSelected: checked};
                publish(this.messageContext, DOG_SELECTED_CHANNEL, payload);
            } 
            else if(checked == false && this.selectedDogs.includes(dog.id)){
                this.selectedDogs = this.selectedDogs.filter(item => item !== dog.id);
                const payload = { recordId: dog.id, isSelected: checked};
                publish(this.messageContext, DOG_SELECTED_CHANNEL, payload);
            }
        });
    }
}