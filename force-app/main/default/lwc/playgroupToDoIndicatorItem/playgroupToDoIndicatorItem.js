import { api, LightningElement } from 'lwc';

export default class PlaygroupToDoIndicatorItem extends LightningElement {
    @api
    condition;
    conditionIcon = new Map([
        ['Babesia', 'utility:add']
    ]);

    get hasIcon() {
        return this.conditionIcon.has(this.condition);
    }

    get iconName() {
        return this.conditionIcon.get(this.condition);
    }
}