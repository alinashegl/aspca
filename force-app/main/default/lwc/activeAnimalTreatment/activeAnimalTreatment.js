import { LightningElement, api, wire, track } from 'lwc';
import getAnmialTreatement from '@salesforce/apex/HomePageController.getAnmialTreatement';

export default class ActiveAnimalTreatment extends LightningElement {
    @track gridColumns =[
        {
            type: 'text',
            fieldName: 'Name',
            label: 'Name'
        },
        {
            type: 'text',
            fieldName: 'location',
            label: 'Location',
        },
        {
            type: 'text',
            fieldName: 'treatmentPriority',
            label: 'Treatment Priority',
        },
        // {
        //     type: 'text',
        //     fieldName: 'PlanId',
        //     label: 'ID',
        // },
        /*{
            type: 'text',
            fieldName: 'ProtocolName',
            label: 'Protocol Name',
        },*/
        {
            type: 'text',
            fieldName: 'Protocol',
            label: 'Protocol',
        }
    ];

    @track error;
    @track gridData ;
    @track expandRows;
    @wire(getAnmialTreatement)
    wiredData({
        error,
        data
    }) {
        if (data) {
            let parseData = JSON.parse(JSON.stringify(data));
            for(let i=0; i< parseData.length; i++){
                var cons = parseData[i][ 'children'];
                if ( cons ) {
                    parseData[i]._children = cons;
                    delete parseData[i].children;
                }
          1  }
          console.log(parseData);
            this.gridData =  parseData;
        } else if (error) {
            this.error = error;
        }
    }
    get expandRowItems(){
        return this.expandRows;
    }
}