import { LightningElement, api, track, wire } from 'lwc';
import getEvalTests from '@salesforce/apex/BehaviorEvaluationLWCController.getEvalTests';


export default class BehaviorEvaluationMain extends LightningElement {
    @api recordId;
    // evalTests;
    @track tabs = [];
    activeTab;
    
    error;
    errorMessage;

    @wire(getEvalTests, {evalId : '$recordId'}) 
    response(result) {
        if(result.data){
            // this.evalTests = result.data;
            this.tabs = JSON.parse(JSON.stringify(result.data.tabList));
            this.activeTab = this.tabs[0].label;
        }
        else if(result.error){
            this.errorMessage = 'Error retrieving the evaluation and tests:';
            this.error = result.error;
        }
    }

    renderedCallback(){
        this.tabs.forEach(tab => {
            let tabId = tab.id;
            tabId = tabId.replace(/['"]+/g, '');
            //cannot add color when value parameter is added to tab????
            // this.addColorToIcon(tabId, tab.status);
        });
    }

    handleComplete(event){
        let tabId = event.target.dataset.id;
        tabId = tabId.replace(/['"]+/g, '');

        var foundIndex = this.tabs.findIndex(x => x.id == tabId);
        this.tabs[foundIndex].iconName = "utility:success";

        //cannot add color when value parameter is added to tab????
        // this.addColorToIcon(tabId, "complete");
    }

    handleSkip(event){
        let tabId = event.target.dataset.id;
        tabId = tabId.replace(/['"]+/g, '');

        var foundIndex = this.tabs.findIndex(x => x.id == tabId);
        this.tabs[foundIndex].iconName = "utility:error";
        //cannot add color when value parameter is added to tab????
        // this.addColorToIcon(tabId, "skip");
    }

    addColorToIcon(tabId, status){
        let tabIcon  = this.template.querySelector('[data-id="' +tabId+ '"]');
        let tabIconId = tabIcon.getAttribute("aria-labelledby");
        const firstStyleCss = document.createElement('style');
        if(status == "complete"){
            firstStyleCss.innerText = ` .tabsetCss #${tabIconId} .slds-icon-utility-success svg {
                                    fill:green !important;
                                    }
                                `;
        }
        else if(status == "skip"){
            firstStyleCss.innerText = ` .tabsetCss #${tabIconId} .slds-icon-utility-error svg {
                fill:red !important;
                }
            `;
        }
        else{
            firstStyleCss.innerText = ` .tabsetCss #${tabIconId} .slds-icon-utility-warning svg {
                fill:orange !important;
                }
            `;
        }

        if (this.template.querySelector('lightning-tabset') != null) {
            this.template.querySelector('lightning-tabset').appendChild(firstStyleCss);
        }
    }

    handleButtonClick(event){
        let info = event.target.dataset.id;
        info = info.replace(/['"]+/g, '');
        this.isComplete = true;
        this.tabs[0].icon = "utility:success";

        let tabIcon  = this.template.querySelector('[data-id="' +info+ '"]');
        let tabIconId = tabIcon.getAttribute("aria-labelledby");
        const firstStyleCss = document.createElement('style');
        firstStyleCss.innerText = ` .tabsetCss #${tabIconId} .slds-icon-utility-success svg {
                                fill:green !important;
                                }
                            `;
        if (this.template.querySelector('lightning-tabset') != null) {
            this.template.querySelector('lightning-tabset').appendChild(firstStyleCss);
        }
    }

    activeTab = this.tabs

    handleNext(event){
        let tabId = event.target.dataset.id;
        var foundIndex = this.tabs.findIndex(x => x.id == tabId);
        if(foundIndex < this.tabs.length - 1){
            this.activeTab = this.tabs[foundIndex + 1].label;
        } else {
            this.activeTab = this.tabs[0].label;
        }
    }

    handlePrevious(event){
        let tabId = event.target.dataset.id;
        var foundIndex = this.tabs.findIndex(x => x.id == tabId);
        if(foundIndex > 0){
            this.activeTab = this.tabs[foundIndex - 1].label;
        } else {
            this.activeTab = this.tabs[this.tabs.length -1].label;
        }
    }
    

}