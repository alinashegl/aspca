import { api, LightningElement } from 'lwc';

export default class PlaygroupToDoIndicators extends LightningElement {
    @api
    babesia = false;
    @api
    inHeat = false;
    @api
    handlerCode;

    get showHandler() {
        return this.handlerCode != undefined && this.handlerCode !== '' && !this.handlerCode.startsWith('Green');
    }

    get handlerVariant() {
        let colorClass;
        if (this.handlerCode.startsWith('Yellow')) {
            colorClass = 'yellowIcon';
        }
        else if (this.handlerCode.startsWith('Purple')) {
            colorClass = 'purpleIcon';
        }
        else if (this.handlerCode.startsWith('Red')) {
            colorClass = 'redIcon';
        }
        else if (this.handlerCode.startsWith('Blue')) {
            colorClass = 'blueIcon';
        }
        else if (this.handlerCode.startsWith('Black')) {
            colorClass = 'blackIcon';
        }
        return colorClass;
    }
}