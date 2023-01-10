import { LightningElement, api, wire, track} from 'lwc';
import getVerticalTabs from '@salesforce/apex/BehEvalTemplateLWCController.getVerticalTabs';

export default class BehEvalTemplateMain extends LightningElement {
    @api recordId;
    @track tabs = [];

    selectedNavItem;
    activeTab;

    @wire(getVerticalTabs, {templateId : '$recordId'})
    response(result) {
        if(result.data){
            this.tabs = result.data;
            this.selectedNavItem = this.tabs[0].Id;
            this.activeTab = this.tabs[0];
        }
    };

    handleNavigationSelect(event){
        const selectedId = event.detail.name;
        this.selectedNavItem = selectedId;
        this.setActiveTab();
    }

    setActiveTab(){
        var foundIndex = this.tabs.findIndex(x => x.Id == this.selectedNavItem);
        this.activeTab = this.tabs[foundIndex];
    }
}