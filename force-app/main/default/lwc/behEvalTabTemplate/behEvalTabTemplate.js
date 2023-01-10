import { LightningElement, api, wire, track } from 'lwc';
import getActivitySectionsForTab from '@salesforce/apex/BehEvalTemplateLWCController.getActivitySectionsForTab';

import TAB_LABEL from '@salesforce/schema/Beh_Eval_Tab_Template__c.Label__c';
import TAB_NAME from '@salesforce/schema/Beh_Eval_Tab_Template__c.Name';
import TAB_DISPLAY_NAME from '@salesforce/schema/Beh_Eval_Tab_Template__c.Display_Name__c';
import TAB_DISPLAY_ORDER from '@salesforce/schema/Beh_Eval_Tab_Template__c.Display_ORDER__c';
import TAB_DISCRIPTION from '@salesforce/schema/Beh_Eval_Tab_Template__c.Description__c';
import TAB_HAS_NESTED_TABS from '@salesforce/schema/Beh_Eval_Tab_Template__c.Has_Nested_Tabs__c';
import TAB_SKIP_REASONS from '@salesforce/schema/Beh_Eval_Tab_Template__c.Skip_Reasons__c';
import TAB_SKIP_SUBSEQUENT from '@salesforce/schema/Beh_Eval_Tab_Template__c.Skip_Subsequent_Activities__c';
import TAB_ALLOW_PUBLIC_COMMENTS from '@salesforce/schema/Beh_Eval_Tab_Template__c.Allow_Public_Comments__c';


export default class BehEvalTabTemplate extends LightningElement {
    labelField = TAB_LABEL;
    nameField = TAB_NAME;
    displayNameField = TAB_DISPLAY_NAME;
    displayOrderField = TAB_DISPLAY_ORDER;
    descriptionField = TAB_DISCRIPTION;
    hasNestedTabsField = TAB_HAS_NESTED_TABS;
    skipReasonsField = TAB_SKIP_REASONS;
    skipSubsequentField = TAB_SKIP_SUBSEQUENT;
    allowPublicCommentsField = TAB_ALLOW_PUBLIC_COMMENTS;

    @api tabId;

    @track activitySections = [];

    @wire(getActivitySectionsForTab, {tabId : '$tabId'})
    response(result) {
        if(result.data){
            window.console.log('result: ', JSON.stringify(result.data));
            this.activitySections = result.data;
        }
    }
}