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
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/lightning/n/MRC_Treatment_Plan_Report'
            }
        },
        false
        );
    }

    get showTreatmentPlansButton(){
        return this.toDisplay != undefined && this.toDisplay.mrcTreatmentPlansReport;
    }
}