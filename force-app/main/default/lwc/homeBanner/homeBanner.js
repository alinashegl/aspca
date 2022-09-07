import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getButtonsInfo from '@salesforce/apex/HomeBannerLWCController.getButtonsInfo';

export default class HomeBanner extends NavigationMixin(LightningElement) {
    toDisplay;
    

    connectedCallback(){
        if(this.toDisplay == undefined){
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
        this.handleNavigation('/lightning/n/Treatments_By_Dog');
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