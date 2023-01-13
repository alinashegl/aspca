import { LightningElement, api } from 'lwc';
//import NoHeader from '@salesforce/resourceUrl/NoHeader';
//import { loadStyle } from 'lightning/platformResourceLoader';
import getButtonsInfo from '@salesforce/apex/HomeBannerLWCController.getButtonsInfo';
import { NavigationMixin } from 'lightning/navigation';

export default class TodoList extends NavigationMixin(LightningElement) {
    toDisplay;
    @api appName;
    @api appUrl;
    
    connectedCallback(){
        //loadStyle(this, NoHeader);
        if(this.toDisplay == undefined && this.appName == 'CRC Behavior Database'){
            window.console.log('inConnectedCallback');
            getButtonsInfo()
            .then((result) => {
                this.toDisplay = result;
            });
        }
    }

    handleLaunchMrcTreatmentPlans(){
        this.handleNavigation('/lightning/n/MRC_Treatment_Plan_Report');
    }

    handleLaunchTreatmentByDogs(){
        this.handleNavigation('/lightning/n/' + this.appUrl);
    }

    handleNavigation(url){
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: url
            }
        },
        false
        );
    }

    get showTreatmentPlansButton(){
        return this.toDisplay != undefined && this.toDisplay.mrcTreatmentPlansReport;
    }
}