/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */
import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class LwcFlowScreenNavigator extends NavigationMixin(LightningElement) {
    @api buttonName;
    @api recordId;
    @api apiName

    recordURL;

    connectedCallback() {
        this[NavigationMixin.GenerateUrl]({
           type: 'standard_recordPage' ,
           attributes: {
               recordId: recordId ,
               objectApiName: apiName ,
               actionName: 'view'
           }
        }).then(url => {
            this.recordURL = url;
        });
    }
    handleClick(evt) {
        evt.preventDefault();
        evt.stopPropagation();
        this[NavigationMixin.Navigate](this.connectedCallback);
    }



}