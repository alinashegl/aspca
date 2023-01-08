import { LightningElement, api, wire, track} from 'lwc';
import getVerticalTabs from '@salesforce/apex/BehEvalTemplateLWCController.getVerticalTabs';

export default class BehEvalTemplateMain extends LightningElement {
    @api recordId;
    @track tabs = [];

    @wire(getVerticalTabs, {templateId : '$recordId'})
    response(result) {
        if(result.data){
            this.tabs = result.data;
        }
    };
}