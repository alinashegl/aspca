import { LightningElement, wire } from 'lwc';
import getBehCaseWorkers from '@salesforce/apex/ArcCareAnimalDogListController.getBehCaseWorkers';
import getAnimals from '@salesforce/apex/ArcCareAnimalDogListController.getRecords';
import updateRecords from '@salesforce/apex/ArcCareAnimalDogListController.saveRecords';

const GENDEROPTIONS = [
    { label: 'MI', value: 'MI' },
    { label: 'FI', value: 'FI' },
    { label: 'FS', value: 'FS' },
    { label: 'FU', value: 'FU' },
    { label: 'MN', value: 'MN' },
    { label: 'MU', value: 'MU' },
    { label: 'Unknown', value: 'Unknown' },
    { label: '(Unknown)', value: '(Unknown)' },
    { label: 'Stallion', value: 'Stallion' },
    { label: 'Mare', value: 'Mare' },
    { label: 'Gelding', value: 'Gelding' },
    { label: 'Colt (<3 years)', value: 'Colt (<3 years)' },
    { label: 'Filly (<3 years)', value: 'Filly (<3 years)' }
];

const EVALSTATUSOPTIONS = [
    {value: 'Complete', label: 'Complete'},
    {value: 'Pending', label: 'Pending'},
    {value: 'Incomplete', label: 'Incomplete'},
    {value: 'Needs Dog-Dog', label: 'Needs Dog-Dog'},
    {value: 'N/A', label: 'N/A'}
];

const HOLDSTATUSOPTIONS = [
    {value: 'RTA', label: 'RTA', selected: false},
    {value: 'RTO', label: 'RTO', selected: false},
    {value: 'Legal', label: 'Legal', selected: false},
    {value: 'Medical', label: 'Medical', selected: false},
    {value: 'Behavior', label: 'Behavior', selected: false},
    {value: 'Forensic', label: 'Forensic', selected: false}
];

const WALKINGSTATUSOPTIONS = [
    {value: 'None Specified', label: 'None Specified', selected: false},
    {value: 'No Walks', label: 'No Walks', selected: false},
    {value: 'Terrace Walks', label: 'Terrace Walks', selected: false},
    {value: 'Inside Walks', label: 'Inside Walks', selected: false},
    {value: 'Outside Walks', label: 'Outside Walks', selected: false},
    {value: '2 person Walks', label: '2 person Walks', selected: false},
    {value: 'Ok to take the Stairs', label: 'Ok to take the Stairs', selected: false}
];

const PPEOPTIONS = [
    {value: 'Yes – ACC/CIRDC', label: 'Yes – ACC/CIRDC'},
    {value: 'Yes – Parasites', label: 'Yes – Parasites'},
    {value: 'Yes – Other', label: 'Yes – Other'},
    {value: 'DOH Hold', label: 'DOH Hold'},
];

const columns = [
    {label: 'ASPCA Animal Name', fieldName: 'Animal_Name__c',type: 'text', editable: false, disabled: true, sortable: true},
    {label: 'Animal Name/Id', fieldName: 'Id', type: 'link', linkLabel: 'anmName'}, 
    {label: 'Petpoint/AAH Id', fieldName: 'Petpoint_ID__c',linkLabel: 'petpint', type: 'text', editable: false, disabled: true, sortable: true},
     //sortable: true, sortBy: 'anmName', resizable: true, title:'Click to view Animal', target:'_blank', editable: true},
    {label: 'Sex', fieldName: 'Gender__c', type: 'picklist', options: GENDEROPTIONS, sortable: true, resizable: true,editable: true},
    {label: 'Evaluation Status', fieldName: 'Evaluation_Status__c', type: 'picklist', options: EVALSTATUSOPTIONS, sortable: true, resizable: true, editable: true},
    {label: 'Current Location', fieldName: 'Current_Location__c',type: 'text', disabled: true},
    {label: 'Hold Status ARC/CARE', fieldName: 'Hold_Status_ARC_CARE__c', type: 'multi-select', options: HOLDSTATUSOPTIONS, sortable: true, resizable: true, editable: true},
    // {label: 'Hold Status ARC/CARE', fieldName: 'Hold_Status_ARC_CARE__c', type: 'multi-select', options: HOLDSTATUSOPTIONS, sortable: true, resizable: true, editable: true},
    {label: 'Behavior Case Worker', fieldName: 'Behavior_Case_Worker__c', type: 'lookup', linkLabel: 'behName',
     sortable: true, resizable: true, editable: true,sortBy: 'behName', title:'Click to view Behavior Case Worker', iconName:'standard:contact'},
    {label: 'Walking Status', fieldName: 'Walking_Status__c', type: 'multi-select', options: WALKINGSTATUSOPTIONS, sortable: true, resizable: true, editable: true},
    {label: 'Walking Notes', fieldName: 'Walking_Notes__c',type: 'textArea', resizable: true, editable: true, disabled: false},
    {label: 'PPE/DOH', fieldName: 'PPE_DOH__c', type: 'picklist', options: PPEOPTIONS, sortable: true, resizable: true,editable: true},
    {label: 'Important Notes ARC/CARE', fieldName: 'Important_Notes_ARC_CARE__c',type: 'textArea', resizable: true, editable: true},
    
];
const PAGESIZEOPTIONS = [5,10,20,40];

export default class VkDatatableUsage extends LightningElement {
    error;
    columns = columns;
    anms;
    showTable = false;
    pageSizeOptions = PAGESIZEOPTIONS;
    isLoading = true;
    loadMessage = 'Loading...';
    customStyle = 'height:700px !important';
    @wire(getBehCaseWorkers)
    wAccs({error,data}){
        if(data){
            let contacts = [];
            for(let i=0; i<data.length; i++){
                let obj = {value: data[i].Id, label: data[i].Name};
                contacts.push(obj);
            }
            this.columns[7].options = contacts;
            this.getAnimals_();
        }else{
            this.error = error;
        }       
    }

    connectedCallback(){
        //
    }

    getAnimals_(){
        this.showTable = false;
        this.loadMessage = 'Loading...';
        this.isLoading = true;
        this.error = '';
        getAnimals()
        .then(data=>{
            this.anms = [];
            for(let i=0; i<data.length; i++){
                let obj = {...data[i]};
                if(data[i].hasOwnProperty('Behavior_Case_Worker__c')){
                    obj.behName = data[i].Behavior_Case_Worker__r.Name;
                }
                obj.petpint = data[i].hasOwnProperty('Petpoint_ID__c') ? data[i].Petpoint_ID__c : (data[i].hasOwnProperty('AAH_ID__c') ? data[i].AAH_ID__c : '');
                obj.anmName = data[i].Animal_Name_Id__c;
                this.anms.push(obj);
            }
            this.showTable = true;
            this.isLoading = false;
        })
        .catch(error=>{
            this.error = JSON.stringify(error);
            this.showTable = true;
            this.isLoading = false;
        });       
    }

    handleRowSelection(event){
        console.log('Records selected***'+JSON.stringify(event.detail));
    }

    saveRecords(event){
        this.loadMessage = 'Saving...';
        this.isLoading = true;
        this.error = '';
        updateRecords({recsString: JSON.stringify(event.detail)})
        .then(response=>{
            if(response==='success') this.getAnimals_();
        })
        .catch(error=>{
            console.log('recs save error***'+error);
            this.error = JSON.stringify(error);
            this.isLoading = false;
        });
    }
}