import { LightningElement, wire } from 'lwc';
import getBehCaseWorkers from '@salesforce/apex/ArcCareAnimalDogListController.getBehCaseWorkers';
import getAnimals from '@salesforce/apex/ArcCareAnimalDogListController.getRecords';
import updateRecords from '@salesforce/apex/ArcCareAnimalDogListController.saveRecords';
import getPicklistValue from '@salesforce/apex/ArcCareAnimalDogListController.getPicklistValue';
import getAnimalGender from '@salesforce/apex/ArcCareAnimalDogListController.getAnimalGender';

 const columns = [
    {label: 'ASPCA Animal Name', fieldName: 'Animal_Name__c',type: 'text', editable: false, disabled: true, sortable: true},
    {label: 'Animal Name/Id', fieldName: 'Id', type: 'link', linkLabel: 'anmName', sortable: true}, 
    {label: 'Petpoint/AAH Id', fieldName: 'Petpoint_ID__c',linkLabel: 'petpint', type: 'text', editable: false, disabled: true, sortable: true},
    {label: 'Sex', fieldName: 'Gender__c', type: 'picklist', sortable: true, resizable: true,editable: true},
    {label: 'Evaluation Status', fieldName: 'Evaluation_Status__c', type: 'picklist', sortable: true, resizable: true, editable: true},
    {label: 'Current Location', fieldName: 'Current_Location__c',type: 'text', disabled: true, sortable: true},
    {label: 'Hold Status ARC/CARE', fieldName: 'Hold_Status_ARC_CARE__c', type: 'multi-select', sortable: true, resizable: true, editable: true},
    {label: 'Behavior Case Worker', fieldName: 'Behavior_Case_Worker__c', type: 'lookup', linkLabel: 'behName', sortable: true, resizable: true, editable: true,sortBy: 'behName', title:'Click to view Behavior Case Worker', iconName:'standard:contact'},
    {label: 'Walking Status', fieldName: 'Walking_Status__c', type: 'multi-select', sortable: true, resizable: true, editable: true},
    {label: 'Walking Notes', fieldName: 'Walking_Notes__c',type: 'textArea', resizable: true, editable: true, disabled: false, sortable: true},
    {label: 'PPE/DOH', fieldName: 'PPE_DOH__c', type: 'picklist', sortable: true, resizable: true,editable: true},
    {label: 'Important Notes ARC/CARE', fieldName: 'Important_Notes_ARC_CARE__c',type: 'textArea', resizable: true, editable: true, sortable: true},
    
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

    @wire(getAnimalGender)
    wGetGenders({error, data}){
        if(data){
            this.columns[3].options = data;
        }else{
            this.error = error;
        } 
    }

    connectedCallback(){
        this.getWalkingStatus();
        this.getHoldStatus();
        this.getPPEDOHStatus();
        this.getEvaluationStatus();
    }

    getWalkingStatus(){
        getPicklistValue({
            objectname: 'Animal__c',
            fieldname : 'Walking_Status__c'
        }).then(data=>{
            this.columns[8].options = data;
        })
    }

    getHoldStatus(){
        getPicklistValue({
            objectname: 'Animal__c',
            fieldname : 'Hold_Status_ARC_CARE__c'
        }).then(data=>{
            this.columns[6].options = data;
        })
    }

    getEvaluationStatus(){
        getPicklistValue({
            objectname: 'Animal__c',
            fieldname : 'Evaluation_Status__c'
        }).then(data=>{
            this.columns[4].options = data;
        })
    }

    getPPEDOHStatus(){
        getPicklistValue({
            objectname: 'Animal__c',
            fieldname : 'PPE_DOH__c'
        }).then(data=>{
            this.columns[10].options = data;
        })
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
                obj.petpint = (data[i].hasOwnProperty('Petpoint_ID__c') && data[i].Petpoint_ID__c) ? data[i].Petpoint_ID__c : (data[i].hasOwnProperty('AAH_ID__c') ? data[i].AAH_ID__c : '');
                obj.Petpoint_ID__c = obj.petpint;
                obj.anmName = data[i].Animal_Name_Id__c;
                this.anms.push(obj);
            }
            this.showTable = true;
            this.isLoading = false;
        })
        .catch(error=>{
            this.error = JSON.stringify(error);
            this.showTable = true;
            this.isLoading = true;
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