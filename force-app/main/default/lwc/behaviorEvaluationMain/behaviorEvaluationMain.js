import { LightningElement, api, track, wire } from 'lwc';
import getEvalTests from '@salesforce/apex/BehaviorEvaluationLWCController.getEvalTests';


export default class BehaviorEvaluationMain extends LightningElement {
    @api recordId;
    @track tabs = [];
    currentTab;
    
    error;
    errorMessage;

    @wire(getEvalTests, {evalId : '$recordId'}) 
    response(result) {
        if(result.data){
            this.tabs = JSON.parse(JSON.stringify(result.data.tabList));
            window.console.log('tabs: ', JSON.stringify(this.tabs));
            this.selectedNavItem = this.tabs[0].label;
            if(this.activeTab == undefined || this.activeTab == null){
                this.activeTab = this.tabs[0];
            }
        }
        else if(result.error){
            this.errorMessage = 'Error retrieving the evaluation and tests:';
            this.error = result.error;
        }
    }
    
    handleComplete(){
        this.activeTab.status = "Success";
        this.activeTab.iconName = "utility:success";
    }

    handleSkip(){
        this.activeTab.status = "Error";
        this.activeTab.iconName = "utility:error";

    }

    handleNext(){
        // let tabId = event.target.dataset.id;
        var foundIndex = this.tabs.findIndex(x => x.label == this.selectedNavItem);
        if(foundIndex < this.tabs.length - 1){
            this.activeTab = this.tabs[foundIndex + 1];
            this.selectedNavItem = this.activeTab.label;
        } else {
            this.activeTab = this.tabs[0];
            this.selectedNavItem = this.activeTab.label;
        }
    }

    handlePrevious(){
        var foundIndex = this.tabs.findIndex(x => x.label == this.selectedNavItem);
        if(foundIndex > 0){
            this.activeTab = this.tabs[foundIndex - 1];
            this.selectedNavItem = this.activeTab.label;
        } else {
            this.activeTab = this.tabs[this.tabs.length -1];
            this.selectedNavItem = this.activeTab.label;
        }
    }


    /****vertical navigation */
    activeTab;
    selectedNavItem = "In Kennel";
    handleNavigationSelect(event){
        const selectedName = event.detail.name;
        this.selectedNavItem = selectedName;
        this.setActiveTab();
    }

    setActiveTab(){
        var foundIndex = this.tabs.findIndex(x => x.label == this.selectedNavItem);
        this.activeTab = this.tabs[foundIndex];
    }
}