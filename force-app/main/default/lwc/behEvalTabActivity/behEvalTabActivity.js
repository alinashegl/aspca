import { LightningElement, api, wire } from 'lwc';
import getActivities from '@salesforce/apex/BehEvalTemplateLWCController.getActivities';

import ACTIVITY_SECTION from '@salesforce/schema/Beh_Eval_Tab_Activitiy__c.Section__c';
import ACTIVITY_ORDER from '@salesforce/schema/Beh_Eval_Tab_Activitiy__c.Order__c';
import ACTIVITY_REQUIRED from '@salesforce/schema/Beh_Eval_Tab_Activitiy__c.Required__c';
import ACTIVITY_LABEL from '@salesforce/schema/Beh_Eval_Tab_Activitiy__c.Label__c';


export default class BehEvalTabActivity extends LightningElement {
    sectionField = ACTIVITY_SECTION;
    orderField = ACTIVITY_ORDER;
    requiredField = ACTIVITY_REQUIRED;
    labelField = ACTIVITY_LABEL;

    @api activityId;

    connectedCallback(){
        window.console.log('BehEvalTabActivity');
    }

    // @wire(getActivities, {tabId : '$tabId'})
    // response(result) {

    // }
}