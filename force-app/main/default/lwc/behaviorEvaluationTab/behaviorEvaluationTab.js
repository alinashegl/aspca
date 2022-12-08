import { LightningElement, api } from 'lwc';
// import getEvalSummary from '@salesforce/apex/BehaviorEvaluationLWCController.getEvalSummary';


export default class BehaviorEvaluationTab extends LightningElement {
    @api tab;

    // renderedCallback(){
    //     let tabIcon  = this.template.querySelector('[data-id="' +this.tab.label+ '"]');
    //     let tabIconId = tabIcon.getAttribute("aria-labelledby");

    //     const firstStyleCss = document.createElement('style');
    //     firstStyleCss.innerText = ` .tabsetCss #${firstIconId} .slds-icon-utility-error svg {
    //                             fill:red !important;
    //                             }
    //                         `;
    //     if (this.template.querySelector('lightning-tabset') != null) {
    //         this.template.querySelector('lightning-tabset').appendChild(firstStyleCss);
    //     }
    // }

    // handleButtonClick(event){
    //     this.isComplete = true;

    //     let tabIcon  = this.template.querySelector('[data-id="' +this.tab.label+ '"]');
    //     let tabIconId = tabIcon.getAttribute("aria-labelledby");
    //     const firstStyleCss = document.createElement('style');
    //     firstStyleCss.innerText = ` .tabsetCss #${tabIconId} .slds-icon-utility-success svg {
    //                             fill:green !important;
    //                             }
    //                         `;
    //     if (this.template.querySelector('lightning-tabset') != null) {
    //         this.template.querySelector('lightning-tabset').appendChild(firstStyleCss);
    //     }

    // }

    // isComplete = false;

    // get iconName(){
    //     return this.isComplete ? "utility:success" : "utility:eror";
    // }
}