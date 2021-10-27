import { api, LightningElement, track } from 'lwc';
import PLAYGROUP_PRIORITY_LEVEL from '@salesforce/schema/Animal__c.Playgroup_Priority_Level__c';
import PLAY_CATEGORY from '@salesforce/schema/Animal__c.Play_Category__c';
import PLAY_STYLE_NOTES from '@salesforce/schema/Animal__c.Play_Style_Notes__c';

export default class PlaygroupToDoSection extends LightningElement {
    @api
    recordId;
    @track
    isSelected = false;
    fields = [PLAYGROUP_PRIORITY_LEVEL, PLAY_CATEGORY, PLAY_STYLE_NOTES];

    handleClick() {
        this.isSelected = !this.isSelected;
    }
}