import { LightningElement, api, track, wire } from 'lwc';
import getEvalTests from '@salesforce/apex/BehaviorEvaluationLWCController.getEvalTests';


export default class BehaviorEvaluationMain extends LightningElement {
    @api recordId;
    evalTests;
    @track tabs = [];

    error;
    errorMessage;

    @wire(getEvalTests, {evalId : '$recordId'}) 
    response(result) {
        if(result.data){
            this.evalTests = result.data;
            this.tabs = [...result.data.tabList];
            // this.addIcons();
        }
        else if(result.error){
            this.errorMessage = 'Error retrieving the evaluation and tests:';
            this.error = result.error;
        }
    }

    addIcons(){
        this.tabs.forEach(tab => {            
            let tabIcon  = this.template.querySelector('[data-id="' +tab.id+ '"]');
            let tabIconId = tabIcon.getAttribute("aria-labelledby");
            this.addColorToIcon(tab.id, tab.status);

            const firstStyleCss = document.createElement('style');
            firstStyleCss.innerText = ` .tabsetCss #${tabIconId} .slds-icon-utility-warning svg {
                                    fill:orange !important;
                                    }
                                `;
            if (this.template.querySelector('lightning-tabset') != null) {
                this.template.querySelector('lightning-tabset').appendChild(firstStyleCss);
            }
        });
    }

    handleComplete(event){
        let tabId = event.target.dataset.id;
        window.console.log('tabid: ', tabId);
        tabId = tabId.replace(/['"]+/g, '');

        var foundIndex = this.tabs.findIndex(x => x.id == tabId);
        this.tabs[foundIndex].icon = "utility:success";
        this.addColorToIcon(tabId, "complete");
    }

    handleSkip(event){
        let tabId = event.target.dataset.id;
        window.console.log('tabid: ', tabId);
        tabId = tabId.replace(/['"]+/g, '');

        var foundIndex = this.tabs.findIndex(x => x.id == tabId);
        this.tabs[foundIndex].icon = "utility:error";
        this.addColorToIcon(tabId, "skip");
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
        window.console.log('tabid: ', info);
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

    

}